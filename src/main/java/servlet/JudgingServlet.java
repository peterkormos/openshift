package servlet;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

import datatype.judging.JudgedModel;
import datatype.judging.JudgingCriteria;
import datatype.judging.JudgingError;
import datatype.judging.JudgingResult;
import datatype.judging.JudgingScore;
import exception.MissingRequestParameterException;
import util.CommonSessionAttribute;
import util.LanguageUtil;

public final class JudgingServlet extends HttpServlet {
    public enum RequestParameter {
        Category, ModelID, ModellerID, Judge, JudgingCriteria, JudgingCriterias, Comment, ModelsName, Language
    }

    public enum RequestType {
        GetCategories, GetJudgingForm, SaveJudging, ListJudgings, DeleteJudgings, ListJudgingSummary, DeleteJudgingForm, Login
    }

    public enum SessionAttribute {
        JudgingCriteriasForCategory, Category, Judgings, Judge, Categories
    }

    private static final String VERSION = "2021.09.16.";
    private static final String JUDGING_FILENAME = "judging.txt";

    public static Logger logger = Logger.getLogger(JudgingServlet.class);;

    public final static String DEFAULT_PAGE = "judging.jsp";

    private final static String JSP_BASE_DIR = "/jsp/judging/";

    public static List<JudgingError> checkJudgingResults(Collection<JudgingResult> collection) {
        List<JudgingError> errors = new LinkedList<>();

        errors.addAll(checkJudgedCriteriasPerModel(collection));
        errors.addAll(checkIfModelandModelerCorelate(collection));
        errors.addAll(checkJudgedModelsPerCategory(collection));

        return errors;
    }

    public static ResourceBundle getLanguage(HttpSession session, HttpServletResponse response) throws IOException {
        ResourceBundle language = (ResourceBundle) session.getAttribute(CommonSessionAttribute.Language.name());
        if (language == null) {
            response.sendRedirect(DEFAULT_PAGE);
        }

        return language;
    }

    private static Collection<? extends JudgingError> checkIfModelandModelerCorelate(
            Collection<JudgingResult> collection) {
        Map<JudgingError, List<JudgingResult>> judgingResultsByModelId = collection.stream()
                .collect(Collectors.groupingBy(
                        judgingResult -> new JudgingError(judgingResult.getCategory(), judgingResult.getModelID())));

        for (Entry<JudgingError, List<JudgingResult>> judgingResults : judgingResultsByModelId.entrySet()) {
            List<Integer> modellerIds = judgingResults.getValue().stream()
                    .mapToInt(judgingResult -> judgingResult.getModellerID()).distinct().boxed()
                    .collect(Collectors.toList());

            if (modellerIds.size() != 1) {
                JudgingError judgingError = judgingResults.getKey();
                judgingError.setErrorMessage(String.format("modellerIds different on model forms: %s", modellerIds));
                judgingError.setErrorType(JudgingError.JudgingErrorType.ModelIdAndModellerID_Mismatch);
            }
        }

        return judgingResultsByModelId.keySet().stream().filter(JudgingError::isPresent).collect(Collectors.toList());
    }

    private static List<JudgingError> checkJudgedCriteriasPerModel(Collection<JudgingResult> collection) {
        Map<JudgingError, List<JudgingResult>> judgingResultsByModelId = collection.stream()
                .collect(Collectors.groupingBy(
                        judgingResult -> new JudgingError(judgingResult.getCategory(), judgingResult.getModelID())));

        for (Entry<JudgingError, List<JudgingResult>> judgingResults : judgingResultsByModelId.entrySet()) {
            List<Integer> totalNumberOfDifferentScores = judgingResults.getValue().stream().mapToInt(
                    judgingResult -> judgingResult.getScores().values().stream().mapToInt(AtomicInteger::get).sum())
                    .distinct().boxed().collect(Collectors.toList());

            if (totalNumberOfDifferentScores.size() != 1) {
                JudgingError judgingError = judgingResults.getKey();
                judgingError.setErrorMessage(String.format("total evaluated criterias on different model forms: %s",
                        totalNumberOfDifferentScores));
                judgingError.setErrorType(JudgingError.JudgingErrorType.TotalEvaluatedCriterias_Mismatch);
            }
        }

        return judgingResultsByModelId.keySet().stream().filter(JudgingError::isPresent).collect(Collectors.toList());
    }

    private static List<JudgingError> checkJudgedModelsPerCategory(Collection<JudgingResult> collection) {
        Map<String, List<JudgingResult>> judgingResultsByCategory = collection.stream()
                .collect(Collectors.groupingBy(JudgingResult::getCategory));

        List<JudgingError> returned = new LinkedList<>();

        for (Entry<String, List<JudgingResult>> judgingResults : judgingResultsByCategory.entrySet()) {
            String category = judgingResults.getKey();

            Map<String, List<JudgingResult>> judgedModelsPerJudge = judgingResults.getValue().stream()
                    .collect(Collectors.groupingBy(JudgingResult::getJudge));

            int currentlyJudgedModels = 0;
            String currentJudge = "";
            for (Entry<String, List<JudgingResult>> judgedModelPerJudge : judgedModelsPerJudge.entrySet()) {
                String judge = judgedModelPerJudge.getKey();

                if (currentlyJudgedModels == 0) {
                    currentlyJudgedModels = judgedModelPerJudge.getValue().size();
                    currentJudge = judge;
                }

                if (currentlyJudgedModels != judgedModelPerJudge.getValue().size()) {
                    JudgingError judgingError = new JudgingError(category,
                            judgedModelPerJudge.getValue().get(0).getModelID());
                    judgingError.setErrorType(JudgingError.JudgingErrorType.TotalEvaluatedModels_Mismatch);
                    judgingError.setErrorMessage(String.format("judged models are different: [%s: %d] - [%s: %d]",
                            currentJudge, currentlyJudgedModels, judge, judgedModelPerJudge.getValue().size()));
                    returned.add(judgingError);
                }
            }
            // .mapToInt(judgingResult -> judgingResult.getScores().values().stream().mapToInt(AtomicInteger::get).sum()).distinct()
            // .boxed().collect(Collectors.toList());
            //
            // List<Integer> modellerIds = judgingResults.getValue().stream()
            // .mapToInt(judgingResult -> judgingResult.getModellerID()).distinct()
            // .boxed().collect(Collectors.toList());
            //
            // if (modellerIds.size() != 1)
            // {
            // JudgingError judgingError = judgingResults.getKey();
            // judgingError.setErrorMessage(String.format("modellerIds different on model forms: %s", modellerIds));
            // judgingError.setErrorType(JudgingError.JudgingErrorType.ModelIdAndModellerID_Mismatch);
            // }
        }

        return returned;
    }

    private JudgingServletDAO dao;

    private LanguageUtil languageUtil = new LanguageUtil();

    private final Map<String, Properties> fileCache = new HashMap<>();

    public JudgingServlet() {
        super();
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        try {
            DOMConfigurator.configure(config.getServletContext().getResource("/WEB-INF/conf/log4j.xml"));

            logger.fatal("************************ Logging restarted ************************");
            System.out.println("VERSION: " + VERSION);
            logger.fatal("VERSION: " + VERSION);
            dao = new JudgingServletDAO(config.getServletContext().getResource("/WEB-INF/conf/hibernate.cfg.xml"));
        } catch (final MalformedURLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo != null) {
                pathInfo = pathInfo.substring(1);

                switch (RequestType.valueOf(pathInfo)) {
                case GetCategories:
                    getCategories(request, response);
                    break;

                case GetJudgingForm:
                    getJudgingForm(request, response, true /* isForModification */);
                    break;
                case DeleteJudgingForm:
                    deleteJudgingForm(request, response);
                    break;
                case SaveJudging:
                    saveJudging(request, response);
                    break;
                case ListJudgings:
                    listJudgings(request, response);
                    break;
                case DeleteJudgings:
                    deleteJudgings(request, response);
                    break;
                case ListJudgingSummary:
                    listJudgingSummary(request, response);
                    break;
                case Login:
                    login(request, response);
                    break;

                default:
                    throw new IllegalArgumentException("Unknown pathInfo: " + pathInfo);
                }
            } else {
                redirectToMainPage(request, response);
            }
        } catch (final Exception ex) {
            ex.printStackTrace(response.getWriter());
        }
    }

    private void deleteJudgingForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        final String category = ServletUtil.getRequestAttribute(request, RequestParameter.Category.name());
        final String judge = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.Judge.name());
        final String modelId = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.ModelID.name());
        final String modellerId = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.ModellerID.name());

        if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(category) && //
                !ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(judge) && //
                !ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(modelId) && //
                !ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(modellerId)) {
            dao.deleteJudgingScores(judge, category, Integer.parseInt(modelId), Integer.parseInt(modellerId));
        }

        redirectToMainPage(request, response);
    }

    private void deleteJudgings(HttpServletRequest request, HttpServletResponse response) throws Exception {
        for (final JudgedModel score : dao.getAll(JudgingScore.class)) {
            dao.delete(score.id, JudgingScore.class);
        }

        redirectRequest(request, response, "/" + getClass().getSimpleName());
    }

    private void getCategories(HttpServletRequest request, HttpServletResponse response) throws IOException {
        final Set<String> categories = loadFile(JUDGING_FILENAME).keySet();

        setSessionAttribute(request, SessionAttribute.Categories, categories);
        redirectRequest(request, response, JSP_BASE_DIR + "getCategories.jsp");
    }

    private JudgingCriteria getCriteria(String category, int criteriaId) throws IOException {
        for (JudgingCriteria criteria : getCriteriaList(category)) {
            if (criteria.getId() == criteriaId) {
                return criteria;
            }
        }
        throw new IllegalArgumentException(
                String.format("No criteria is found for category [%s] with id: [%d]", category, criteriaId));
    }

    private List<JudgingCriteria> getCriteriaList(String category) throws IOException {
        final Map<String, String> judgingCriteriaFilesForCategory = loadFile(JUDGING_FILENAME);

        String fileName = judgingCriteriaFilesForCategory.get(category);
        if (fileName == null) {
            return Arrays.asList(JudgingCriteria.getDefault());
        }
        try {
            final Map<String, String> judgingCriteriasForCategory = loadFile(fileName);
            final List<JudgingCriteria> criteriaList = new LinkedList<>();

            for (final Entry<String, String> entry : judgingCriteriasForCategory.entrySet()) {
                int criteriaId = Integer.parseInt(entry.getKey());

                final String values = entry.getValue();
                final String[] splitValues = values.split("#");
                if (splitValues.length != 2) {
                    throw new IllegalArgumentException(
                            String.format("value [%s] token count is not 2 for criteriaId: [%s] in file: [%s]!", values,
                                    criteriaId, fileName));
                }
                final String description = splitValues[0];
                final int maxScore = Integer.parseInt(splitValues[1]);

                final JudgingCriteria criteria = new JudgingCriteria(criteriaId, description, maxScore);
                criteriaList.add(criteria);
            }
            criteriaList.sort((c1, c2) -> 
            	Integer.compare(c1.getId(), c2.getId())
            );
            return criteriaList;
        } catch (Exception e) {
            fileCache.remove(fileName);
            throw e;
        }
    }

    private File getFile(String fileName) {
        if (fileName == null) {
            throw new IllegalArgumentException("fileName is not set!");
        }

        String basePath = "." + File.separator;

        File file = null;
        file = new File(basePath + fileName).getAbsoluteFile();
        logger.trace("getFile(): " + file.getAbsolutePath());

        if (!file.exists()) {
            throw new IllegalArgumentException(
                    String.format("fileName not found at path [%s]!", file.getAbsolutePath()));
        }

        return file;
    }

    private void getJudgingForm(HttpServletRequest request, HttpServletResponse response, boolean isForModification)
            throws Exception {
        final String category = ServletUtil.getRequestAttribute(request, RequestParameter.Category.name());

        setSessionAttribute(request, SessionAttribute.JudgingCriteriasForCategory, getCriteriaList(category));
        setSessionAttribute(request, SessionAttribute.Category, category);

        String judgeInRequestAttribute = ServletUtil.getOptionalRequestAttribute(request,
                RequestParameter.Judge.name());
        if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(judgeInRequestAttribute)) {
            setSessionAttribute(request, SessionAttribute.Judge, ServletDAO.encodeString(judgeInRequestAttribute));
        }

        if (isForModification) {
            initForJudgingModification(request, category);
        }

        redirectRequest(request, response, JSP_BASE_DIR + "getJudgingForm.jsp");
    }

    private void initForJudgingModification(HttpServletRequest request, final String category)
            throws MissingRequestParameterException, Exception {

        final String judge = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.Judge.name());
        final String modelId = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.ModelID.name());
        final String modellerId = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.ModellerID.name());

        if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(judge) && //
                !ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(modelId) && //
                !ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(modellerId)) {

            // key: CriteriaID
            Map<Integer, List<JudgingScore>> scores = dao
                    .getJudgingScores(judge, category, Integer.parseInt(modelId), Integer.parseInt(modellerId)).stream()
                    .collect(Collectors.groupingBy(JudgingScore::getCriteriaID));

            setSessionAttribute(request, SessionAttribute.Judgings, scores);
        } else {
            request.getSession(false).removeAttribute(SessionAttribute.Judgings.name());
        }
    }

    private void listJudgings(HttpServletRequest request, HttpServletResponse response) throws Exception {
        final List<JudgingScore> allScores = dao.getAll(JudgingScore.class);

        Collections.sort(allScores, new Comparator<JudgingScore>() {
            @Override
            public int compare(JudgingScore result1, JudgingScore result2) {

                int compareTo = result1.getCategory().compareTo(result2.getCategory());
                if (compareTo == 0) {
                    compareTo = result1.getJudge().compareTo(result2.getJudge());
                    if (compareTo == 0) {
                        compareTo = new Integer(result1.getModelID()).compareTo(new Integer(result2.getModelID()));
                    }
                }

                return compareTo;
            }
        });

        setSessionAttribute(request, SessionAttribute.Judgings, allScores);

        redirectRequest(request, response, JSP_BASE_DIR + "listJudgings.jsp");
    }

    private void listJudgingSummary(HttpServletRequest request, HttpServletResponse response) throws Exception {

        final Map<String, JudgingResult> scoresByCategory = new LinkedHashMap<>();

        final List<JudgingScore> allScores = dao.getAll(JudgingScore.class);

        Collections.sort(allScores, new Comparator<JudgingScore>() {
            @Override
            public int compare(JudgingScore result1, JudgingScore result2) {
                int compareToResult = result1.getCategory().compareTo(result2.getCategory());
                if (compareToResult == 0) {
                    compareToResult = Integer.compare(result1.getModelID(), result2.getModelID());
                }
                return compareToResult;
            }
        });

        for (final JudgingScore score : allScores) {

            String key = score.getJudge() + score.getCategory() + score.getModellerID() + score.getModelID();

            JudgingResult judgingResult = scoresByCategory.get(key);
            if (judgingResult == null) {
                judgingResult = new JudgingResult(score);
                judgingResult.setMaxScore(getCriteriaList(score.getCategory()).stream()
                        .mapToInt(JudgingCriteria::getMaxScore).max().getAsInt());
                scoresByCategory.put(key, judgingResult);
            }

            try {
                judgingResult.getScores().get(score.getScore()).incrementAndGet();
            } catch (Exception e) {
                judgingResult.getScores().put(score.getScore(), new AtomicInteger(1));
            }

        }

        // System.out.println(scoresByCategory);
        setSessionAttribute(request, SessionAttribute.Judgings, scoresByCategory.values());

        redirectRequest(request, response, JSP_BASE_DIR + "listJudgingSummary.jsp");
    }

    private Map<String, String> loadFile(String fileName) throws IOException {
        Properties properties = fileCache.get(fileName);

        if (properties == null) {
            properties = new Properties();
            FileReader reader = new FileReader(getFile(fileName));
            properties.load(reader);
            reader.close();
            fileCache.put(fileName, properties);
        }

        return new HashMap<String, String>((Map) properties);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException, MissingRequestParameterException {
        String judge = ServletUtil.getRequestAttribute(request, RequestParameter.Judge.name());
        setSessionAttribute(request, SessionAttribute.Judge, ServletDAO.encodeString(judge));
        setSessionAttribute(request, CommonSessionAttribute.Language,
                languageUtil.getLanguage(ServletUtil.getRequestAttribute(request, RequestParameter.Language.name())));
        redirectToMainPage(request, response);
    }

    private void redirectRequest(HttpServletRequest request, HttpServletResponse response, String path)
            throws IOException {
        String requestURL = request.getRequestURL().toString();
        while (requestURL.indexOf(getClass().getSimpleName()) > -1) {
            requestURL = requestURL.substring(0, requestURL.lastIndexOf("/"));
        }

        requestURL += path;

        response.sendRedirect(requestURL);
    }

    private void redirectToMainPage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        redirectRequest(request, response, JSP_BASE_DIR + DEFAULT_PAGE);
    }

    private void saveJudging(HttpServletRequest request, HttpServletResponse response) throws Exception {
        final String category = ServletUtil.getRequestAttribute(request, RequestParameter.Category.name());
        final String judge = ServletUtil.getRequestAttribute(request, RequestParameter.Judge.name());
        final String modelsName = ServletUtil.getRequestAttribute(request, RequestParameter.ModelsName.name());
        final int modelId = Integer.parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.ModelID.name()));
        final int modellerId = Integer
                .parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.ModellerID.name()));

        final int judgingCriterias = Integer
                .parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.JudgingCriterias.name()));
        final String comment = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.Comment.name());

        dao.deleteJudgingScores(judge, category, modelId, modellerId);
        for (int i = 1; i <= judgingCriterias; i++) {
            final String optionalRequestAttribute = ServletUtil.getOptionalRequestAttribute(request,
                    RequestParameter.JudgingCriteria.name() + i);
            if (ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(optionalRequestAttribute)) {
                continue;
            }

            final int score = Integer.parseInt(optionalRequestAttribute);

            JudgingScore record = new JudgingScore(dao.getNextID(JudgingScore.class), category, judge, modelId,
                    modellerId, i, score, comment, modelsName);
            dao.save(record);
        }

        final HttpSession session = request.getSession(false);
        session.removeAttribute(SessionAttribute.JudgingCriteriasForCategory.name());
        session.removeAttribute(SessionAttribute.Category.name());
        session.removeAttribute(CommonSessionAttribute.Model.name());

        if (ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE
                .equals(ServletUtil.getOptionalRequestAttribute(request, "finishRegistration"))) {
            setSessionAttribute(request, SessionAttribute.Judge, judge);
            getJudgingForm(request, response, false /* isForModification */);
        } else {
            redirectToMainPage(request, response);
        }
    }

    private void setSessionAttribute(HttpServletRequest request, Enum<?> name, Object value) {
        final HttpSession session = request.getSession(true);
        session.setAttribute(name.name(), value);
    }
}
