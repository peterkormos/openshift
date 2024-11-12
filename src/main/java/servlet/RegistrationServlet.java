package servlet;

import java.awt.image.BufferedImage;
import java.beans.XMLEncoder;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOError;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.EnumMap;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

import javax.mail.MessagingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
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

import datatype.AgeGroup;
import datatype.AwardedModel;
import datatype.Category;
import datatype.CategoryGroup;
import datatype.Detailing;
import datatype.DetailingCriteria;
import datatype.DetailingGroup;
import datatype.EmailParameter;
import datatype.LoginConsent;
import datatype.LoginConsent.LoginConsentType;
import datatype.MainPageNotice;
import datatype.Model;
import datatype.ModelClass;
import datatype.User;
import exception.EmailNotFoundException;
import exception.MissingRequestParameterException;
import exception.MissingServletConfigException;
import exception.UserNotLoggedInException;
import servlet.ServletDAO.SYSTEMPARAMETER;
import tools.ExcelUtil;
import tools.ExcelUtil.Workbook;
import tools.InitDB;
import util.CommonSessionAttribute;
import util.LanguageUtil;
import util.gapi.EmailUtil;

public class RegistrationServlet extends HttpServlet {
	public String VERSION = "2024.11.12.a";
	public static Logger logger = Logger.getLogger(RegistrationServlet.class);

	public static ServletDAO servletDAO;
	StringBuilder printBuffer;
	StringBuilder batchAddModelBuffer;
	StringBuilder awardedModelsBuffer;
	StringBuilder cerificateOfMeritBuffer;
	StringBuilder presentationBuffer;
	StringBuilder printCardBuffer;

	public static Map<String, EnumMap<SYSTEMPARAMETER, String>> systemParameters = new HashMap<>();
	private boolean onSiteUse;
	private String systemMessage = "";

	private final List<ExceptionData> exceptionHistory = new LinkedList<ExceptionData>();

	private static RegistrationServlet instance;

	private Properties servletConfig = new Properties();
	
	private EmailUtil emailUtil;
	
    public static JudgingServletDAO judgingServletDAO;


	public static enum SessionAttribute {
	    Notices, Action, SubmitLabel, Show, DirectRegister, ModelID, Models, MainPageFile, ShowId, Model, Categories
	}

	public static enum Command {
	    LOADIMAGE, addModel, modifyModel
	};
	
	public static enum MainPageType {
	    Old("main.jsp"), //
	    New("main_v2.jsp");
	    
	    private String fileName;
	    
	    MainPageType(String fileName)
	    {
	        this.fileName = fileName;
	    }

            public String getFileName() {
                return fileName;
            }
	}

	public RegistrationServlet() throws Exception {
		instance = this;
	}

	@Override
	public void init(final ServletConfig config) throws UnavailableException, ServletException {
		try {
			DOMConfigurator.configure(config.getServletContext().getResource("/WEB-INF/conf/log4j.xml"));

			servletConfig.load(config.getServletContext().getResourceAsStream("/WEB-INF/conf/servlet.ini"));

			logger.fatal("************************ Logging restarted ************************");
			System.out.println("VERSION: " + VERSION);
			logger.fatal("VERSION: " + VERSION);

			DriverManager.registerDriver((Driver) Class.forName(getServerConfigParamter("db.driver")).newInstance());

			if (servletDAO == null) {
				servletDAO = new ServletDAO(getServerConfigParamter("db.url"),
						getServerConfigParamter("db.username"), getServerConfigParamter("db.password"),
						config.getServletContext().getResource("/WEB-INF/conf/hibernate.cfg.xml")
						);
	            judgingServletDAO = new JudgingServletDAO(config.getServletContext().getResource("/WEB-INF/conf/hibernate.cfg.xml"));
			}
			
			emailUtil = new EmailUtil();

			printBuffer = loadFile(config.getServletContext().getResourceAsStream("/WEB-INF/conf/print.html"));
			printCardBuffer = loadFile(config.getServletContext().getResourceAsStream("/WEB-INF/conf/printCard.html"));
			batchAddModelBuffer = loadFile(
					config.getServletContext().getResourceAsStream("/WEB-INF/conf/batchAddModel.html"));
			awardedModelsBuffer = loadFile(
					config.getServletContext().getResourceAsStream("/WEB-INF/conf/awardedModels.html"));
			cerificateOfMeritBuffer = loadFile(
					config.getServletContext().getResourceAsStream("/WEB-INF/conf/cerificateOfMerit.html"));
			presentationBuffer = loadFile(
					config.getServletContext().getResourceAsStream("/WEB-INF/conf/presentation.html"));

			try {
                new InitDB();
            } catch (Exception e) {
            }
            try {
				for(String show : servletDAO.getShows()) {
					EnumMap<SYSTEMPARAMETER, String> enumMap = new EnumMap<>(SYSTEMPARAMETER.class);
					systemParameters.put(show, enumMap);
					enumMap.put(ServletDAO.SYSTEMPARAMETER.REGISTRATION,
					String.valueOf(servletDAO.getYesNoSystemParameter(ServletDAO.SYSTEMPARAMETER.REGISTRATION)));
					enumMap.put(ServletDAO.SYSTEMPARAMETER.ONSITEUSE,
							String.valueOf(servletDAO.getYesNoSystemParameter(ServletDAO.SYSTEMPARAMETER.ONSITEUSE)));
					enumMap.put(ServletDAO.SYSTEMPARAMETER.MaxModelsPerCategory,
							String.valueOf(servletDAO.getYesNoSystemParameter(ServletDAO.SYSTEMPARAMETER.MaxModelsPerCategory)));
					updateSystemSettings(show);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		            

			System.out.println("OK.....");
		} catch (final Exception e) {
			if (logger != null) {
				logger.fatal("!!! init(): ", e);
			} else {
				e.printStackTrace();
			}
			throw new ServletException(e);
		}
	}

	public static RegistrationServlet getInstance(ServletConfig config) throws Exception {
		if (instance == null) {
			instance = new RegistrationServlet();
			instance.init(config);
		}

		return instance;
	}

	private StringBuilder loadFile(final InputStream file) throws FileNotFoundException, IOException {
		final BufferedReader br = new BufferedReader(new InputStreamReader(file));
		final StringBuilder buffer = new StringBuilder();

		String line = null;
		while ((line = br.readLine()) != null) {
			buffer.append("\r\n");
			buffer.append(line);
		}

		br.close();

		return buffer;
	}

	private String getServerConfigParamter(final String parameter) throws MissingServletConfigException {
		final String value = servletConfig.getProperty(parameter);

		if (value == null) {
			throw new MissingServletConfigException(parameter);
		}

		if (logger != null) {
			logger.debug("getServerConfigParamter(): parameter " + parameter + " value: " + value);
		}

		return value;
	}

	protected void checkHTTP(final HttpServletRequest req) {
		try {
			logger.fatal("!!! checkHTTP(): queryString: " + req.getQueryString());
			final Enumeration<String> e = req.getParameterNames();
			while (e.hasMoreElements()) {
				final String param = e.nextElement();
				logger.fatal("!!! checkHTTP(): parameter: " + param + " value: " + req.getParameter(param));
			}

			final BufferedReader in = new BufferedReader(new InputStreamReader(req.getInputStream()));
			String inputLine;
			if (in.ready()) {
				while ((inputLine = in.readLine()) != null) {
					logger.fatal("!!! checkHTTP(): inputLine: " + inputLine);
				}
			}
		} catch (final Exception ex) {
			ex.printStackTrace();
		}
	}

	@Override
	public void doGet(final HttpServletRequest request, final HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	@Override
	public void doPost(final HttpServletRequest request, final HttpServletResponse response)
			throws ServletException, IOException {
		try {
			final long startTime = System.currentTimeMillis();

			if (request.getCharacterEncoding() == null) {
				request.setCharacterEncoding("UTF-8");
			}

			if (ServletFileUpload.isMultipartContent(request)) {
				importData(request, response);
				return;
			}

			final String pathInfo = request.getPathInfo();
			String command = null;
			if (pathInfo != null) {
				command = processRestful(request, response, pathInfo.substring(1));
			} else {
				command = ServletUtil.getRequestAttribute(request, "command");
				handleRequest(request, response, command);
			}

			if (logger.isTraceEnabled()) {
				String email = null;
				try {
					email = getUser(request).email;
				} catch (final Exception e) {
				}

				logger.trace("doPost() request arrived from " + request.getRemoteAddr() + " email: " + email
						+ " command: " + command + " processTime: " + (System.currentTimeMillis() - startTime));
			}

		} catch (Exception e) {
			logger.fatal("!!!doPost(): ", e);

			Throwable throwable = e;
			if (e instanceof InvocationTargetException) {
				throwable = ((InvocationTargetException) e).getCause();
			}
			addExceptionToHistory(System.currentTimeMillis(), throwable, request);

			String message = throwable.getMessage();
			
			if(EmailNotFoundException.class.isInstance(throwable))
			{
			    EmailNotFoundException emailNotFoundException = EmailNotFoundException.class.cast(throwable);
                            message = emailNotFoundException.getMessage();
                            
                            try {
                                String languageCode = ServletUtil.getRequestAttribute(request, "language");
                                final ResourceBundle language = languageUtil.getLanguage(languageCode);
                                
                                message = String.format(language.getString("email.not.found"), emailNotFoundException.getEmail());
                                
                                writeErrorResponse(response, message);
                                return;
                                
                            } catch (MissingRequestParameterException e1) {
                            }
			}
			else if(UserNotLoggedInException.class.isInstance(throwable))
			{
				redirectToMainPage(request, response, true);
				return;
			}

			writeErrorResponse(response, "Error: <b>" + message + "</b>");
		}
	}

	private LanguageUtil languageUtil = new LanguageUtil();

    private String processRestful(HttpServletRequest request, HttpServletResponse response, String pathInfo)
			throws Exception {
		if (pathInfo.indexOf('/') > -1) {
			final String[] splitText = pathInfo.split("/");
			final String command = splitText[0];

			if (Command.LOADIMAGE.name().equals(command)) {
				response.setContentType("image/jpeg");

				final String params = splitText[1];
				final int modelId = Integer.parseInt(params.substring(params.indexOf("=") + 1));
				try {
					loadImage(modelId, response.getOutputStream());
				} catch (final Exception e) {
				    response.setContentType("text/html");
				    writeErrorResponse(response, e.getMessage());
				}
			}
			else
                            throw new IllegalArgumentException("Unrecognized path: " + pathInfo);
			return command;
		} else {
			handleRequest(request, response, pathInfo);
			return pathInfo;
		}

	}

	private void handleRequest(HttpServletRequest request, HttpServletResponse response, String command)
			throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
		getClass().getMethod(command, new Class[] { HttpServletRequest.class, HttpServletResponse.class }).invoke(this,
				new Object[] { request, response });
	}

	private void writeErrorResponse(final HttpServletResponse response, final String message) throws IOException {
		final StringBuilder buff = new StringBuilder();

		buff.append("<html>\n");

		buff.append("<head>\n");
		buff.append("<link href='jsp/base.css' rel='stylesheet' type='text/css'>\n");
		buff.append("</head>\n");

		buff.append("<body>\n");
		buff.append("<div class='flash error'>\n");
		buff.append(message);
		buff.append("</div>\n");
		buff.append("</body></html>\n");

		ServletUtil.writeResponse(response, buff);
	}

	public void directLogin(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final int userID = Integer.parseInt(ServletUtil.getRequestAttribute(request, "userID"));
		loginSuccessful(request, response, servletDAO.getUser(userID), ServletUtil.encodeString(ServletUtil.getRequestAttribute(request, "show")));
	}

	public void directPrintModels(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final int userID = Integer.parseInt(ServletUtil.getRequestAttribute(request, "userID"));
	
		printModelsForUser(request, response, languageUtil.getLanguage(ServletUtil.getRequestAttribute(request, "language")),
				userID, true/* alwaysPageBreak */);
		showPrintDialog(response);
		return;
	}
	
	public void getModelInfo(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final String modelID = ServletUtil.getRequestAttribute(request, "modelID");

		final Model model = servletDAO.getModel(Integer.parseInt(modelID));

		final StringBuilder buff = new StringBuilder();

		buff.append(servletDAO.getCategory(model.categoryID).categoryCode);
		buff.append(" - ");
		buff.append(model.scale);
		buff.append(" - ");
		buff.append(model.name);

		ServletUtil.writeResponse(response, buff);
	}

	public void getSimilarLastNames(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final String lastname = ServletUtil.getRequestAttribute(request, "lastname");

		final StringBuilder buff = new StringBuilder();

		final ByteArrayOutputStream bout = new ByteArrayOutputStream();
		final XMLEncoder e = new XMLEncoder(bout);
		e.writeObject(servletDAO.getSimilarLastNames(lastname));
		e.close();

		buff.append(bout.toString());

		ServletUtil.writeResponse(response, buff);
	}

	public void login(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final String email = ServletUtil.getRequestAttribute(request, "email");
		final ResourceBundle language = languageUtil.getLanguage(ServletUtil.getRequestAttribute(request, "language"));

			final User user = servletDAO.getUser(email);

			final String passwordInRequest = ServletUtil.encodeString(ServletUtil.getRequestAttribute(request, "password"));

			String show;
			
			try {
				show = ServletUtil.encodeString(ServletUtil.getRequestAttribute(request, "show"));
			} catch (final Exception e) {
				if(user.isAdminUser() || isOnSiteUse())
					show = null;
				else
				{
					writeErrorResponse(response, languageUtil.getLanguage(user.language).getString("select.show"));
					return;
				}
			}
			
			if (!user.enabled || // 
					!StringEncoder.encode(passwordInRequest).equals(user.password) || // 
					(user.isCategoryAdminUser() && !user.getEmail().equals(StringEncoder.fromBase64(show)))) {
				logger.info("login(): Authentication failed. email: " + email + " user.password: [" + user.password
						+ "] HTTP password: [" + ServletUtil.getRequestAttribute(request, "password")
						+ "] user.enabled: " + user.enabled);

				writeErrorResponse(response, language.getString("authentication.failed") + " "
						+ language.getString("email") + ": [" + email + "]");
			} else {
				loginSuccessful(request, response, user, show);
			}
		}

	private void loginSuccessful(final HttpServletRequest request, final HttpServletResponse response, final User user, final String show)
			throws IOException, SQLException {
		logger.info("login(): login successful. email: " + user.email + " user.language: " + user.language + " show: "
				+ show);
		
		saveLoginConsentData(request, user);
		
		initHttpSession(request, user, show);
		
		System.out.println(systemParameters);
		
		EnumMap<SYSTEMPARAMETER, String> enumMap = systemParameters.get(show);
		if(enumMap == null) {
			systemParameters.put(show, new EnumMap(SYSTEMPARAMETER.class));
		}

		redirectToMainPage(request, response);
	}

    private void saveLoginConsentData(HttpServletRequest request, User user) {
		servletDAO.deleteLoginConsentData(user.getId());

		for (LoginConsentType type : LoginConsent.LoginConsentType.values()) {
			if (ServletUtil.isCheckedIn(request, "dataUsageConsent" + type.name())) {
				LoginConsent lc = new LoginConsent(servletDAO.getNextID(LoginConsent.class), user.getId(), type);
				servletDAO.save(lc);
			}
		}
    }

    private void initHttpSession(final HttpServletRequest request, final User user, String show) throws SQLException {
        final HttpSession session = request.getSession(true);
        session.setAttribute(CommonSessionAttribute.UserID.name(), user);
        ResourceBundle language = languageUtil.getLanguage(user.language);
		session.setAttribute(CommonSessionAttribute.Language.name(), language);
        session.setAttribute(SessionAttribute.ShowId.name(), ServletUtil.getOptionalRequestAttribute(request, "showId"));

        if (user.language.length() != 2) // admin user
            session.setAttribute(SessionAttribute.MainPageFile.name(), user.language + "_" + MainPageType.Old.getFileName());
        else
            session.setAttribute(SessionAttribute.MainPageFile.name(), getDefaultMainPageFile());
        
        if (show != null) {
        	show = StringEncoder.fromBase64(show);
            session.setAttribute(SessionAttribute.Show.name(), show);
            
            Map<Integer, Category> categories = servletDAO.getCategoryList(show).stream()
                    .collect(Collectors.toMap(category -> category.getId(), Function.identity()));
            session.setAttribute(SessionAttribute.Categories.name(), categories);

        }
        
        if(user.getFullName().split(" ").length == 1) {
        	setNoticeInSession(session, new MainPageNotice(MainPageNotice.NoticeType.Error, "<a href='user.jsp?action=modifyUser'>(" + user.getFullName() + ") " + language.getString("name.too.short") + "</a>"));
        }
    }

    private void redirectToMainPage(final HttpServletRequest request, final HttpServletResponse response) throws IOException {
        redirectToMainPage(request, response, false);
    }

    private void redirectToMainPage(final HttpServletRequest request, final HttpServletResponse response, boolean goToParentDir) throws IOException {
        response.sendRedirect((goToParentDir ? "../" : "") + "jsp/"+getMainPageFile(request.getSession(false)));
    }
    
    private String getMainPageFile(HttpSession session) {
        return session!= null ?  (String) session.getAttribute(SessionAttribute.MainPageFile.name()) : getDefaultMainPageFile();
    }
    
    private String getDefaultMainPageFile() {
        return MainPageType.New.getFileName();
    }

	public void sql(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final StringBuilder buff = servletDAO.execute(ServletUtil.getRequestAttribute(request, "sql"));

		if (buff == null) {
			redirectToMainPage(request, response);
		} else {
			ServletUtil.writeResponse(response, buff);
		}
	}

	public void reminder(final HttpServletRequest request,

			final HttpServletResponse response) throws Exception {
		final User user = servletDAO.getUser(ServletUtil.getRequestAttribute(request, "email"));
		final String newPassword = UUID.randomUUID().toString().substring(0, 8);
		user.setPassword(StringEncoder.encode(newPassword));
		servletDAO.modifyUser(user, user);

		final ResourceBundle language = languageUtil.getLanguage(user.language);

		final StringBuilder buff = new StringBuilder();
		buff.append("<html><body>");
		buff.append(language.getString("password") + ": " + "<FONT COLOR='#ff0000'><B>" + newPassword + "</B></FONT>");
		buff.append("<BR>");
		buff.append(language.getString("password.change"));
		buff.append("</body></html>");

		sendEmail(user.email, language.getString("email.subject"), buff);

		ServletUtil.writeResponse(response, getEmailWasSentResponse(language, request));
	}

	public void batchAddModel(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final String languageCode = ServletUtil.getRequestAttribute(request, "language");
		final ResourceBundle language = languageUtil.getLanguage(languageCode);

		final int rows = Integer.parseInt(ServletUtil.getRequestAttribute(request, "rows"));

		final List<Model> models = new LinkedList<Model>();
		final List<User> users = new LinkedList<User>();
		User user = null;
		for (int i = 1; i <= rows; i++) {
			final String httpParameterPostTag = String.valueOf(i);

			if (ServletUtil.getRequestAttribute(request, "lastname" + httpParameterPostTag).trim().length() == 0) {
				continue;
			}

			// register model for new user...
			if (i == 1 || !(
			ServletUtil.getRequestAttribute(request, "lastname" + httpParameterPostTag)).equals((
			ServletUtil.getRequestAttribute(request, "lastname" + String.valueOf(i - 1))))) {

				user = directRegisterUser(request, language, httpParameterPostTag);
				users.add(user);
			}

			final Model model = new Model(servletDAO.getNextID(Model.class));
			model.setUser(user);
			createModel(model, request, httpParameterPostTag);

			servletDAO.save(model);

			models.add(model);
		}

		if (user != null && user.email != null) {
			sendEmailWithModels(user, true);
		}

		if (!users.isEmpty()) {
			for (final User user1 : users) {
				ServletUtil.writeResponse(response,
						printModelsForUser(language, user1.getId(), request, true /* allModelsPrinted */));
			}
		}
		showPrintDialog(response);
	}

	private void showPrintDialog(final HttpServletResponse response) throws IOException {
		response.getOutputStream().write("<script>window.print();</script>".getBytes());
	}

	public void directRegister(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		// set language library
		final String languageCode = ServletUtil.getRequestAttribute(request, "language");
		final ResourceBundle language = languageUtil.getLanguage(languageCode);

		final User user = directRegisterUser(request, language, "");
		initHttpSession(request, user,  StringEncoder.toBase64(servletDAO.getShows().get(0).getBytes()));
		redirectToMainPage(request, response, true);
	}

	public void exportData(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

		final List data = new ArrayList(4);
		data.add(servletDAO.getUsers());
		data.add(servletDAO.getCategoryGroups());
		data.add(servletDAO.getCategoryList(null));
		data.add(servletDAO.getModels(ServletDAO.INVALID_USERID));

		if ("yes".equals(ServletUtil.getOptionalRequestAttribute(request, "photos"))) {
			data.add(servletDAO.getPhotos());
		}

		response.setContentType("application/zip");
		final GZIPOutputStream e = new GZIPOutputStream(response.getOutputStream());
		e.write(Serialization.serialize(data));
		e.close();
	}

	public static String getShowFromSession(final HttpServletRequest request) {
		return getShowFromSession(request.getSession());
	}

	public static String getShowFromSession(final HttpSession session) {
		return (String) session.getAttribute(SessionAttribute.Show.name());
	}

	public void exportCategoryData(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final String show = getShowFromSession(request);

		final List data = new ArrayList(4);
		data.add(new LinkedList<User>());

		final List<CategoryGroup> categoryGroups = servletDAO.getCategoryGroups();
		final Iterator<CategoryGroup> iterator = categoryGroups.iterator();
		while (iterator.hasNext()) {
			final CategoryGroup categoryGroup = iterator.next();
			if (!categoryGroup.show.equals(show)) {
				iterator.remove();
			}
		}
		data.add(categoryGroups);
		data.add(servletDAO.getCategoryList(show));
		data.add(new LinkedList<Model>());

		response.setContentType("application/zip");
		final GZIPOutputStream e = new GZIPOutputStream(response.getOutputStream());
		e.write(Serialization.serialize(data));
		e.close();
	}

        public void exportExcel(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
            final String show = getShowFromSession(request);
    
            response.setContentType("application/vnd.ms-excel");
    
            ResourceBundle language = getLanguageForCurrentUser(request);
            final List<Model> models = servletDAO.getModels(ServletDAO.INVALID_USERID);
            Map<Integer, User> userIDs = models.stream().mapToInt(Model::getUserID).distinct().mapToObj(userID -> {
                try {
                    return servletDAO.getUser(userID);
                } catch (SQLException e1) {
                    logger.error("", e1);
                    return null;
                }
            }).collect(Collectors.toMap(User::getId, Function.identity()));
            
            Map<Integer, Category> categories = (Map<Integer, Category>) ServletUtil.getSessionAttribute(request,
				SessionAttribute.Categories.name());
    
            List<List<Object>> modelsForExcel = getModelsForShow(show, models, categories).stream().map(model -> {
                ArrayList<Object> returned = new ArrayList<>();
                Category category = categories.get(model.categoryID);
                final User modelsUser = userIDs.get(model.getUserID());
   
                returned.add(StringEscapeUtils.unescapeHtml4(category.group.show));
                returned.add(StringEscapeUtils.unescapeHtml4(modelsUser.lastName));
                returned.add(StringEscapeUtils.unescapeHtml4(modelsUser.city));
                returned.add(StringEscapeUtils.unescapeHtml4(modelsUser.country));
                returned.add(modelsUser.getId());
                returned.add(model.getId());
                returned.add(StringEscapeUtils.unescapeHtml4(category.categoryCode));
                returned.add(StringEscapeUtils.unescapeHtml4(model.name));
                returned.add(StringEscapeUtils.unescapeHtml4(model.scale));
                returned.add(StringEscapeUtils.unescapeHtml4(model.identification));
                returned.add(StringEscapeUtils.unescapeHtml4(model.markings));
                returned.add(StringEscapeUtils.unescapeHtml4(model.producer));
                returned.add(StringEscapeUtils.unescapeHtml4(category.categoryDescription));
                return returned;
    
            }).collect(Collectors.toList());
            Workbook u = ExcelUtil.generateExcelTableWithHeaders("model", Arrays.asList(
                    StringEscapeUtils.unescapeHtml4(language.getString("show")), StringEscapeUtils.unescapeHtml4(language.getString("name")),
                    StringEscapeUtils.unescapeHtml4(language.getString("city")), StringEscapeUtils.unescapeHtml4(language.getString("country")),
                    StringEscapeUtils.unescapeHtml4(language.getString("userID")),
                    StringEscapeUtils.unescapeHtml4(language.getString("modelID")),
                    StringEscapeUtils.unescapeHtml4(language.getString("category.code")),
                    StringEscapeUtils.unescapeHtml4(language.getString("models.name")),
                    StringEscapeUtils.unescapeHtml4(language.getString("scale")),
                    StringEscapeUtils.unescapeHtml4(language.getString("models.identification")),
                    StringEscapeUtils.unescapeHtml4(language.getString("models.markings")),
                    StringEscapeUtils.unescapeHtml4(language.getString("models.producer")),
                    StringEscapeUtils.unescapeHtml4(language.getString("category.description"))), modelsForExcel);
    
            u.writeTo(response.getOutputStream());
        }

		public static List<Model> getModelsForShow(final String show, final List<Model> models,
				Map<Integer, Category> categories) {
			return models.stream().filter(model -> {
                Category category = categories.get(model.categoryID);
                if(category == null)
                	return false;
				return show == null || category.group.show.equals(show);
            }).collect(Collectors.toList());
		}
	
	public void importData(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final DiskFileItemFactory factory = new DiskFileItemFactory();
		final ServletFileUpload upload = new ServletFileUpload(factory);

		final Map<String, String> parameters = new HashMap<String, String>();

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
		if ("imageFile".equals(item.getFieldName())) {
			final int modelID = Integer.parseInt(parameters.get("modelID"));

			final BufferedImage originalImage = ImageUtil.load(item.getInputStream());
			final BufferedImage resizedImage = ImageUtil.resize(originalImage, 800);

			final ByteArrayOutputStream output = new ByteArrayOutputStream();

			ImageUtil.save(resizedImage, output);

			servletDAO.saveImage(modelID, new ByteArrayInputStream(output.toByteArray()));

			redirectToMainPage(request, response);
		} else if ("zipFile".equals(item.getFieldName())) {
			final StringBuilder buff = importZip(request, item.getInputStream());
			ServletUtil.writeResponse(response, buff);
		}
	}

	private StringBuilder importZip(final HttpServletRequest request, final InputStream stream)
			throws IOException, SQLException, Exception, IOError {
		final GZIPInputStream e = new GZIPInputStream(stream);
		final List<List> data = (List<List>) Serialization.deserialize(e);
		e.close();

		final StringBuilder buff = new StringBuilder();

		final List<CategoryGroup> categoryGroups = data.get(1);

		if (!categoryGroups.isEmpty()) {
			final List<Model> models = data.get(3);
			if(!models.isEmpty()) {
				servletDAO.deleteAll(Model.class);			    
				buff.append("<p>Storing Models");
				for (final Model model : models) {
					buff.append(".");
					servletDAO.save(model);
				}
			}

			servletDAO.deleteAll(Category.class);
			servletDAO.deleteAll(CategoryGroup.class);

			final List<Category> categories = data.get(2);
			buff.append("<p>Storing Categories");
			for (final Category category : categories) {
				System.out.println("category: " + category);
				buff.append(".");
				if (category.getModelClass() == null) {
					category.setModelClass(ModelClass.Other);
				}
				servletDAO.save(category);
			}
			buff.append("<p>Storing CategoryGroups");
			for (final CategoryGroup categoryGroup : categoryGroups) {
				buff.append(".");
				servletDAO.save(categoryGroup);
			}
		}

		if (data.size() >= 5) {
			buff.append("<p>Storing Photos");
			servletDAO.deleteEntries("MAK_PICTURES");
			final Map<Integer, byte[]> photos = (Map<Integer, byte[]>) data.get(4);
			for (final Entry<Integer, byte[]> photoEntries : photos.entrySet()) {
				final ByteArrayInputStream photoStream = new ByteArrayInputStream(photoEntries.getValue());
				servletDAO.saveImage(photoEntries.getKey(), photoStream);
				photoStream.close();
				buff.append(".");
			}
		}

		final List<User> users = data.get(0);
		if(!users.isEmpty())
		{
		    buff.append("<p>Storing users");
		    servletDAO.deleteAll(User.class);
    		for (final User user : users) {
    			buff.append(".");
    			servletDAO.save(user);
    			for (final ModelClass modelClass : user.getModelClass()) {
    				servletDAO.saveModelClass(user.getId(), modelClass);
    			}
    		}
		}

		buff.append("<p>DONE.....");
		return buff;
	}

	public void deleteDataForShow(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final String show = getShowFromSession(request);

		for (final AwardedModel awardedModel : servletDAO.getAwardedModels()) {
			if (servletDAO.getCategory(awardedModel.categoryID).group.show.equals(show)) {
				servletDAO.deleteAwardedModel(awardedModel.getId());
			}
		}

		for (final Model model : servletDAO.getModels(servletDAO.INVALID_USERID)) {
			if (servletDAO.getCategory(model.categoryID).group.show.equals(show)) {
				servletDAO.deleteModel(model);
			}
		}

		for (final Category category : servletDAO.getCategoryList(show)) {
			servletDAO.delete(category);
		}

		for (final CategoryGroup categoryGroup : servletDAO.getCategoryGroups()) {
			if (categoryGroup.show.equals(show)) {
				servletDAO.delete(categoryGroup);
			}
		}
		
		systemParameters.remove(show);

		redirectToMainPage(request, response);
	}

	private User directRegisterUser(final HttpServletRequest request, final ResourceBundle language,
			final String httpParameterPostTag) throws Exception {
		final String password = "-";
		final String userName = ServletUtil.getRequestAttribute(request, "fullname" + httpParameterPostTag)
				// + ServletUtil.getRequestAttribute(request, "firstname" +
				// httpParameterPostTag)
				+ User.LOCAL_USER + System.currentTimeMillis();

		servletDAO.save(createUser(request, userName, password, httpParameterPostTag));

		final User user = servletDAO.getUser(userName);
		return user;
	}

	public void register(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final String email = ServletUtil.getRequestAttribute(request, "email");
		final String languageCode = ServletUtil.getRequestAttribute(request, "language");
		final ResourceBundle language = languageUtil.getLanguage(languageCode);

		if (email.trim().length() == 0 || ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(email) || email.indexOf("@") == -1 || email.indexOf(".") == -1) {
			writeErrorResponse(response, language.getString("authentication.failed") + " " + language.getString("email")
					+ ": [" + email + "]");
			return;
		}

		if (servletDAO.userExists(email)) {
			final RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/userExists.jsp");
			dispatcher.forward(request, response);
			return;
		}

		final String password = ServletUtil.getRequestAttribute(request, "password");

		if (!password.equals(ServletUtil.getRequestAttribute(request, "password2"))) {
			writeErrorResponse(response, language.getString("passwords.not.same"));
			return;
		}

		final User user = createUser(request, email);
		servletDAO.save(user);

		sendEmailWithModels(user, true);

		ServletUtil.writeResponse(response, getEmailWasSentResponse(language, request));
	}

	private StringBuilder getEmailWasSentResponse(final ResourceBundle language, HttpServletRequest request) {
		final StringBuilder buff = new StringBuilder();
		buff.append("<html><body>");

		buff.append(language.getString("email.was.sent"));
		buff.append("<p>");
		buff.append("<a href='../" + getStartPage(request) + "'>" + language.getString("proceed.to.login") + "</a></body></html>");
		return buff;
	}

	public void modifyUser(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final User oldUser = getUser(request);
		final ResourceBundle language = languageUtil.getLanguage(oldUser.language);

		final User newUser = createUser(request, ServletUtil.getRequestAttribute(request, "email"));
		newUser.setId(oldUser.getId());
		if (!newUser.isAdminUser() && !newUser.isLocalUser() && (newUser.email.trim().length() == 0
				|| ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(newUser.email) || newUser.email.indexOf("@") == -1)) {
			writeErrorResponse(response, language.getString("authentication.failed") + " " + language.getString("email")
					+ ": [" + newUser.email + "]");
			return;
		}

		servletDAO.modifyUser(newUser, oldUser);

		HttpSession session = request.getSession(false);
                session.setAttribute(CommonSessionAttribute.Language.name(), languageUtil.getLanguage(newUser.language));
                session.setAttribute(CommonSessionAttribute.UserID.name(), servletDAO.getUser(oldUser.getId()));

		redirectToMainPage(request, response, true);
	}

	public void deleteUser(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final User user = getUser(request);
		final ResourceBundle language = languageUtil.getLanguage(user.language);

		servletDAO.deleteUser(user.getId());

		final StringBuilder buff = new StringBuilder();
		buff.append("<html><body>");

		buff.append("<a href='" + getStartPage(request) + "'>" + language.getString("proceed.to.login") + "</a></body></html>");

		ServletUtil.writeResponse(response, buff);

	}

	private void sendEmailWithModels(final User user, final boolean insertUserDetails)
			throws SQLException, MessagingException, MissingServletConfigException, IOException {
		final StringBuilder message = new StringBuilder();
		final ResourceBundle language = languageUtil.getLanguage(user.language);

		message.append("<html><body>\n\r");

		final List<Model> models = servletDAO.getModels(user.getId());

		if (!models.isEmpty()) {
			message.append(language.getString("email.body1"));
			message.append("\n\r<p>");
			message.append(language.getString("email.body2"));
			message.append("\n\r<p>");
			message.append(language.getString("email.body3"));
			message.append("\n\r<p>");
			message.append("\n\r<hr>");
		}

		List<EmailParameter> modelerParameters = new LinkedList<EmailParameter>( Arrays.asList(//
				EmailParameter.create(language.getString("userID"), String.valueOf(user.getId())), //
				EmailParameter.create(language.getString("name"), user.lastName), //
				EmailParameter.create(language.getString("year.of.birth"), String.valueOf(user.yearOfBirth)), //
				EmailParameter.create(language.getString("city"), user.city), //
				EmailParameter.create(language.getString("country"), user.country)//
		));
		if (insertUserDetails) {
			modelerParameters.add(EmailParameter.create(language.getString("email"), user.email));
			modelerParameters.add(EmailParameter.create(language.getString("language"), user.language));
			modelerParameters.add(EmailParameter.create(language.getString("address"), user.address));
			modelerParameters.add(EmailParameter.create(language.getString("telephone"), user.telephone));
		}

		addEmailParameters(message, modelerParameters);

		message.append("<p>\n\r");

		for (final Model model : models) {

			message.append("\n\r<hr>");
			final Category category = servletDAO.getCategory(model.categoryID);
			List<EmailParameter> modelParameters = Arrays.asList(//
					EmailParameter.create(language.getString("show"), category.group.show), //
					EmailParameter.create(language.getString("modelID"), String.valueOf(model.getId())), //
					EmailParameter.create(language.getString("models.name"), model.name), //
					EmailParameter.create(language.getString("scale"), model.scale), //
					EmailParameter.create(language.getString("models.producer"), model.producer), //
					EmailParameter.create(language.getString("category.code"), category.categoryCode), //
					EmailParameter.create(language.getString("category.description"), category.categoryDescription), //
					EmailParameter.create(language.getString("models.identification"), model.identification), //
					EmailParameter.create(language.getString("models.markings"), model.markings) //
			);

			addEmailParameters(message, modelParameters);
		}

		message.append("\n\r</body></html>");

		sendEmail(user.email, language.getString("email.subject"), message);
	}

	public void addEmailParameters(final StringBuilder message, List<EmailParameter> modelerParameters) {
		for (EmailParameter parameter : modelerParameters) {
			message.append("<b>");
			message.append(parameter.getName());
			message.append(":</b> ");
			message.append(parameter.getValue());
			message.append("\n\r<br>\n\r");
			// message.append("<p>\n\r");
		}
	}

	private void sendEmail(final String to, final String subject, final StringBuilder message)
			throws MessagingException, MissingServletConfigException, IOException {
		if (to.trim().length() == 0 || to.equals("-") || to.indexOf("@") == -1) {
			return;
		}
		if (!isOnSiteUse())
		    emailUtil.sendEmail(getServerConfigParamter("email.from"),
					to, subject, message.toString());
	}

	public void addCategory(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		if(getUser(request).isAdminUser() && !isRegistrationAllowed(getShowFromSession(request))) {
			Category modifyingCategory;
			try {
				modifyingCategory = servletDAO.getCategory(Integer.valueOf(ServletUtil.getOptionalRequestAttribute(request, "categoryID")));
			} catch (Exception e) {
				modifyingCategory = new Category(servletDAO.getNextID(Category.class));
			}
			
			modifyingCategory.setCategoryCode(
	            ServletUtil.getRequestAttribute(request, "categorycode"));
			modifyingCategory.setCategoryDescription(
	            ServletUtil.getRequestAttribute(request, "categorydescription"));
			modifyingCategory.setGroup(
	            servletDAO.getCategoryGroup(
	                    Integer.parseInt(ServletUtil.getRequestAttribute(request, "categoryGroupID")),
	                    servletDAO.getCategoryGroups()));
			modifyingCategory.setMaster(
	            ServletUtil.isCheckedIn(request, "master"));
			modifyingCategory.setModelClass(
	            ModelClass.valueOf(ServletUtil.getRequestAttribute(request, "modelClass")));
			modifyingCategory.setAgeGroup(
	            AgeGroup.valueOf(ServletUtil.getRequestAttribute(request, "ageGroup"))
	            );
	    
		servletDAO.save(modifyingCategory);
		}		
		else {
			writeCategoryModificationErrorResponse(response);
			return;
		}
		redirectToMainPage(request, response);
	}
	
	public void encodeCategories(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		String show = getShowFromSession(request);
		
		servletDAO.getCategoryList(show).forEach(category -> {
			category.setCategoryCode(ServletUtil.encodeString(category.getCategoryCode()));				
			category.setCategoryDescription(ServletUtil.encodeString(category.getCategoryDescription()));			
			servletDAO.save(category);
		});
		redirectToMainPage(request, response, true);
	}

	public void encodeCategorGroups(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		servletDAO.getCategoryGroups().forEach(group -> {
			group.setGroup(ServletUtil.encodeString(group.getGroup()));				
			group.setShow(ServletUtil.encodeString(group.getShow()));			
			servletDAO.save(group);
		});
		redirectToMainPage(request, response, true);
	}
	
	public void encodeModels(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		servletDAO.getAll(Model.class).forEach(model -> {
			model.setComment(ServletUtil.encodeString(model.getComment()));
			model.setIdentification(ServletUtil.encodeString(model.getIdentification()));
			model.setMarkings(ServletUtil.encodeString(model.getMarkings()));
			model.setName(ServletUtil.encodeString(model.getName()));
			model.setProducer(ServletUtil.encodeString(model.getProducer()));
			model.setScale(ServletUtil.encodeString(model.getScale()));
			servletDAO.save(model);
		});
		redirectToMainPage(request, response, true);
	}

	private void writeCategoryModificationErrorResponse(final HttpServletResponse response) throws IOException {
		writeErrorResponse(response, "Most m&aacute;r nem lehet m&oacute;dos&iacute;tani! El&#337;ször az 'El&#337;nevez&eacute;s v&eacute;ge' vagy 'Helysz&iacute;ni m&oacute;d' linkre kell kattintani az admin oldalon.");
	}
	
	public void saveModelClass(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final int userID = Integer.valueOf(ServletUtil.getRequestAttribute(request, "userID"));

		servletDAO.saveModelClass(userID, ModelClass.valueOf(ServletUtil.getRequestAttribute(request, "modelClass")));

		redirectToMainPage(request, response);
	}

	public void addCategoryGroup(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		if(getUser(request).isAdminUser() && !isRegistrationAllowed(getShowFromSession(request))) {
			String show = ServletUtil.encodeString(ServletUtil.getRequestAttribute(request, "show"));
		final CategoryGroup categoryGroup = new CategoryGroup(servletDAO.getNextID(CategoryGroup.class),
				show, ServletUtil.getRequestAttribute(request, "group"));

    	final HttpSession session = request.getSession(false);
        session.setAttribute(SessionAttribute.Show.name(), show);

		servletDAO.save(categoryGroup);
		}
		else {
			writeCategoryModificationErrorResponse(response);
			return;
		}
		redirectToMainPage(request, response);
	}

	public void listUsers(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		ServletUtil.writeResponse(response, getUserTable(getUser(request)));
	}

	public void listCategories(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final StringBuilder buff = new StringBuilder();

		getCategoryTable(buff, servletDAO.getCategoryList(getShowFromSession(request)),
				getLanguageForCurrentUser(request));

		ServletUtil.writeResponse(response, buff);
	}

	private void getCategoryTable(final StringBuilder buff, final List<Category> categories,
			final ResourceBundle language) throws SQLException {
		buff.append("<table border=1>");
		buff.append("<tr>");
		buff.append("<th>CategoryID</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("show"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("group"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("category.code"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("category.description"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append("Mester");
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append("Szak&aacute;g");
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append("Korcsoport");
		buff.append("</th>");

		buff.append("</tr>");

		for (final Category category : categories) {
			buff.append("<tr>");
			buff.append("<td align='center' >");
			buff.append(category.getId());
			buff.append("</td>");
			buff.append("<td align='center' >");
			buff.append(category.group.show);
			buff.append("</td>");
			buff.append("<td align='center' >");
			buff.append(category.group.name);
			buff.append("</td>");
			buff.append("<td align='center' >");
			buff.append(category.categoryCode);
			buff.append("</td>");
			buff.append("<td align='center' >");
			buff.append(category.categoryDescription);
			buff.append("</td>");
			buff.append("<td align='center' >");
			buff.append("<input type='checkbox' " + (category.isMaster() ? "checked" : "") + ">");
			buff.append("</td>");
			buff.append("<td align='center' >");
			buff.append(category.getModelClass().name());
			buff.append("</td>");
			buff.append("<td align='center' >");
			buff.append(category.getAgeGroup().name());
			buff.append("</td>");
			buff.append("</tr>");
		}

		buff.append("</table>");
	}

	public StringBuilder getUserTable(final User loggedInUser) throws Exception {
		final ResourceBundle language = languageUtil.getLanguage(loggedInUser.language);

		final StringBuilder buff = new StringBuilder();

		final List<User> users = servletDAO.getUsers();

		buff.append("<table border=1>");
		buff.append("<tr>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("userID"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("email"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("password"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("name"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("year.of.birth"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("country"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append("Szakoszt&aacute;ly");
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("language"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("city"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("address"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append(language.getString("telephone"));
		buff.append("</th>");

		buff.append("<th style='white-space: nowrap'>");
		buff.append("Login consent");
		buff.append("</th>");
		
		buff.append("</tr>");

		for (final User user : users) {
			if(!loggedInUser.isSuperAdminUser() && user.isAdminUser()) {
				continue;
			}

			buff.append("<tr>");

			buff.append("<td align='center' >");
			buff.append(user.getId());
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.email);
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.password);
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.lastName);
			buff.append("</td>");

			// buff.append("<td align='center' >");
			// buff.append(user.firstName);
			// buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.yearOfBirth);
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.country);
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.getModelClass());
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.language);
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.city);
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.address);
			buff.append("</td>");

			buff.append("<td align='center' >");
			buff.append(user.telephone);
			buff.append("</td>");

			
			buff.append("<td align='center' >");
            buff.append(servletDAO.getLoginConsents(user.getId()).stream().map(lc -> lc.getType().name()).collect(Collectors.joining(", ")));
			buff.append("</td>");
			
			buff.append("</tr>");
		}

		buff.append("</table>");

		return buff;
	}

	private Object getLoginConsents(int userID) {
        // TODO Auto-generated method stub
        return null;
    }

    public void inputForAddCategory(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final ResourceBundle language = getLanguageForCurrentUser(request);
		
		Category category = null;
		try {
                    category = servletDAO.getCategory(Integer.valueOf(ServletUtil.getOptionalRequestAttribute(request, "categoryID")));
                } catch (Exception e) {
                    category = new Category(servletDAO.getNextID(Category.class));
                    category.setCategoryCode("");
                    category.setCategoryDescription("");
                    category.setGroup(new CategoryGroup(0));
                }

		final StringBuilder buff = new StringBuilder();

		buff.append("<html>");
		buff.append("<head>");
		buff.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />");
		buff.append("</head>");
		buff.append("<body>");

		buff.append("<form accept-charset=\"UTF-8\" name='input' action='./RegistrationServlet' method='POST'>");
		buff.append("<input type='hidden' name='command' value='addCategory'>");
		if(category.getId() != 0)
		    buff.append("<input type='hidden' name='categoryID' value='" + category.getId() +"'>");
		buff.append("<table border='0'>");

		buff.append("<tr>");
		buff.append("<td>");
		buff.append(language.getString("group"));
		buff.append(": ");
		buff.append("</td>");

		buff.append("<td>");

		final String show = getShowFromSession(request);
		for (final CategoryGroup group : servletDAO.getCategoryGroups()) {
			if (!group.show.equals(show)) {
				continue;
			}

			buff.append("<label><input type='radio' name='categoryGroupID' value='" + group.getId() + "' "
			        + (group.getId() == category.getGroup().getId() ? "checked='checked'" :  "")
			        + "/>");
			buff.append(group.show + " - " + group.name + "</label><br>");
		}

		buff.append("<font color='#FF0000' size='+3'>&#8226;</font> </td>");

		buff.append("</tr>");

		buff.append("<tr>");
		buff.append("<td>");
		buff.append(language.getString("category.code"));
		buff.append(": ");
		buff.append("</td>");
		buff.append("<td><input type='text' name='categorycode' value='"+category.getCategoryCode()+"'> <font color='#FF0000' size='+3'>&#8226;</font> </td>");
		buff.append("</tr>");

		buff.append("<tr>");
		buff.append("<td>");
		buff.append(language.getString("category.description"));
		buff.append(": ");
		buff.append("</td>");
		buff.append(
				"<td><input type='text' name='categorydescription' value='"+category.getCategoryDescription()+"'> <font color='#FF0000' size='+3'>&#8226;</font> </td>");
		buff.append("</tr>");

		buff.append("<tr>");
		buff.append("<td>");
		buff.append("Mester: ");
		buff.append("</td>");
		buff.append("<td><input name='master' type='checkbox' value='on' "+(category.isMaster() ? "checked" : "") +"></td>");
		buff.append("</tr>");

		buff.append("<tr>");
		buff.append("<td>");
		buff.append("Szak&aacute;g: ");
		buff.append("</td>");
		buff.append("<td><select name='modelClass'>");
		if(category.getModelClass() != null)
		    buff.append("<option value='" + category.getModelClass().name() + "'>" + category.getModelClass().name() + "</option>");
		for (final ModelClass mc : ModelClass.values()) {
			buff.append("<option value='" + mc.name() + "'>" + mc.name() + "</option>");
		}
		buff.append("</select>");
		buff.append("</td>");
		buff.append("</tr>");

		buff.append("<tr>");
		buff.append("<td>");
		buff.append("Korcsoport: ");
		buff.append("</td>");
		buff.append("<td><select name='ageGroup'>");
                if(category.getAgeGroup() != null)
                    buff.append("<option value='" + category.getAgeGroup().name() + "'>" + category.getAgeGroup().name() + "</option>");
                else
                    buff.append("<option value='" + AgeGroup.ALL.name() + "' selected>" + AgeGroup.ALL.name() + "</option>");
                
		for (final AgeGroup mc : AgeGroup.values()) {
			buff.append("<option value='" + mc.name() + "'>" + mc.name() + "</option>");
		}
		buff.append("</select>");
		buff.append("</td>");
		buff.append("</tr>");

		buff.append("<tr>");
		buff.append("<td></td>");
		buff.append("<td><input name='addCategory' type='submit' value='" + language.getString("save") + "'></td>");
		buff.append("</tr>");

		buff.append("</table>");

		buff.append(
				"<p><font color='#FF0000' size='+3'>&#8226;</font>" + language.getString("mandatory.fields") + "</p>");
		buff.append("</form></body></html>");
		ServletUtil.writeResponse(response, buff);
	}

	public void inputForModifyModel(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final int modelID = Integer.parseInt(ServletUtil.getRequestAttribute(request, "modelID"));
		final Model model = servletDAO.getModel(modelID);
		User user = getUser(request);
		if (user.isAdminUser() || user.getId() == model.getUserID()) {
			getModelForm(request, response, Command.modifyModel.name(), "modify", model);
		}else {
			redirectToMainPage(request, response);
		}
	}

	public void inputForAddModel(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
	    
		if (isRegistrationAllowed(getShowFromSession(request))) {
			getModelForm(request, response, Command.addModel.name(), "save.and.add.new.model", null);
		} else {
			redirectToMainPage(request, response);
		}
	}

	public void modifyModel(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final HttpSession session = request.getSession(false);

		if (session == null)
			return;

		final int modelID = Integer.valueOf(ServletUtil.getRequestAttribute(request, "modelID"));

		final Model model = servletDAO.getModel(modelID);
		createModel(model, request);
		User user = getUser(request);
        if(user.isAdminUser() || (!user.isAdminUser() && user.getId() == model.getUserID())) {   
			servletDAO.save(model);

			session.removeAttribute(RegistrationServlet.SessionAttribute.Notices.name());
			setNoticeInSession(session, getLanguageForCurrentUser(request).getString("modify.model"));
		}
		session.removeAttribute(SessionAttribute.ModelID.name());
		redirectToMainPage(request, response);
	}

	public ResourceBundle getLanguageForCurrentUser(final HttpServletRequest request) throws UserNotLoggedInException {
		return languageUtil.getLanguage(getUser(request).language);
	}

	public void addModel(final HttpServletRequest request, final HttpServletResponse response)
			throws SQLException, IOException, MessagingException, MissingServletConfigException,
			UserNotLoggedInException, NumberFormatException, MissingRequestParameterException {
		final User user = getUser(request);

		final Model model = new Model(servletDAO.getNextID(Model.class));
		model.setUser(user);
		createModel(model, request);
		
		
		final int maxModelsPerCategory = getMaxModelsPerCategory(request);
		if(servletDAO.getModelsInCategory(model.getUserID(), model.getCategoryID()) == maxModelsPerCategory) {
			writeErrorResponse(response, "Maximum " + languageUtil.getLanguage(user.language).getString("models.number.per.category") + ": " + maxModelsPerCategory + "!");
			return;
		}

		servletDAO.save(model);

		if (ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestAttribute(request, "finishRegistration"))) {
			final HttpSession session = request.getSession(false);
			String notice = ServletUtil.encodeString(model.name) + " - " + model.scale + " - "
					+ servletDAO.getCategory(model.categoryID).categoryCode;
			setNoticeInSession(session, notice);
			response.sendRedirect("jsp/modelForm.jsp");
		} else {
			sendEmailWithModels(user, false /* insertUserDetails */);
			setEmailSentNoticeInSession(request, user);
			redirectToMainPage(request, response);
		}
	}

	private int getMaxModelsPerCategory(final HttpServletRequest request) {
		try {
			return Integer.parseInt(getSystemParameter(request, ServletDAO.SYSTEMPARAMETER.MaxModelsPerCategory));
		} catch (Exception e) {
			return 3;
		}
	}
	
	private static String getSystemParameter(String show, SYSTEMPARAMETER parameter)
	{
		if(show == null) {
			return ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
		}
		
		String value = systemParameters.get(show).get(parameter);
		return value == null ? servletDAO.getSystemParameter(parameter)  : value;
	}
	
	private static String getSystemParameter(HttpServletRequest request, SYSTEMPARAMETER parameter)
	{
		return getSystemParameter(getShowFromSession(request), parameter);
	}
	
	private void setEmailSentNoticeInSession(final HttpServletRequest request, final User user)
			throws UserNotLoggedInException {
		ResourceBundle language = getLanguageForCurrentUser(request);
                setNoticeInSession(request.getSession(false), language.getString("email") + ": <h2>" + user.email + "</h2>");
		setNoticeInSession(request.getSession(false), new MainPageNotice(MainPageNotice.NoticeType.Warning, language.getString("email.warning")));
	}

        private void setNoticeInSession(final HttpSession session, MainPageNotice notice) {
            List<MainPageNotice> notices = (List<MainPageNotice>) session.getAttribute(SessionAttribute.Notices.name());
            if(notices == null)
                notices = new LinkedList<MainPageNotice>();
            
            notices.add(notice);
            
            session.setAttribute(SessionAttribute.Notices.name(), notices);
        }

            private void setNoticeInSession(final HttpSession session, String noticeText) {
                setNoticeInSession(session, new MainPageNotice(MainPageNotice.NoticeType.OK, noticeText));
	}

	private Model createModel(final Model model, final HttpServletRequest request)
			throws NumberFormatException, MissingRequestParameterException {
		return createModel(model, request, "");
	}

	private Model createModel(final Model model, final HttpServletRequest request, final String httpParameterPostTag)
			throws NumberFormatException, MissingRequestParameterException {
		model.setCategoryID(
				Integer.parseInt(ServletUtil.getRequestAttribute(request, "categoryID" + httpParameterPostTag)));
		model.setScale(ServletUtil.getRequestAttribute(request, "modelscale" + httpParameterPostTag));
		model.setName(ServletUtil.getRequestAttribute(request, "modelname" + httpParameterPostTag));
		model.setProducer(ServletUtil.getRequestAttribute(request, "modelproducer" + httpParameterPostTag));
		model.setComment(ServletUtil.getOptionalRequestAttribute(request, "modelcomment" + httpParameterPostTag));
		model.setIdentification(
				ServletUtil.getOptionalRequestAttribute(request, "identification" + httpParameterPostTag));
		model.setMarkings(ServletUtil.getOptionalRequestAttribute(request, "markings" + httpParameterPostTag));
		model.setGluedToBase(ServletUtil.isCheckedIn(request, "gluedToBase" + httpParameterPostTag));
		model.setDetailing(getDetailing(request));

		return setDimensions(model, request, httpParameterPostTag);
	}
	
	Model setDimensions(final Model model, final HttpServletRequest request, final String httpParameterPostTag) {
		try {
			int modelWidth = Integer
					.parseInt(ServletUtil.getRequestAttribute(request, "modelWidth" + httpParameterPostTag));
			int modelHeight = Integer
					.parseInt(ServletUtil.getRequestAttribute(request, "modelHeight" + httpParameterPostTag));
			
			model.setDimensions(modelWidth, modelHeight);
			return model;
		} catch (Exception e) {
			// TODO: handle exception
		}

		return model;
	}

	private Collection<Detailing> getDetailing(final HttpServletRequest request) {
		final Collection<Detailing> detailing = new LinkedList<>();

		for (DetailingGroup group : DetailingGroup.values()) {
			for (DetailingCriteria criteria : DetailingCriteria.values()) {
				boolean checked = ServletUtil.isCheckedIn(request, "detailing." + group.name() + "." + criteria.name());
				if (checked) {
					Detailing newDetailing = new Detailing(servletDAO.getNextID(Detailing.class), group, criteria, checked);
					servletDAO.save(newDetailing);
					detailing.add(newDetailing);
				}
			}
		}

		return detailing;
	}

	public static final User getUser(final HttpServletRequest request) throws UserNotLoggedInException {
		final HttpSession session = request.getSession(false);

		if (session == null) {
			throw new UserNotLoggedInException(
					"User is not logged in! <a href='" + getStartPage(request) + "'>Please go to login page...</a>");
		}

		User userInSession = (User) session.getAttribute(CommonSessionAttribute.UserID.name());
		if(userInSession == null)
		    throw new UserNotLoggedInException(
		            "User is not logged in! <a href='" + getStartPage(request) + "'>Please go to login page...</a>");
		
            return userInSession;
	}

    public boolean isRegistrationAllowed(String show) {
        return isPreRegistrationAllowed(show) || isOnSiteUse();
    }

	public void inputForPhotoUpload(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final StringBuilder buff = new StringBuilder();
		final User user = getUser(request);
		final ResourceBundle language = languageUtil.getLanguage(user.language);

		final List<Model> models = servletDAO.getModels(user.getId());

		if (models.isEmpty()) {
			redirectToMainPage(request, response);
			return;
		}

		buff.append(
				"<form accept-charset='UTF-8' name='input' action='RegistrationServlet' method='post'  enctype='multipart/form-data'>");
		for (final Model model : models) {
			buff.append("<input type='radio' name='modelID' value='" + model.getId() + "'/>");
			buff.append(model.scale + " - " + model.producer + " - " + model.name + "<br>");
		}
		buff.append("<p><input type='file' name='imageFile' />");

		buff.append("<p><input type='submit' value='" + language.getString("save") + "'>");
		buff.append("</form>");

		ServletUtil.writeResponse(response, buff);
	}

	public void inputForLogoUpload(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final StringBuilder buff = new StringBuilder();
		final User user = getUser(request);
		final ResourceBundle language = languageUtil.getLanguage(user.language);

		buff.append(
				"<form accept-charset='UTF-8' name='input' action='RegistrationServlet' method='post'  enctype='multipart/form-data'>");
		buff.append("<input type='hidden' name='modelID' value='-1'/>");
		buff.append("<p><input type='file' name='imageFile' />");

		buff.append("<p><input type='submit' value='" + language.getString("save") + "'>");
		buff.append("</form>");

		ServletUtil.writeResponse(response, buff);
	}

	private StringBuilder inputForSelectModel(final User user, final String action, final String submitLabel,
			final List<Model> models) throws Exception {
		final StringBuilder buff = new StringBuilder();

		if (models.isEmpty()) {
			return buff;
		}

		buff.append("<link rel='stylesheet' href='jsp/base.css' media='screen' />");
		buff.append("<form accept-charset='UTF-8' name='input' action='RegistrationServlet' method='put' target='_top'>");
		buff.append("<input type='hidden' name='command' value='");
		buff.append(action);
		buff.append("'>");
		buff.append("<input name='");
		buff.append(action);
		final ResourceBundle language = languageUtil.getLanguage(user.language);
		buff.append("' type='submit' value='" + language.getString(submitLabel) + "'>");
		buff.append("<p>");

		for (final Model model : models) {
			buff.append("<label>\n");
			buff.append("<input type='radio' name='modelID' value='" + model.getId() + "' "
					+ (models.size() == 1 ? "checked" : "") + "/>\n");
			buff.append(model.scale + " - " + model.producer + " - " + model.name + "<br>");
			buff.append("</label>\n");
		}

		buff.append("</form>");

		return buff;
	}

	public void inputForDeleteUsers(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final String language = getUser(request).language;

		selectUser(request, response, "deleteUsers", languageUtil.getLanguage(language).getString("delete"), language);
	}

	public void inputForLoginUser(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final String language = ServletUtil.getRequestAttribute(request, "language");
		request.getSession(true).setAttribute(SessionAttribute.Show.name(), servletDAO.getShows().get(0));
		
		
		selectUser(request, response, "directLogin", languageUtil.getLanguage(language).getString("login"), language);
	}

	public void inputForPrint(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final String language = ServletUtil.getRequestAttribute(request, "language");
		selectUser(request, response, "directPrintModels", languageUtil.getLanguage(language).getString("print.models"), language);
	}

	private void selectUser(final HttpServletRequest request, final HttpServletResponse response, final String command,
			final String submitLabel, final String language) throws Exception, IOException {
		final StringBuilder buff = new StringBuilder();

		final String show = getShowFromSession(request);

		buff.append("<html>" + "<head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' /></head>"
				+ "<body>");

		buff.append("<form accept-charset='UTF-8' name='input' action='RegistrationServlet' method='put' >");
		buff.append("<input type='hidden' name='command' value='" + command + "'>");
		if (show != null) {
			buff.append("<input type='hidden' name='show' value='" + StringEncoder.toBase64(show.getBytes()) + "'>");
		}
		buff.append("<input type='hidden' name='language' value='" + language + "'>");

		final List<User> users = servletDAO.getUsers();
		buff.append("<input type='hidden' name='rows' value='" + users.size() + "'>");

		// buff.append("<input name='deleteUsers' type='submit' value='"
		// + submitLabel + "'><p>");
		for (int i = 0; i < users.size(); i++) {
			final User user = users.get(i);
			
			if(!getUser(request).isSuperAdminUser() && user.isAdminUser()) {
				continue;
			}

			buff.append("<label><input type='radio' name='userID' value='" + user.getId()
					+ "' onClick='document.input.submit()'/>");
			buff.append(user.lastName
					// + " " + user.firstName
					+ " (" + user.getId() + " - " + user.email + " - " + user.yearOfBirth + " - " + user.country + " - "
					+ user.city + " - " + user.address + " - " + user.telephone + ")</label><br>");
		}

		// buff.append("<p><input name='deleteUsers' type='submit' value='"
		// + submitLabel + "'>");
		buff.append("</form></body></html>");

		ServletUtil.writeResponse(response, buff);
	}

	public void deleteUsers(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final int userID = Integer.parseInt(ServletUtil.getRequestAttribute(request, "userID"));
				servletDAO.deleteUser(userID);
		redirectToMainPage(request, response);
	}

	public void deletedirectUsers(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		for (final User user : servletDAO.getUsers()) {
			if (user.isLocalUser()) {
				servletDAO.deleteUser(user.getId());
			}
		}

		redirectToMainPage(request, response);

	}

	public void setSystemParameter(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {

		String paramName = ServletUtil.getRequestAttribute(request, "paramName");
		String paramValue = ServletUtil.encodeString(ServletUtil.getRequestAttribute(request, "paramValue"));
		
		servletDAO.setSystemParameter(paramName, paramValue);
		
		String show = getShowFromSession(request);
		if (show != null) {
			systemParameters.get(show).put(ServletDAO.SYSTEMPARAMETER.valueOf(paramName), paramValue);
			updateSystemSettings(show);
		}

		redirectToMainPage(request, response);
	}

	private void deleteModel(final HttpServletRequest request)
			throws MissingRequestParameterException, NumberFormatException, SQLException, UserNotLoggedInException {
		Integer modelID = Integer.valueOf(ServletUtil.getRequestAttribute(request, "modelID"));
		final Model model = servletDAO.getModel(modelID);

		User user = getUser(request);
		if(user.isAdminUser() || (!user.isAdminUser() && user.getId() == model.getUserID())) {
			servletDAO.deleteModel(model);
			setNoticeInSession(request.getSession(false), getLanguageForCurrentUser(request).getString("delete"));
		}
	}

	public void deleteModel(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		deleteModel(request);
		redirectToMainPage(request, response);
	}

	public void deleteAwardedModel(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		servletDAO.deleteAwardedModel(Integer.valueOf(ServletUtil.getRequestAttribute(request, "modelID")));

		redirectToMainPage(request, response);
	}

	public void inputForDeleteCategory(final HttpServletRequest request, final HttpServletResponse response)
	        throws Exception {
	    final ResourceBundle language = getLanguageForCurrentUser(request);
	    inputForModifyCategory(request, response,"deleteCategory",language.getString("delete"));
	}
	
	public void inputForModifyCategory(final HttpServletRequest request, final HttpServletResponse response)
	        throws Exception {
	    final ResourceBundle language = getLanguageForCurrentUser(request);
	    inputForModifyCategory(request, response,"inputForAddCategory",language.getString("modify"));
	}
	
	private void inputForModifyCategory(final HttpServletRequest request, final HttpServletResponse response, String command, String commandLabel)
			throws Exception {
		final StringBuilder buff = new StringBuilder();
		final ResourceBundle language = getLanguageForCurrentUser(request);

		buff.append("<html><body>");

		buff.append("<form accept-charset='UTF-8' name='input' action='./RegistrationServlet' method='put'>");
		buff.append("<input type='hidden' name='command' value='"+command+"'>");

		getHTMLCodeForCategorySelect(buff, language.getString("select"), "", false, language, request);

		buff.append("<p><input name='"+command+"' type='submit' value='" + commandLabel + "'>");
		buff.append("</form></body></html>");

		ServletUtil.writeResponse(response, buff);
	}

	public void inputForDeleteCategoryGroup(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final StringBuilder buff = new StringBuilder();
		final ResourceBundle language = getLanguageForCurrentUser(request);

		buff.append("<html><body>");

		buff.append("<form name='input' action='RegistrationServlet' method='put'>");
		buff.append("<input type='hidden' name='command' value='deleteCategoryGroup'>");

		final String show = getShowFromSession(request);

		for (final CategoryGroup group : servletDAO.getCategoryGroups()) {
			if (!group.show.equals(show)) {
				continue;
			}

			buff.append("<label><input type='radio' name='categoryGroupID' value='" + group.getId() + "'/>");
			buff.append(group.show + " - " + group.name + "</label><br>");
		}

		buff.append("<p><input name='deleteCategoryGroup' type='submit' value='" + language.getString("delete") + "'>");
		buff.append("</form></body></html>");

		ServletUtil.writeResponse(response, buff);
	}

	public void deleteCategoryGroup(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		if(getUser(request).isAdminUser() && !isRegistrationAllowed(getShowFromSession(request))) {
			Integer categoryGroupID = Integer.valueOf(ServletUtil.getRequestAttribute(request, "categoryGroupID"));
			
			for (final Category category : servletDAO.getCategoryList(categoryGroupID, null /* show */)) {
				servletDAO.deleteModels(category.getId());
				servletDAO.delete(category);
			}
			servletDAO.delete(servletDAO.get(categoryGroupID, CategoryGroup.class));
		}
		else {
			writeCategoryModificationErrorResponse(response);
			return;
		}

		redirectToMainPage(request, response);
	}

	public void deleteCategory(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		if (getUser(request).isAdminUser() && !isRegistrationAllowed(getShowFromSession(request))) {
			Integer categoryID = Integer.valueOf(ServletUtil.getRequestAttribute(request, "categoryID"));
			servletDAO.deleteModels(categoryID);
			servletDAO.delete(servletDAO.getCategory(categoryID));
		}
		else {
			writeCategoryModificationErrorResponse(response);
			return;
		}

		redirectToMainPage(request, response);
	}

	public void printAllModels(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final ResourceBundle language = getLanguageForCurrentUser(request);

		List<User> users = servletDAO.getUsers();

		Collections.sort(users, new Comparator() {
			@Override
			public int compare(Object o1, Object o2) {
				return Integer.compare(User.class.cast(o1).getId(), User.class.cast(o2).getId());
			}
		});

		for (final User user : users) {
			printModelsForUser(request, response, language, user.getId(), true /* alwaysPageBreak */);
		}
		response.getOutputStream().write("<p>Itt a vege...".getBytes());
		showPrintDialog(response);
	}

	public void printCardsForAllModels(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final User user = getUser(request);
		final ResourceBundle language = languageUtil.getLanguage(user.language);

		final int cols = 2;
		final int rows = 4;

		final List<Model> allModels = new LinkedList<Model>();
		final List<Category> categories = servletDAO.getCategoryList(getShowFromSession(request));
		for (final Category category : categories) {
			final List<Model> models = servletDAO.getModelsInCategory(category.getId());
			for (final Model model : models) {
				model.identification = category.group.show;
			}

			allModels.addAll(models);
		}

		do {
			final List<Model> sublist = allModels.subList(0, Math.min(cols * rows, allModels.size()));

			int fee = calculateEntryFee(allModels);
			ServletUtil.writeResponse(response, printModels(language, user, sublist, printCardBuffer, rows, cols, true, fee, request ));
			sublist.clear();
		} while (!allModels.isEmpty());

		showPrintDialog(response);
	}

	private int calculateEntryFee(List<Model> allModels) {
		int size = allModels.size();
//		return 5 + (Math.max(0, size - 3) > 0 ? 2 * (size - 3) : 0);
		return 8;
	}

	public void printMyModels(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final User user = getUser(request);

		final String modelID = ServletUtil.getOptionalRequestAttribute(request, "modelID");

		if (ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(modelID)) {
			printModelsForUser(request, response, languageUtil.getLanguage(user.language), user.getId(),
					false /* alwaysPageBreak */);
		} else {
			final StringBuilder buff = new StringBuilder();

			final List<Model> models = servletDAO.getModels(user.getId());
			int fee = calculateEntryFee(models);
			for (final Model model : models) {
				if (model.getId() == Integer.parseInt(modelID)) {
					final List<Model> subList = new LinkedList<Model>();
					subList.add(model);

					buff.append(printModels(languageUtil.getLanguage(user.language), servletDAO.getUser(user.getId()), subList,
							printBuffer, 1, 3, false, fee, request));
					break;
				}
			}

			ServletUtil.writeResponse(response, buff);
		}

		showPrintDialog(response);
	}

	private void printModelsForUser(final HttpServletRequest request, final HttpServletResponse response,
			final ResourceBundle language, final int userID, boolean alwaysPageBreak) throws Exception, IOException {
		ServletUtil.writeResponse(response, printModelsForUser(language, userID, request, alwaysPageBreak));
	}

	private StringBuilder printModelsForUser(final ResourceBundle language, final int userID,
			final HttpServletRequest request, boolean alwaysPageBreak) throws Exception, IOException {
		return printModelsForUser(language, userID,
				request, alwaysPageBreak, 3 /*modelsOnPage*/);

	}
	private StringBuilder printModelsForUser(final ResourceBundle language, final int userID,
			final HttpServletRequest request, boolean alwaysPageBreak, int modelsOnPage) throws Exception, IOException {
		final List<Model> models = servletDAO.getModels(userID);

		// remove models that are not for the current show
		final String show = getShowFromSession(request);
		final Iterator<Model> it = models.iterator();
		while (it.hasNext()) {
			final Model model = it.next();

			if (show != null && !servletDAO.getCategory(model.categoryID).group.show.equals(show)) {
				it.remove();
			}
		}

		if (models.isEmpty()) {
			return new StringBuilder();
		}

		final StringBuilder buff = new StringBuilder();

		final User user = servletDAO.getUser(userID);
		int modelsRemainingToPrint = models.size();
		int fee = calculateEntryFee(models);
		while (!models.isEmpty()) {
			int currentModelsOnPage = Math.min(modelsOnPage, models.size());
			final List<Model> subList = new ArrayList<Model>(models.subList(0, currentModelsOnPage));
			models.removeAll(subList);

			modelsRemainingToPrint -= currentModelsOnPage;
			boolean pageBreak = alwaysPageBreak || modelsRemainingToPrint > 0;
			buff.append(printModels(language, user, subList, printBuffer, 1, modelsOnPage, pageBreak, fee, request));
		}

		return buff;

	}

	StringBuilder printModels(final ResourceBundle language, final User user, final List<Model> models,
			final StringBuilder printBuffer, final int rows, final int cols, boolean pageBreak, final int fee, HttpServletRequest request)
			throws Exception, IOException {

		final int width = 100 / cols;
		final int height = 100 / rows;

		final StringBuilder buff = new StringBuilder();
		buff.append("\n\n<table cellpadding='0' cellspacing='10' width='100%' height='100%' "
				+ (pageBreak ? "style='page-break-after: always;' " : "") + "border='0' >");

		int ModelCount = 0;
		for (int row = 0; row < rows; row++) {
			buff.append("<tr valign='bottom'>");
			for (int col = 0; col < cols; col++) {
				buff.append("<td width='" + width + "%' height='" + height + "%'>");

				final Model model = ModelCount < models.size() ? models.get(ModelCount) : null;
				ModelCount++;

				if (model != null) {
					String print = printBuffer.toString().replaceAll("__LASTNAME__", String.valueOf(user.lastName))
							// .replaceAll("__FIRSTNAME__",
							// String.valueOf(user.firstName))
							.replaceAll("__YEAROFBIRTH__", String.valueOf(user.yearOfBirth))

							.replaceAll("__CITY__", String.valueOf(user.city))
							.replaceAll("__COUNTRY__", String.valueOf(user.country))

							.replaceAll("__USER_ID__", String.valueOf(model.getUserID()))
							.replaceAll("__MODEL_ID__", String.valueOf(model.getId()))
							.replaceAll("__YEAR_OF_BIRTH__",
									String.valueOf(servletDAO.getUser(model.getUserID()).yearOfBirth))
							.replaceAll("__MODEL_SCALE__", model.scale)
							.replaceAll("__CATEGORY_CODE__", servletDAO.getCategory(model.categoryID).categoryCode)
							.replaceAll("__MODEL_NAME__", model.name)
							.replaceAll("__MODEL_NATIONALITY__", model.markings)
							.replaceAll("__MODEL_IDENTIFICATION__", model.identification)
							.replaceAll("__MODEL_PRODUCER__", model.producer)
							.replaceAll("__MODEL_COMMENT__", model.comment)
							.replaceAll("__GLUED_TO_BASE__", getGluedToBaseHTMLCode(language, model, "."))
							.replaceAll("__FEE__", String.valueOf(fee))
							.replaceAll("__LOGO_URL__", getServletURL(request)+"/"+Command.LOADIMAGE.name()+"/-1")

					// "<font color='#006600'>Alapra ragasztva</font>"
					// :
					// "<font color='#FF0000'><strong>Nincs leragasztva!!!
					// </strong></font> "

					;

					for (DetailingGroup group : DetailingGroup.values()) {
						for (DetailingCriteria criteria : DetailingCriteria.values()) {
							print = print.replaceAll(
									"__" + group.getTemplateID() + "_" + criteria.getTemplateID() + "__",
									model.isDetailed(group, criteria) ? "X"

											: "&nbsp");
						}
					}

					buff.append(print);
				}

				buff.append("</td>");
			}
			buff.append("</tr>");
		}

		buff.append("</table>");

		return buff;
	}

    public static String getGluedToBaseHTMLCode(final ResourceBundle language, final Model model, String imageBaseDir) {
        
        String borderColor = model.gluedToBase ? "lightgreen" : "red";
        String imageFileName = model.gluedToBase ? "glued.jpg" : "notglued.jpg";
        String gluedToBaseText = model.gluedToBase ? 
                language.getString("yes") + "<br><em>yes</em>"
                : language.getString("no") + "<br><em>no</em>";
        
        return 
                "<div style='border: 3px solid " + borderColor + "; padding: 2px'>" +
                "<img src='"+imageBaseDir+"/icons/" + imageFileName + "' style='float: right; vertical-align: middle; padding-left: 3px;'  height='25px'>" + 
                "<font style='font-family: Calibri, Optima, Arial, sans-serif;font-size: 3mm'>" + gluedToBaseText + "</font>" +
                "</div>";
    }

	public void inputForModifyUser(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final HttpSession session = request.getSession(true);

		session.setAttribute(SessionAttribute.DirectRegister.name(), false);
		session.setAttribute(SessionAttribute.Action.name(), "modifyUser");

		response.sendRedirect("jsp/user.jsp");
	}

	public String getServletURL(final HttpServletRequest request) {
		final StringBuffer requestURL = request.getRequestURL();

		if (requestURL.indexOf(".jsp") > -1) {
			return requestURL.substring(0, requestURL.indexOf("jsp/")) + getClass().getSimpleName();
		}

		return requestURL.toString();
	}

	public void sendEmail(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final User user = getUser(request);

		sendEmailWithModels(user, false);
		setEmailSentNoticeInSession(request, user);

		redirectToMainPage(request, response);
	}

	public void logout(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		final User user = getUser(request);

		// if (!onSiteUse)
		// {
		// sendEmail(user, false);
		// }

		final HttpSession session = request.getSession(false);
		String startPage = getStartPage(request);
		
		if (session != null) {
			session.invalidate();
		}

		if (isOnSiteUse()) {
			response.sendRedirect("helyi.html");
		} else {
		        response.sendRedirect(startPage);
		}
	}

	private static String getStartPage(HttpServletRequest request) {
		final HttpSession session = request.getSession(false);
		String showId = null;
		if (session != null)
			showId = (String) session.getAttribute(SessionAttribute.ShowId.name());
		if (showId == null)
			showId = ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;

		return (request.getRequestURI().contains("jsp") ? "" : "jsp/") + "index.jsp"
				+ (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(showId) ? "?showId=" + showId : "");
	}

    private void updateSystemSettings(String show) throws SQLException {
		onSiteUse = Boolean.parseBoolean(getSystemParameter(show, ServletDAO.SYSTEMPARAMETER.ONSITEUSE));
		systemMessage = getSystemParameter(show, ServletDAO.SYSTEMPARAMETER.SYSTEMMESSAGE);
	}

	public void deleteData(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		servletDAO.deleteAll(CategoryGroup.class);
		servletDAO.deleteAll(Category.class);
		servletDAO.deleteAll(Model.class);
//		servletDAO.deleteAll(User.class);

		servletDAO.deleteEntries("MAK_AWARDEDMODELS");

		redirectToMainPage(request, response);

	}

	public void initDB(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		new InitDB();

		ServletUtil.writeResponse(response, new StringBuilder("initDB done..."));
	}

	public void statistics(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

		final StringBuilder buff = new StringBuilder();

		ResourceBundle language = languageUtil.getLanguage(ServletUtil.getOptionalRequestAttribute(request, "language"));
		String show = getShowFromSession(request);
		if (show == null) {
		    List<String> shows = servletDAO.getShows();
		    String showId = ServletUtil.getOptionalRequestAttribute(request, "showId");
		    if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(showId)) {
                        shows.retainAll(Arrays.asList(shows.get(Integer.parseInt(showId)-1)));
		    }
		    
                    for(String currentShow : shows)
		    {
		        statistics(buff, currentShow,language);
		        buff.append("<p>");
		    }
		}
		else
		    statistics(buff, show,language);
		

		ServletUtil.writeResponse(response, buff);
	}

	private void statistics(final StringBuilder buff, String show, ResourceBundle language) throws SQLException {
		buff.append("<table style='border-collapse: collapse' border='1'>");

		boolean highlight = false;

		for (final String[] stat : servletDAO.getStatistics(show,language)) {
			if (highlight)
				buff.append("  <tr bgcolor='eaeaea' >\n");
			else
				buff.append("  <tr>\n");
			highlight = !highlight;

			buff.append("<td>");
			buff.append(stat[0]);
			buff.append("</td><td align='center'>");
			buff.append(stat[1]);
			buff.append("</td></tr>");
		}

		buff.append("</table>");
	}

	public void exceptionHistory(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final StringBuilder buff = new StringBuilder();

		for (final ExceptionData data : exceptionHistory) {
			buff.append(data.toHTML());
		}

		ServletUtil.writeResponse(response, buff);
	}

	public void getawardedModelsPage(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final StringBuilder buff = new StringBuilder();
		final String languageCode = getUser(request).language;
		final ResourceBundle language = languageUtil.getLanguage(languageCode);

		buff.append(awardedModelsBuffer.toString().replaceAll("__ADDNEWROW__", language.getString("add.new.row"))
				.replaceAll("__SELECT__", language.getString("list.models"))
				.replaceAll("__PRINT__", language.getString("print.models"))
				.replaceAll("__PRESENTATION__", language.getString("presentation"))
				.replaceAll("__SAVE__", language.getString("save"))

				.replaceAll("__MODELID__", language.getString("modelID"))
				.replaceAll("__AWARD__", language.getString("award")).replaceAll("__LANGUAGE__", languageCode));
		ServletUtil.writeResponse(response, buff);
	}

	public void printAwardedModels(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		printAwardedModels(request, response, cerificateOfMeritBuffer);
	}

	public void getPresentationPage(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		printAwardedModels(request, response, presentationBuffer);
	}

	public void addAwardedModels(final HttpServletRequest request, final HttpServletResponse response)
			throws MissingRequestParameterException, NumberFormatException, SQLException, IOException {
		final int rows = Integer.parseInt(ServletUtil.getRequestAttribute(request, "rows"));

		for (int i = 1; i <= rows; i++) {
			final String httpParameterPostTag = String.valueOf(i);

			final String modelID = ServletUtil.getOptionalRequestAttribute(request, "modelID" + httpParameterPostTag);
			if (ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(modelID)) {
				continue;
			}

			final Model model = servletDAO.getModel(Integer.parseInt(modelID));
			final User user = servletDAO.getUser(model.getUserID());
			// Category category = servletDAO.getCategory(model.categoryID);

			final String award = ServletUtil.getRequestAttribute(request, "award" + httpParameterPostTag).trim();

			servletDAO.saveAwardedModel(new AwardedModel(model, award));
		}

		redirectToMainPage(request, response);
	}

	private void printAwardedModels(final HttpServletRequest request, final HttpServletResponse response,
			final StringBuilder buffer) throws Exception, IOException {
		final String languageCode = ServletUtil.getRequestAttribute(request, "language");
		final ResourceBundle language = languageUtil.getLanguage(languageCode);

		final int rows = Integer.parseInt(ServletUtil.getRequestAttribute(request, "rows"));

		final StringBuilder buff = new StringBuilder();
		for (int i = 1; i <= rows; i++) {
			final String httpParameterPostTag = String.valueOf(i);

			final String modelID = ServletUtil.getOptionalRequestAttribute(request, "modelID" + httpParameterPostTag)
					.trim();
			if (modelID.length() == 0 || ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.endsWith(modelID)) {
				continue;
			}

			final Model model = servletDAO.getModel(Integer.parseInt(modelID));
			final User user = servletDAO.getUser(model.getUserID());
			final Category category = servletDAO.getCategory(model.categoryID);

			buff.append(buffer.toString().replaceAll("__LASTNAME__", String.valueOf(user.lastName))
					// .replaceAll("__FIRSTNAME__",
					// String.valueOf(user.firstName))
					.replaceAll("__CATEGORY_CODE__", String.valueOf(category.categoryCode))
					.replaceAll("__CATEGORY_CODE__", String.valueOf(category.categoryCode))
					.replaceAll("__MODEL_NAME__", String.valueOf(model.name))
					.replaceAll("__MODEL_ID__", String.valueOf(model.getId()))

					.replaceAll("__AWARD__",
							ServletUtil.getRequestAttribute(request, "award" + httpParameterPostTag).trim()));
		}

		ServletUtil.writeResponse(response, buff);
	}

	public void getbatchAddModelPage(final HttpServletRequest request, final HttpServletResponse response)
			throws Exception {
		final StringBuilder buff = new StringBuilder();
		final String languageCode = ServletUtil.getRequestAttribute(request, "language");
		final ResourceBundle language = languageUtil.getLanguage(languageCode);

		final StringBuilder categoriesBuff = new StringBuilder();
		// getHTMLCodeForCategorySelect(categoriesBuff,
		// language.getString("select"), "", true, language, request);
		// final StringBuilder countryBuff = new StringBuilder();
		// getHTMLCodeForCountrySelect(countryBuff, language,
		// language.getString("select"), "HU", "country");

		buff.append(batchAddModelBuffer.toString().replaceAll("__ADDNEWROW__", language.getString("add.new.row"))
				.replaceAll("__ADD__", language.getString("add"))
				.replaceAll("__CATEGORIES_LIST__", categoriesBuff.toString())
				// .replaceAll("__YEAROFBIRTHS_LIST__",
				// yearBuffer.toString().replaceAll("__SELECTVALUE__",
				// "2009").replaceAll("__YEAROFBIRTH__", "2009"))

				// .replaceAll("__MODELSCALES_LIST__",
				// scalesBuffer.toString().replaceAll("__SELECTVALUE__",
				// "").replaceAll("__FREQUENTLYUSED__", ""))

				// .replaceAll("__MODELPRODUCERS_LIST__",
				// modelproducersBuffer.toString().replaceAll("__SELECTVALUE__",
				// "").replaceAll("__FREQUENTLYUSED__", ""))
				.replaceAll("__MANDATORYFIELDS__", language.getString("mandatory.fields"))

				// .replaceAll("__COUNTRIES_LIST__", countryBuff.toString())

				.replaceAll("__LASTNAMELABEL__", language.getString("name"))
				.replaceAll("__YEAROFBIRTHLABEL__", language.getString("year.of.birth"))
				.replaceAll("__MODEL_SCALE__", language.getString("scale"))
				.replaceAll("__MODEL_NAME__", language.getString("models.name"))
				.replaceAll("__MODEL_PRODUCER__", language.getString("models.producer"))
				.replaceAll("__CATEGORY_CODE__", language.getString("category"))
				.replaceAll("__LANGUAGE__", languageCode)
				.replaceAll("__GLUED_TO_BASE__", language.getString("glued.to.base"))
				.replaceAll("__YES__", language.getString("yes")).replaceAll("__NO__", language.getString("no"))
				.replaceAll("__COUNTRYLABEL__", language.getString("country"))
				.replaceAll("__EMAILLABEL__", language.getString("email"))
				.replaceAll("__LOGOUT__", language.getString("logout"))

		);
		ServletUtil.writeResponse(response, buff);
	}

	private User createUser(final HttpServletRequest request, final String email) throws Exception {
		return createUser(request, email, "");
	}

	private User createUser(final HttpServletRequest request, final String email, final String httpParameterPostTag)
			throws Exception {
		final String passwordInRequest = ServletUtil.encodeString(ServletUtil.getRequestAttribute(request, "password" + httpParameterPostTag));

		return createUser(request, email, StringEncoder.encode(passwordInRequest), httpParameterPostTag);
	}

	private User createUser(final HttpServletRequest request, final String email, final String password,
			final String httpParameterPostTag) throws Exception {
		// check if all data is sent
		ServletUtil.getRequestAttribute(request, "language");

		// ServletUtil.getRequestAttribute(request, "firstname" +
		// httpParameterPostTag);
		ServletUtil.getRequestAttribute(request, "fullname" + httpParameterPostTag);
		ServletUtil.getRequestAttribute(request, "country" + httpParameterPostTag);
		ServletUtil.getRequestAttribute(request, "city" + httpParameterPostTag);
		ServletUtil.getOptionalRequestAttribute(request, "address" + httpParameterPostTag);
		ServletUtil.getOptionalRequestAttribute(request, "telephone" + httpParameterPostTag);

		ServletUtil.getRequestAttribute(request, "yearofbirth" + httpParameterPostTag);

		return new User(servletDAO.getNextID(User.class),
				password,
				// ServletUtil.getRequestAttribute(request, "firstname" +
				// httpParameterPostTag),
				"-", ServletUtil.getRequestAttribute(request, "fullname" + httpParameterPostTag),
				ServletUtil.getRequestAttribute(request, "language"),
				ServletUtil.getOptionalRequestAttribute(request, "address" + httpParameterPostTag),
				ServletUtil.getOptionalRequestAttribute(request, "telephone" + httpParameterPostTag), email, true,
				ServletUtil.getRequestAttribute(request, "country" + httpParameterPostTag),
				Integer.parseInt(ServletUtil.getRequestAttribute(request, "yearofbirth" + httpParameterPostTag)),
				ServletUtil.getOptionalRequestAttribute(request, "city" + httpParameterPostTag));
	}

	class ExceptionData {
		long timestamp;
		Throwable throwable;
		HashMap<String, String> parameters;

		ExceptionData(final long timestamp, final Throwable throwable, final HttpServletRequest request) {
			this.timestamp = timestamp;
			this.throwable = throwable;
			parameters = new HashMap<String, String>();

			@SuppressWarnings("unchecked")
			final Enumeration<String> e = request.getParameterNames();
			while (e.hasMoreElements()) {
				final String param = e.nextElement();
				parameters.put(param, request.getParameter(param));
			}
		}

		String toHTML() {
			final StringBuilder buff = new StringBuilder();
			buff.append("<b>Timestamp:</b> " + new Date(timestamp));

			buff.append("<p>");
			buff.append("<b>Exception:</b> " + throwable.getClass().getName() + " " + throwable.getMessage());
			buff.append("<br>");
			for (final StackTraceElement stackTrace : throwable.getStackTrace()) {
				buff.append(stackTrace.toString());
				buff.append("<br>");
			}

			buff.append("<p>");
			buff.append("<b>HTTP request:</b> ");
			buff.append("<br>");

			for (final String param : parameters.keySet()) {
				buff.append("<b>parameter:</b> " + param + " <b>value:</b> " + parameters.get(param));
				buff.append("<br>");
			}
			buff.append("<hr>");
			buff.append("<p>");

			return buff.toString();
		}
	}

	void addExceptionToHistory(final long timestamp, final Throwable exception, final HttpServletRequest request) {
		if (exceptionHistory.size() == 10) {
			exceptionHistory.remove(0);
		}

		exceptionHistory.add(new ExceptionData(timestamp, exception, request));
	}

	public String getSystemMessage() {
		return systemMessage;
	}

	public boolean isOnSiteUse() {
		return onSiteUse;
	}

	public static ServletDAO getServletDAO() {
		return servletDAO;
	}

	private void getModelForm(final HttpServletRequest request, final HttpServletResponse response, final String action,
			final String submitLabel, final Model model) throws Exception {
		final HttpSession session = request.getSession(true);

		session.setAttribute(SessionAttribute.Action.name(), action);
		session.setAttribute(SessionAttribute.SubmitLabel.name(), submitLabel);
		if (model != null) {
			session.setAttribute(SessionAttribute.Model.name(), model);
		}

		response.sendRedirect("jsp/modelForm.jsp");
	}

	private void getHTMLCodeForCategorySelect(final StringBuilder buff, final String selectedLabel,
			final String selectedValue, final boolean mandatory, final ResourceBundle language,
			final HttpServletRequest request) throws Exception {
		final String show = getShowFromSession(request);

		buff.append("<div id='categories'>");
		buff.append("<select name='categoryID'>");

		buff.append("<option value='" + selectedValue + "'>" + selectedLabel + "</option>");

		for (final CategoryGroup group : servletDAO.getCategoryGroups()) {
			if (show != null && !group.show.equals(show)) {
				continue;
			}

			buff.append("<optgroup label='" + group.show + " - " + group.name + "'>");

			for (final Category category : servletDAO.getCategoryList(show)) {
				if (category.group.getId() != group.getId()) {
					continue;
				}

				buff.append("<option value='" + category.getId() + "'>");
				buff.append(category.categoryCode + " - " + category.categoryDescription);
				buff.append("</option>");

			}

			buff.append("</optgroup>");
		}
		buff.append("</select>");

		if (mandatory) {
			buff.append("<font color='#FF0000' size='+3'>&#8226;</font> ");
		}
		buff.append("</div>");
	}

	public void getVersion(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		ServletUtil.writeResponse(response, new StringBuilder(getVersion()));
	}

	public String getVersion() {
		return VERSION;
	}

    public static boolean isPreRegistrationAllowed(String show) {
        if (ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(show))
            return true;
        Boolean allowed = Boolean.parseBoolean(getSystemParameter(show, ServletDAO.SYSTEMPARAMETER.REGISTRATION));
        return allowed == null ? false : allowed;
    }

	public void loadImage(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		response.setContentType("image/jpeg");

		try {
			loadImage(Integer.parseInt(ServletUtil.getRequestAttribute(request, "modelID")),
					response.getOutputStream());
		} catch (final Exception e) {
		}
	}

	private void loadImage(int modelID, OutputStream o) throws SQLException, IOException {
		final byte[] loadImage = servletDAO.loadImage(modelID);

		o.write(loadImage);
		o.flush();
		o.close();
	}

	public void sendEmails(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		if (!getUser(request).isAdminUser())
			return;

		String message = ServletUtil.getRequestAttribute(request, "message");
		int emailsSent = 0;
		for (User user : servletDAO.getUsers())
			if (!servletDAO.getModels(user.getId()).isEmpty())
				try {
					final StringBuilder messageBody = new StringBuilder();
					final ResourceBundle language = languageUtil.getLanguage(user.language);

					messageBody.append("<html><body>\n\r");

					messageBody.append(message);
					messageBody.append("\n\r<p>");
					messageBody.append("\n\r<hr>");

					List<EmailParameter> modelerParameters = Arrays.asList(//
							EmailParameter.create(language.getString("userID"), String.valueOf(user.getId())), //
							EmailParameter.create(language.getString("name"), user.lastName) //
					);

					addEmailParameters(messageBody, modelerParameters);

					messageBody.append("<p>\n\r");
					messageBody.append("\n\r</body></html>");

					sendEmail(user.email, language.getString("email.subject"), messageBody);
					Thread.sleep(TimeUnit.SECONDS.toMillis(30));
					emailsSent++;
				} catch (Exception e) {
					logger.debug("", e);
				}

		ServletUtil.writeResponse(response, new StringBuilder("emailsSent: " + emailsSent));
	}
}