package servlet;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.Arrays;
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

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.api.client.http.HttpResponse;

import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

import datatype.judging.JudgingCriteria;
import datatype.judging.JudgingResult;
import datatype.judging.JudgingScore;
import util.SessionAttributes;

public final class JudgingServlet extends HttpServlet
{
  private static final String VERSION = "2019.05.22.";
  private static final String JUDGING_FILENAME = "judging.txt";

  public static Logger logger = Logger.getLogger(JudgingServlet.class);

  public enum RequestType
  {
	GetCategories, GetJudgingForm, SaveJudging, ListJudgings, DeleteJudgings, ListJudgingSummary
  };

  public enum SessionAttribute
  {
	JudgingCriteriasForCategory, Category, Judgings, Judge
  }

  public enum RequestParameter
  {
	Category, ModelID, ModellerID, Judge, Score, JudgingCriterias, Comment
  }

  private HibernateDAO dao;

  public JudgingServlet()
  {
	super();
  }

  @Override
  public void init(ServletConfig config) throws ServletException
  {
	try
	{
            DOMConfigurator.configure(config.getServletContext().getResource("/WEB-INF/conf/log4j.xml"));

            logger.fatal("************************ Logging restarted ************************");
	    System.out.println("VERSION: " + VERSION);
	    logger.fatal("VERSION: " + VERSION);
	  dao = new HibernateDAO(config.getServletContext().getResource("/WEB-INF/conf/hibernate.cfg.xml"));
	}
	catch (final MalformedURLException e)
	{
	  throw new ServletException(e);
	}
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
	doPost(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
	try
	{
	  String pathInfo = request.getPathInfo();
	  if (pathInfo != null)
	  {
		pathInfo = pathInfo.substring(1);

		switch (RequestType.valueOf(pathInfo))
		{
		case GetCategories:
		  getCategories(request, response);
		  break;

		case GetJudgingForm:
		  getJudgingForm(request, response);
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

		default:
		  throw new IllegalArgumentException("Unknown pathInfo: " + pathInfo);
		}
	  }
	  else
	  {
		redirectRequest(request, response, "/jsp/judging/judging.jsp");
	  }
	}
	catch (final Exception ex)
	{
	  ex.printStackTrace(response.getWriter());
	}
  }

  private void listJudgingSummary(HttpServletRequest request, HttpServletResponse response) throws Exception
  {

	final Map<String, JudgingResult> scoresByCategory = new LinkedHashMap<String, JudgingResult>();

	final List<JudgingScore> allScores = dao.getAll(JudgingScore.class);

	Collections.sort(allScores, new Comparator<JudgingScore>()
	{
	  @Override
	  public int compare(JudgingScore result1, JudgingScore result2)
	  {
		int compareToResult = result1.getCategory().compareTo(result2.getCategory());
		if (compareToResult == 0)
		{
		  compareToResult = result1.getJudge().compareTo(result2.getJudge());
		}
		return compareToResult;
	  }
	});

	for (final JudgingScore score : allScores)
	{

	  String key = score.getJudge() + score.getCategory() + score.getModellerID() + score.getModelID();
	  
	  JudgingResult judgingResult = scoresByCategory.get(key);
	  if (judgingResult == null)
	  {
		judgingResult = new JudgingResult(score);
		scoresByCategory.put(key, judgingResult);
	  }

            try 
            {
                AtomicInteger count = judgingResult.getScoreForCriteria(score.getCriteriaID());
                count.incrementAndGet();
            } catch (Exception e) {
                judgingResult.getScores().put(getCriteria(score.getCategory(), score.getCriteriaID()), new AtomicInteger(1));
            }

	}

	System.out.println(scoresByCategory);
	setSessionAttribute(request, SessionAttribute.Judgings.name(), scoresByCategory.values());

	redirectRequest(request, response, "/jsp/judging/listJudgingSummary.jsp");
  }

  private void setSessionAttribute(HttpServletRequest request, String name, Object value)
  {
	final HttpSession session = request.getSession(true);
	session.setAttribute(name, value);
  }

  private void deleteJudgings(HttpServletRequest request, HttpServletResponse response) throws Exception
  {
	for (final JudgingScore score : dao.getAll(JudgingScore.class))
	{
	  dao.delete(score.id, JudgingScore.class);
	}

	redirectRequest(request, response, "/" + getClass().getSimpleName());
  }

  private void listJudgings(HttpServletRequest request, HttpServletResponse response) throws Exception
  {
	final List<JudgingScore> allScores = dao.getAll(JudgingScore.class);

	Collections.sort(allScores, new Comparator<JudgingScore>()
	{
	  @Override
	  public int compare(JudgingScore result1, JudgingScore result2)
	  {

		int compareTo = result1.getCategory().compareTo(result2.getCategory());
		if (compareTo == 0)
		{
		  compareTo = result1.getJudge().compareTo(result2.getJudge());
		  if (compareTo == 0)
		  {
			compareTo = new Integer(result1.getModelID()).compareTo(new Integer(result2.getModelID()));
		  }
		}

		return compareTo;
	  }
	});

	setSessionAttribute(request, SessionAttribute.Judgings.name(), allScores);

	redirectRequest(request, response, "/jsp/judging/listJudgings.jsp");
  }

  private void saveJudging(HttpServletRequest request, HttpServletResponse response) throws Exception
  {
	final String category = ServletUtil.getRequestAttribute(request, RequestParameter.Category.name());
	final String judge = ServletUtil.getRequestAttribute(request, RequestParameter.Judge.name());
	final int modelID = Integer.parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.ModelID.name()));
	final int modellerID = Integer.parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.ModellerID.name()));

	final int judgingCriterias = Integer
	    .parseInt(ServletUtil.getRequestAttribute(request, RequestParameter.JudgingCriterias.name()));
	final String comment = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.Comment.name());

	for (int i = 1; i <= judgingCriterias; i++)
	{
	  final String optionalRequestAttribute = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.Score.name() + i);
	  if ("-".equals(optionalRequestAttribute))
	  {
		continue;
	  }

	  final int score = Integer.parseInt(optionalRequestAttribute);

	  dao.save(new JudgingScore(dao.getNextID(JudgingScore.class), category, judge, modelID, modellerID, i, score, comment));
	}

        final HttpSession session = request.getSession(false);
        session.removeAttribute(SessionAttribute.JudgingCriteriasForCategory.name());
        session.removeAttribute(SessionAttribute.Category.name());

	redirectRequest(request, response, "/" + getClass().getSimpleName());
  }

  private void getJudgingForm(HttpServletRequest request, HttpServletResponse response) throws Exception
  {
	final String category = ServletUtil.getRequestAttribute(request, RequestParameter.Category.name());

	setSessionAttribute(request, SessionAttribute.JudgingCriteriasForCategory.name(), getCriteriaList(category));
	setSessionAttribute(request, SessionAttribute.Category.name(), category);

	redirectRequest(request, response, "/jsp/judging/getJudgingForm.jsp");
  }

  private JudgingCriteria getCriteria(String category, int criteriaId) throws IOException
  {
      for(JudgingCriteria criteria : getCriteriaList(category))
          if(criteria.getId() == criteriaId)
              return criteria;
      throw new IllegalArgumentException(String.format("No criteria is found for category [%s] with id: [%d]", category, criteriaId));
  }
  
  private List<JudgingCriteria> getCriteriaList(String category) throws IOException
  {
	final Map<String, String> judgingCriteriaFilesForCategory = loadFile(JUDGING_FILENAME);

	String fileName = judgingCriteriaFilesForCategory.get(category);
	if(fileName == null)
	    return Arrays.asList(JudgingCriteria.getDefault()); 
	                
        final Map<String, String> judgingCriteriasForCategory = loadFile(fileName);
	final List<JudgingCriteria> criteriaList = new LinkedList<JudgingCriteria>();

	for (final Entry<String, String> entry : judgingCriteriasForCategory.entrySet())
	{
	  int criteriaId = Integer.parseInt(entry.getKey());
	    
	  final String values = entry.getValue();
	  final String[] splitValues = values.split(";");
	  if(splitValues.length != 2)
	      throw new IllegalArgumentException(String.format("value [%s] token count is not 2 for criteriaId: [%s] in file: [%s]!", values, criteriaId, fileName));
	  final String description = splitValues[0];
	  final int maxScore = Integer.parseInt(splitValues[1]);

	  final JudgingCriteria criteria = new JudgingCriteria(criteriaId, description, maxScore);
	  criteriaList.add(criteria);
	}

	return criteriaList;
  }

  private void getCategories(HttpServletRequest request, HttpServletResponse response) throws IOException
  {
	final Set<String> categories = loadFile(JUDGING_FILENAME).keySet();

	setSessionAttribute(request, RequestType.GetCategories.name(), categories);
	redirectRequest(request, response, "/jsp/judging/getCategories.jsp");
  }

  private void redirectRequest(HttpServletRequest request, HttpServletResponse response, String path) throws IOException
  {
	String requestURL = request.getRequestURL().toString();
	while (requestURL.indexOf(getClass().getSimpleName()) > -1)
	{
	  requestURL = requestURL.substring(0, requestURL.lastIndexOf("/"));
	}

	requestURL += path;

	response.sendRedirect(requestURL);
  }

  private File getFile(String fileName)
  {
        if (fileName == null)
            throw new IllegalArgumentException("fileName is not set!");

        String basePath = "." + File.separator;

        File file = null;
        file = new File(basePath + fileName).getAbsoluteFile();
        logger.trace("getFile(): " + file.getAbsolutePath());

        if (!file.exists())
            throw new IllegalArgumentException(String.format("fileName not found at path [%s]!", file.getAbsolutePath()));

        return file;
  }

  private final Map<String, Properties> fileCache = new HashMap<String, Properties>();
  
    private Map<String, String> loadFile(String fileName) throws IOException {
        Properties properties = fileCache.get(fileName);

        if (properties == null) 
        {
            properties = new Properties();
            FileReader reader = new FileReader(getFile(fileName));
            properties.load(reader);
            reader.close();
            fileCache.put(fileName, properties);
        }
        
        return new HashMap<String, String>((Map) properties);
    }

    public static ResourceBundle getLanguage(HttpSession session, HttpServletResponse response) throws IOException
    {
        ResourceBundle language = (ResourceBundle)session.getAttribute(SessionAttributes.Language.name());
        if(language == null)
                response.sendRedirect("judging.jsp");
        
        return language;
    }
}
