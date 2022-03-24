package servlet;

import java.io.IOError;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.sql.SQLException;
import java.util.ArrayList;
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
import java.util.Objects;
import java.util.Optional;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.zip.GZIPInputStream;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

import datatype.Category;
import datatype.Model;
import datatype.Record;
import datatype.judging.JudgingCategoryToSheetMapping;
import datatype.judging.JudgingCriteria;
import datatype.judging.JudgingError;
import datatype.judging.JudgingResult;
import datatype.judging.JudgingScore;
import datatype.judging.JudgingSheet;
import exception.MissingRequestParameterException;
import tools.ExcelUtil;
import tools.ExcelUtil.Workbook;
import util.CommonSessionAttribute;
import util.LanguageUtil;

public final class JudgingServlet extends HttpServlet {
	private static final String VERSION = "2022.03.10.";

	public enum RequestParameter {
        Category, ModelID, ModellerID, Judge, JudgingCriteria, JudgingCriterias, Comment, ModelsName, Language, ForJudges, Class, SimpleJudging
    }

    public enum RequestType {
        GetCategories, GetModelsInCategory, GetJudgingSheet, GetJudgingForm, SaveJudging, ListJudgings, DeleteRecords, ListJudgingSummary, DeleteJudgingForm, Login, ExportExcel, ImportData, JoinCategoryWithForm, SaveCategoryWithForm
    }

    public enum SessionAttribute {
        JudgingCriteriasForCategory, Category, Judgings, Judge, Categories, Forms, JudgingCategoryToSheetMapping, SimpleJudging
    }

    public static Logger logger = Logger.getLogger(JudgingServlet.class);

    public final static String DEFAULT_PAGE = "judging.jsp";

    private final static String JSP_URL_BASE_DIR = "/jsp/";
    private final static String JSP_URL_BASE_DIR_JUDGING = JSP_URL_BASE_DIR + "judging/";

    private JudgingServletDAO dao;
    private ServletDAO servletDAO;
    
    private LanguageUtil languageUtil = new LanguageUtil();

    public static List<JudgingError> checkJudgingResults(Collection<JudgingResult> collection) {
        List<JudgingError> errors = new LinkedList<>();

        errors.addAll(checkJudgedCriteriasPerModel(collection));
        errors.addAll(checkJudgedModelsPerCategory(collection));
        errors.addAll(checkIfModelandModelerCorelate(collection));

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
                String judges = getJudgesLinks(judgingResults.getValue(), judgingResult -> modellerIds.contains(judgingResult.getModellerID()));
                
                JudgingError judgingError = judgingResults.getKey();
                judgingError.setErrorMessage(String.format("judges: (%s) put for modelId: %d different modellerIds: %s", judges, judgingError.getModelID(), modellerIds));
                judgingError.setErrorType(JudgingError.JudgingErrorType.ModelIdAndModellerID_Mismatch);
            }
        }

        return judgingResultsByModelId.keySet().stream().filter(JudgingError::isPresent).collect(Collectors.toList());
    }
    
    private static String getJudgingFormLink(JudgingResult judgingResult)
    {
        return "<a href='../../JudgingServlet/" + JudgingServlet.RequestType.GetJudgingForm.name() + "?"
                + JudgingServlet.RequestParameter.ModelID + "=" + judgingResult.getModelID() + "&"
                + JudgingServlet.RequestParameter.ModellerID + "=" + judgingResult.getModellerID() + "&"
                + JudgingServlet.RequestParameter.Category + "=" + judgingResult.getCategory() + "&"
                + JudgingServlet.RequestParameter.Judge + "=" + judgingResult.getJudge()
                + "'>" + judgingResult.getJudge() + "</a>";

    }

    private static String getJudgesLinks(List<JudgingResult> judgingResults, Predicate<? super JudgingResult> filter) {
        return judgingResults.stream()
                .filter(filter)
                .map(judgingResult -> getJudgingFormLink(judgingResult)).distinct().collect(Collectors.joining(", "));
    }

    private static List<JudgingError> checkJudgedCriteriasPerModel(Collection<JudgingResult> collection) {
        Map<JudgingError, List<JudgingResult>> judgingResultsByModelId = collection.stream()
                .collect(Collectors.groupingBy(
                        judgingResult -> new JudgingError(judgingResult.getCategory(), judgingResult.getModelID())));

        for (Entry<JudgingError, List<JudgingResult>> judgingResults : judgingResultsByModelId.entrySet()) {
            List<Integer> totalNumberOfDifferentScores = judgingResults.getValue().stream().mapToInt(
                    judgingResult -> judgingResult.getTotalScores())
                    .distinct().boxed().collect(Collectors.toList());

            if (totalNumberOfDifferentScores.size() != 1) {
                String judges = getJudgesLinks(judgingResults.getValue(), judgingResult -> totalNumberOfDifferentScores.contains(judgingResult.getTotalScores()));
                
                JudgingError judgingError = judgingResults.getKey();
                judgingError.setErrorMessage(String.format("judges: (%s) evaluated different number of criterias: %s",
                        judges, totalNumberOfDifferentScores));
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

            int firstJudgesModels = 0;
            String firstJudge = "";
            for (Entry<String, List<JudgingResult>> judgedModelPerJudge : judgedModelsPerJudge.entrySet()) {
                String currentJudge = judgedModelPerJudge.getKey();
                int currentJudgesModels = judgedModelPerJudge.getValue().size();
                
                if (firstJudgesModels == 0) {
                    firstJudgesModels = currentJudgesModels;
                    firstJudge = currentJudge;
                }

                if (firstJudgesModels != currentJudgesModels) {
//                    String judges = getJudgesLinks(judgingResults.getValue(), judgingResult -> totalNumberOfDifferentScores.contains(judgingResult.getTotalScores()));

                    JudgingError judgingError = new JudgingError(category,
                            -1);
                    judgingError.setErrorType(JudgingError.JudgingErrorType.TotalEvaluatedModels_Mismatch);
                    judgingError.setErrorMessage(String.format("number of judged models per judge are different: [%s: %d] - [%s: %d]",
                            firstJudge, firstJudgesModels, currentJudge, currentJudgesModels));
                    returned.add(judgingError);
                }
            }
        }

        return returned;
    }

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
            servletDAO = RegistrationServlet.getServletDAO();
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
            
            logger.debug(pathInfo);
            if (pathInfo != null) {
                pathInfo = pathInfo.substring(1);

                switch (RequestType.valueOf(pathInfo)) {
                case GetCategories:
                    getCategories(request, response);
                    break;
                case GetModelsInCategory:
                	getModelsInCategory(request, response);
                    break;
                case GetJudgingForm:
                    getJudgingForm(request, response, true /* setJudgingScoresInSession */);
                    break;
                case GetJudgingSheet:
                    getJudgingForm(request, response, true /* setJudgingScoresInSession */, "getJudgingSheet.jsp");
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
                case DeleteRecords:
                    deleteRecords(request, response);
                    break;
                case ListJudgingSummary:
                    listJudgingSummary(request, response);
                    break;
                case Login:
                    login(request, response);
                    break;
                case ExportExcel:
                	exportExcel(request, response);
                    break;
                case ImportData:
                	importData(request, response);
                	break;
                case JoinCategoryWithForm:
                	joinCategoryWithForm(request, response);
                	break;
                case SaveCategoryWithForm:
                	saveCategoryWithForm(request, response);
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
    
	private void joinCategoryWithForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Category> categories = servletDAO.getCategoryList(null /* show */);
		setSessionAttribute(request, SessionAttribute.Categories, categories);

		List<JudgingSheet> forms = dao.getAll(JudgingSheet.class);
		setSessionAttribute(request, SessionAttribute.Forms, forms);

		Map<Integer, JudgingSheet> categoryMapping = dao.getJudgingCategories().stream().collect(Collectors.toMap(
				JudgingCategoryToSheetMapping::getCategoryId, JudgingCategoryToSheetMapping::getJudgingSheet));
		setSessionAttribute(request, SessionAttribute.JudgingCategoryToSheetMapping,
				categoryMapping);

		redirectRequest(request, response, JSP_URL_BASE_DIR_JUDGING + "joinCategoryWithForm.jsp");
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

    private void deleteRecords(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	@SuppressWarnings("unchecked")
		Class<? extends Record> recordClass = (Class<? extends Record>) Class.forName(ServletUtil.getRequestAttribute(request, RequestParameter.Class.name()));
		for (final Record record : dao.getAll(recordClass)) {
            dao.delete(record.id, recordClass);
        }

        redirectRequest(request, response, "/" + getClass().getSimpleName());
    }

    private void getCategories(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	List<String> categories;
    	
        boolean simpleJudging = Boolean.valueOf(ServletUtil.getOptionalRequestAttribute(request, JudgingServlet.RequestParameter.SimpleJudging.name()));
        if(simpleJudging) {
        	categories = servletDAO.getCategoryList(null /* show */).stream().map(Category::getCategoryCode).collect(Collectors.toList());
        	categories.removeAll(getCategories());
        }
        else {
        	categories = getCategories();
        }

		setSessionAttribute(request, SessionAttribute.SimpleJudging, simpleJudging);
        setSessionAttribute(request, SessionAttribute.Categories, categories);
        redirectRequest(request, response, JSP_URL_BASE_DIR_JUDGING + "getCategories.jsp");
    }

	private List<String> getCategories() throws Exception {
		List<String> categories = dao.getAll(JudgingCategoryToSheetMapping.class).stream()
				.sorted((jc1, jc2) -> Integer.compare(jc1.getCategoryId(), jc2.getCategoryId()))
				.map(judgingCategory -> {
					try {
						return servletDAO.getCategory(judgingCategory.getCategoryId()).getCategoryCode();
					} catch (SQLException e) {
						return e.getMessage();
					}
				}).collect(Collectors.toList());

		return categories;
	}

    private void getModelsInCategory(HttpServletRequest request, HttpServletResponse response) throws IOException, MissingRequestParameterException, SQLException {
        final String category = ServletUtil.getRequestAttribute(request, RequestParameter.Category.name());
        final String forJudges = ServletUtil.getRequestAttribute(request, RequestParameter.ForJudges.name());
        int categoryID = servletDAO.getCategory(category).getId();

		List<Model> models = servletDAO.getModelsInCategory(categoryID);
		models.sort((m1, m2) -> Integer.valueOf(m1.getUserID()).compareTo(Integer.valueOf(m2.getUserID())));
		
        setSessionAttribute(request, RegistrationServlet.SessionAttribute.Models, models);
		redirectRequest(request, response,
				JSP_URL_BASE_DIR + "listModels.jsp?" + JudgingServlet.RequestParameter.ForJudges.name() + "=" + forJudges);
    }
    
    private void getJudgingForm(HttpServletRequest request, HttpServletResponse response, boolean setJudgingScoresInSession)
            throws Exception {
        getJudgingForm(request, response, setJudgingScoresInSession, "getJudgingForm.jsp");
    }
    
    private void getJudgingForm(HttpServletRequest request, HttpServletResponse response, boolean setJudgingScoresInSession, String jspPage)
            throws Exception {
        final String categoryCode = ServletUtil.getRequestAttribute(request, RequestParameter.Category.name());

		boolean simpleJudging = Boolean.valueOf(
				ServletUtil.getOptionalRequestAttribute(request, JudgingServlet.RequestParameter.SimpleJudging.name()));
		setSessionAttribute(request, SessionAttribute.SimpleJudging, simpleJudging);
		setSessionAttribute(request, SessionAttribute.JudgingCriteriasForCategory, getCriteriaList(categoryCode));
		setSessionAttribute(request, SessionAttribute.Category, categoryCode);

        String judgeInRequestAttribute = ServletUtil.getOptionalRequestAttribute(request,
                RequestParameter.Judge.name());
        
        if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(judgeInRequestAttribute)) {
            setSessionAttribute(request, SessionAttribute.Judge, ServletDAO.encodeString(judgeInRequestAttribute));
        }

        if (setJudgingScoresInSession) {
            setJudgingScoresInSession(request, categoryCode);
        }

        redirectRequest(request, response, JSP_URL_BASE_DIR_JUDGING + jspPage);
    }

    private List<JudgingCriteria> getCriteriaList(String categoryCode) throws Exception {
    	Category category = servletDAO.getCategory(categoryCode);
    	return dao.getJudgingCriteria(category.getId());
	}

	private void setJudgingScoresInSession(HttpServletRequest request, final String category)
            throws MissingRequestParameterException, Exception {

        final String judge = ServletDAO.encodeString(ServletUtil.getOptionalRequestAttribute(request, RequestParameter.Judge.name()));
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

        redirectRequest(request, response, JSP_URL_BASE_DIR_JUDGING + "listJudgings.jsp");
    }

    private void listJudgingSummary(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<String> categories = getCategories();
        setSessionAttribute(request, SessionAttribute.Categories, categories);

        Collection<JudgingResult> judgings = getJudgingSummary();
		setSessionAttribute(request, SessionAttribute.Judgings, judgings);

        redirectRequest(request, response, JSP_URL_BASE_DIR_JUDGING + "listJudgingSummary.jsp");
    }

	private Collection<JudgingResult> getJudgingSummary() throws Exception, IOException {
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
                        .mapToInt(JudgingCriteria::getMaxScore).max().orElse(JudgingCriteria.getDefault().getMaxScore()));
                scoresByCategory.put(key, judgingResult);
            }

            try {
                judgingResult.getScores().get(score.getScore()).incrementAndGet();
            } catch (Exception e) {
                judgingResult.getScores().put(score.getScore(), new AtomicInteger(1));
            }

        }

        Collection<JudgingResult> judgings = scoresByCategory.values();
		return judgings;
	}

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException, MissingRequestParameterException {
        String judge = ServletDAO.encodeString(ServletUtil.getRequestAttribute(request, RequestParameter.Judge.name()));
        setSessionAttribute(request, SessionAttribute.Judge, judge);
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
        redirectRequest(request, response, JSP_URL_BASE_DIR_JUDGING + DEFAULT_PAGE);
    }
    
	private void saveCategoryWithForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Category> categories = servletDAO.getCategoryList(null /* show */);

		for (Category category : categories) {
			int categoryId = category.getId();
			try {
				final int judgingSheetId = Integer.parseInt(
						ServletUtil.getRequestAttribute(request, RequestParameter.Category.name() + categoryId));

				JudgingSheet judgingSheet = dao.get(judgingSheetId, JudgingSheet.class);

				Optional<JudgingCategoryToSheetMapping> judgingCategoryOptional = dao.getJudgingCategory(categoryId);
				JudgingCategoryToSheetMapping judgingCategory = null;
				
				if(judgingCategoryOptional.isPresent()) {
					judgingCategory = judgingCategoryOptional.get();
					judgingCategory.setJudgingSheet(judgingSheet);
				}
				else {
					judgingCategory = new JudgingCategoryToSheetMapping(categoryId, judgingSheet);
					judgingCategory.setId(dao.getNextID(JudgingCategoryToSheetMapping.class));
				}

				dao.save(judgingCategory);
			} catch (Exception e) {
			}
		}

		redirectToMainPage(request, response);
	}
    
    private void saveJudging(HttpServletRequest request, HttpServletResponse response) throws Exception {
        final String category = ServletUtil.getRequestAttribute(request, RequestParameter.Category.name());
        final String judge = ServletDAO.encodeString(ServletUtil.getRequestAttribute(request, RequestParameter.Judge.name()));
        final String modelsName = ServletUtil.getRequestAttribute(request, RequestParameter.ModelsName.name());
        final int modelId = Integer.parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.ModelID.name()));
        final int modellerId = Integer
                .parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.ModellerID.name()));

        final int judgingCriterias = Integer
                .parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.JudgingCriterias.name()));
        final String comment = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.Comment.name());
        boolean simpleJudging = Boolean.valueOf(ServletUtil.getOptionalRequestAttribute(request, JudgingServlet.RequestParameter.SimpleJudging.name()));

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
            setSessionAttribute(request, SessionAttribute.SimpleJudging, simpleJudging);
            getJudgingForm(request, response, false /* setJudgingScoresInSession */);
        } else {
            redirectToMainPage(request, response);
        }
    }

    public static void setSessionAttribute(HttpServletRequest request, Enum<?> name, Object value) {
        final HttpSession session = request.getSession(true);
        session.setAttribute(name.name(), value);
    }
    
	public void importData(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final DiskFileItemFactory factory = new DiskFileItemFactory();
		final ServletFileUpload upload = new ServletFileUpload(factory);

		final Map<String, String> parameters = new HashMap<String, String>();

		@SuppressWarnings("unchecked")
		final List<FileItem> iter = upload.parseRequest(request);

		for (final FileItem item : iter) {
			if (item.isFormField()) {
				parameters.put(item.getFieldName(), item.getString());
			} else {
				processUploadedFile(request, response, item, parameters);
			}
		}
	}

	private void processUploadedFile(final HttpServletRequest request, final HttpServletResponse response,
			FileItem item, Map<String, String> parameters) throws IOException, SQLException, Exception {
		if ("zipFile".equals(item.getFieldName())) {
			final StringBuilder buff = importZip(request, item.getInputStream());
			RegistrationServlet.writeResponse(response, buff);
		}
	}

	private StringBuilder importZip(final HttpServletRequest request, final InputStream stream)
			throws IOException, SQLException, Exception, IOError {
		final StringBuilder buff = new StringBuilder("Records imported: ");

		final GZIPInputStream e = new GZIPInputStream(stream);
		final List<? extends Record> data = (List<? extends Record>) Serialization.deserialize(e);
		e.close();
		
		for (Record record : data) {
			setIdInRecord(buff, record);
		}
		
		return buff;
	}

	private void setIdInRecord(StringBuilder buff, Record record) throws Exception {
		if(JudgingCategoryToSheetMapping.class.isInstance(record))
			setIdInRecord(buff, JudgingCategoryToSheetMapping.class.cast(record).getJudgingSheet());
		else if(JudgingSheet.class.isInstance(record)) {
			JudgingSheet.class.cast(record).getCriterias().forEach(criteria -> {
				try {
					setIdInRecord(buff, criteria);
				} catch (Exception e) {
					throw new IllegalStateException(e);
				}
			});
		}

		record.setId(dao.getNextID(record.getClass()));
		dao.save(record);
		buff.append(".");
	}

    public void exportExcel(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
        response.setContentType("application/vnd.ms-excel");

        if(Objects.isNull(servletDAO))
        	throw new IllegalStateException("Nevezesi rendszerbe be kell eloszor lepni!");
        
        List<String> masterCategoryList = servletDAO.getCategoryList(null).stream().
        	filter(Category::isMaster).
        		map(Category::getCategoryCode).collect(Collectors.toList());
        
        final HttpSession session = request.getSession(false);
        ResourceBundle language = getLanguage(session, response);
        Collection<JudgingResult> judgings = getJudgingSummary();

    			int maxScore = 
    					judgings.stream().mapToInt(JudgingResult::getMaxScore).max().orElse(0);
        List<List<Object>> modelsForExcel = judgings.stream().map(judgingResult -> {
            ArrayList<Object> returned = new ArrayList<>();

    		returned.add(isMasterCategory(judgingResult.getCategory(), masterCategoryList));
    		returned.add(StringEscapeUtils.unescapeHtml4(judgingResult.getCategory()));
            returned.add(StringEscapeUtils.unescapeHtml4(judgingResult.getJudge()));
            returned.add(judgingResult.getModellerID());
            returned.add(judgingResult.getModelID());
            returned.add(StringEscapeUtils.unescapeHtml4(judgingResult.getModelsName()));
            for (int i = 0; i <= maxScore; i++)
            {
            	int count = judgingResult.getCountForScore(i);
                returned.add(count);
            }
            returned.add(judgingResult.getTotalScores());
            return returned;

        }).collect(Collectors.toList());

        
        List<String> header = new LinkedList<>();
        header.add("Master?");
        header.add(StringEscapeUtils.unescapeHtml4(language.getString("category")));
        header.add(StringEscapeUtils.unescapeHtml4(language.getString("judge")));
        header.add(StringEscapeUtils.unescapeHtml4(language.getString("userID")));
        header.add(StringEscapeUtils.unescapeHtml4(language.getString("modelID")));
        header.add(StringEscapeUtils.unescapeHtml4(language.getString("models.name")));
        for (int i = 0; i <= maxScore; i++)
        {
        	header.add(String.valueOf(i));
        }
        header.add("Total");
        
        Workbook u = ExcelUtil.generateExcelTableWithHeaders("judging", header, modelsForExcel);

        u.writeTo(response.getOutputStream());
    }

	private boolean isMasterCategory(String category, List<String> masterCategoryList) {
		return masterCategoryList.contains(category);
	}

}
