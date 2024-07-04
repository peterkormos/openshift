package servlet;

import java.io.IOError;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

import datatype.AwardedModel;
import datatype.Category;
import datatype.CategoryGroup;
import datatype.LoginConsent;
import datatype.Model;
import datatype.ModelClass;
import datatype.User;
import exception.EmailNotFoundException;

public class ServletDAO extends HibernateDAO
{
  public static Logger logger = Logger.getLogger(ServletDAO.class);

private JDBCDAO jdbcDAO;
  private static final Map<Integer, String> charEncodeMap;

  public final static int INVALID_USERID = -1;

  public enum SYSTEMPARAMETER
  {
	REGISTRATION, ONSITEUSE, SYSTEMMESSAGE
  };

 
  static {
		charEncodeMap = new HashMap<Integer, String>();
		charEncodeMap.put(192, "&Agrave;");
		charEncodeMap.put(193, "&Aacute;");
		charEncodeMap.put(194, "&Acirc;");
		charEncodeMap.put(195, "&Atilde;");
		charEncodeMap.put(196, "&Auml;");
		charEncodeMap.put(197, "&Aring;");
		charEncodeMap.put(198, "&AElig;");
		charEncodeMap.put(199, "&Ccedil;");
		charEncodeMap.put(200, "&Egrave;");
		charEncodeMap.put(201, "&Eacute;");
		charEncodeMap.put(202, "&Ecirc;");
		charEncodeMap.put(203, "&Euml;");
		charEncodeMap.put(204, "&Igrave;");
		charEncodeMap.put(205, "&Iacute;");
		charEncodeMap.put(206, "&Icirc;");
		charEncodeMap.put(207, "&Iuml;");
		charEncodeMap.put(208, "&ETH;");
		charEncodeMap.put(209, "&Ntilde;");
		charEncodeMap.put(210, "&Ograve;");
		charEncodeMap.put(211, "&Oacute;");
		charEncodeMap.put(212, "&#337;");
		charEncodeMap.put(213, "&#337;");
		charEncodeMap.put(214, "&Ouml;");
		charEncodeMap.put(215, "&times;");
		charEncodeMap.put(216, "&Oslash;");
		charEncodeMap.put(217, "&Ugrave;");
		charEncodeMap.put(218, "&Uacute;");
		charEncodeMap.put(219, "&Ucirc;");
		charEncodeMap.put(220, "&Uuml;");
		charEncodeMap.put(221, "&Yacute;");
		charEncodeMap.put(222, "&THORN;");
		charEncodeMap.put(223, "&szlig;");
		charEncodeMap.put(224, "&agrave;");
		charEncodeMap.put(225, "&aacute;");
		charEncodeMap.put(226, "&acirc;");
		charEncodeMap.put(227, "&atilde;");
		charEncodeMap.put(228, "&auml;");
		charEncodeMap.put(229, "&aring;");
		charEncodeMap.put(230, "&aelig;");
		charEncodeMap.put(231, "&ccedil;");
		charEncodeMap.put(232, "&egrave;");
		charEncodeMap.put(233, "&eacute;");
		charEncodeMap.put(234, "&ecirc;");
		charEncodeMap.put(235, "&euml;");
		charEncodeMap.put(236, "&igrave;");
		charEncodeMap.put(237, "&iacute;");
		charEncodeMap.put(238, "&icirc;");
		charEncodeMap.put(239, "&iuml;");
		charEncodeMap.put(240, "&eth;");
		charEncodeMap.put(241, "&ntilde;");
		charEncodeMap.put(242, "&ograve;");
		charEncodeMap.put(243, "&oacute;");
		charEncodeMap.put(244, "&#337;");
		charEncodeMap.put(245, "&#337;");
		charEncodeMap.put(246, "&ouml;");
		charEncodeMap.put(247, "&divide;");
		charEncodeMap.put(248, "&oslash;");
		charEncodeMap.put(249, "&ugrave;");
		charEncodeMap.put(250, "&uacute;");
		charEncodeMap.put(251, "&#369;");
		charEncodeMap.put(252, "&uuml;");
		charEncodeMap.put(253, "&yacute;");
		charEncodeMap.put(254, "&thorn;");
		charEncodeMap.put(255, "&yuml;");

  }

  public ServletDAO(String dbURL, String dbUserName, String dbPassword,
          URL configFile) 
  {
      super(configFile);
	this.jdbcDAO = new JDBCDAO(dbURL, dbUserName, dbPassword, this);
  }

  public static String encodeString(String value)
  {
	if (value == null)
	{
	  return "";
	}

	value = value.replaceAll("\"", "'");

	//	value = new String(value.getBytes("ISO-8859-1"), "UTF-8");
	final StringBuilder buff = new StringBuilder();

	char ch;
	for (int i = 0; i < value.length(); i++)
	{
	  ch = value.charAt(i);
	  if (!charEncodeMap.containsKey((int) ch))
	  {
		if (ch > 255)
		{
		  buff.append("&#" + (int) ch + ";");
		}
		else
		{
		  buff.append(ch);
		}

	  }
	  else
	  {
		buff.append(charEncodeMap.get((int) ch));
	  }
	}

	return buff.toString();
  }

	boolean userExists(final String email) throws Exception {
		return !get(User.class, "upper(email) = upper('" + email + "')").isEmpty();
	}

  public List<Category> getCategoryList(final String show) throws SQLException
  {
	return getCategoryList(0, show);
  }
  public List<Category> getCategoryList(final int categoryGroupId, final String show) throws SQLException
  {
		if (categoryGroupId != 0) {
			if (show == null) {
				return get(Category.class, " r.group.id = " + categoryGroupId + " order by id");
			} else {
				return get(Category.class, " r.group.id = " + categoryGroupId + " and r.group.show = '" + show + "' order by id");
			}
		}

		if (show != null) {
			return get(Category.class, " r.group.show = '" + show + "' order by id");
		} else {
			return getAll(Category.class);
		}
  }

  public CategoryGroup getCategoryGroup(final int categoryGroupID, final List<CategoryGroup> groups)
      throws SQLException
  {
	for (final CategoryGroup group : groups)
	{
	  if (group.getId() == categoryGroupID)
	  {
		return group;
	  }
	}

	throw new IllegalArgumentException("Unknown categoryGroupID: " + categoryGroupID);

  }

  public List<CategoryGroup> getCategoryGroups()
  {
	  return getAll(CategoryGroup.class);
  }
  public List<User> getUsers() throws SQLException
  {
	  return get(User.class, "enabled=true order by lastName, firstName");
  }

  public void saveModelClass(int userID, ModelClass modelClass) throws SQLException
  {
	  User user = get(userID, User.class);
	user.getModelClass().add(modelClass);

	String modelClasses = "";
	for (final ModelClass currentModelClass : user.getModelClass())
	{
	  modelClasses += currentModelClass.name() + ",";
	}
	user.setModelClasses(modelClasses);

	update(user);
  }

	public User getUser(String email) throws EmailNotFoundException {
		email = email.replace(';', ' ').replace('(', ' ').replace(')', ' ').replace('\'', ' ').replace(';', ' ');

		List<User> users = get(User.class, "upper(email) = upper('" + email + "')");
		if (users.isEmpty()) {
			throw new EmailNotFoundException(email);
		}
		return users.get(0);
	}

	public User getUser(final int userID) throws SQLException {
		User user = get(userID, User.class);
		if (Objects.isNull(user)) {
			throw new IllegalArgumentException("userID not found in DB. userID: " + userID);
		}
		return user;
	}

  public boolean getYesNoSystemParameter(final SYSTEMPARAMETER parameter) 
  {
	final String value = jdbcDAO.getSystemParameter(parameter);
	if ("-".equals(value))
	{
	  return false;
	}
	else
	{
	  return Integer.parseInt(value) == 1;
	}
  }
  String createWhereStatement(final HttpServletRequest request, String where, final String sQLfield, final String httpParameter,
      final boolean stringParameter)
  {

	try
	{
	  if (ServletUtil.getRequestAttribute(request, httpParameter).length() != 0)
	  {
		if (where.length() != 0)
		{
		  where += " AND ";
		}

		if (stringParameter)
		{
		  where += sQLfield + " like '%" + ServletUtil.getRequestAttribute(request, httpParameter) + "%'";
		}
		else
		{
		  where += sQLfield + " = " + ServletUtil.getRequestAttribute(request, httpParameter);
		}
	  }
	}
	catch (final Exception e)
	{
	}

	return where;
  }

  public List<Model> selectModels(final HttpServletRequest request) throws SQLException
  {
	String where = "";

	where = createWhereStatement(request, where, "categoryID", "categoryID", false);
	where = createWhereStatement(request, where, "userID", "userID", false);
	where = createWhereStatement(request, where, "ID", "modelID", false);
	where = createWhereStatement(request, where, "name", "modelname", true);
	where = createWhereStatement(request, where, "markings", "markings", true);
	where = createWhereStatement(request, where, "producer", "modelproducer", true);

	return getModels(where);
  }

	public int getModelsInCategory(final int userID, final int categoryID) {
		return getModels("userID = " + userID + " and categoryID = " + categoryID).size();
	}

  public List<Model> getModels(final int userID) throws SQLException
  {
	return userID == INVALID_USERID ? getAll(Model.class) : getModels("userID = " + userID);
  }

  public List<Model> getModelsInCategory(final int categoryID) throws SQLException
  {
	return getModels("categoryID = " + categoryID);
  }

  public List<Model> getModels(final String where)
  {
	  return get(Model.class, where);
  }

  public Model getModel(final int modelID) 
  {
	return get(modelID, Model.class);
  }

  public Category getCategory(final int categoryID) throws SQLException
  {
	for (final Category category : getCategoryList(null))
	{
	  if (category.getId() == categoryID)
	  {
		return category;
	  }
	}

	throw new IllegalArgumentException("Unknown categoryID: " + categoryID);
  }

  public Category getCategory(final String categoryCode) throws SQLException
  {
	for (final Category category : getCategoryList(null))
	{
	  if (category.categoryCode.equals(categoryCode))
	  {
		return category;
	  }
	}

	throw new IllegalArgumentException("Unknown categoryCode: " + categoryCode);
  }

  public void deleteEntries(final String table) throws SQLException
  {
	  jdbcDAO.deleteEntry(table, null, 0);
  }

public void deleteModel(final Model model) throws SQLException
  {
	delete(model);
	jdbcDAO.deleteEntry("MAK_PICTURES", "MODEL_ID", model.getId());
  }

  public void deleteAwardedModel(final int id) throws SQLException
  {
	  jdbcDAO.deleteEntry("MAK_AWARDEDMODELS", "ID", id);
  }


void deleteModels(final int categoryId) throws SQLException {
    for (final Model model : getModelsInCategory(categoryId))
	{
	  deleteModel(model);
	}
}

  public void deleteUser(final int userID) throws SQLException
  {
	delete(Model.class, "userID = " + userID);

	delete(User.class, "id = " + userID);
  }

  public void modifyUser(final User newUser, final User oldUser) throws SQLException
  {
	  delete(User.class, "id = " +newUser.getId());
	save(newUser);
  }

  public List<User> getSimilarLastNames(final String lastname) throws SQLException
  {
	  return get(User.class, "lastName like '%" + lastname + "%'");
  }
  public void deleteLoginConsentData(int modellerId)
  {
      Session session = null;
      
      try
      {
          session = getHibernateSession();
          
          session.beginTransaction();
          
          Query query = session.createQuery("delete LoginConsent where modellerID = :modellerId");
          query.setInteger("modellerId", modellerId);
          
          query.executeUpdate();
          session.getTransaction().commit();
      }
      finally
      {
          closeSession(session);
      }
  }

  public List<LoginConsent> getLoginConsents(int modellerId) throws Exception
  {
      Session session = null;
      
      try
      {
          session = getHibernateSession();
          
          session.beginTransaction();

          Query query = session.createQuery("From LoginConsent where modellerID = :modellerId");
          query.setInteger("modellerId", modellerId);
          
        return new LinkedList<LoginConsent>(query.list());
      }
      finally
      {
          closeSession(session);
      }
  }

	public List<String> getShows() throws SQLException {
		return jdbcDAO.getShows();
	}

	public StringBuilder execute(String sqlQuery) throws SQLException {
		return jdbcDAO.execute(sqlQuery);
	}

	public Map<Integer, byte[]> getPhotos() throws SQLException {
		return jdbcDAO.getPhotos();
	}

	public void saveImage(int modelID, InputStream stream) throws IOException, SQLException {
		jdbcDAO.saveImage(modelID, stream);
	}

	public List<AwardedModel> getAwardedModels() throws SQLException {
		return jdbcDAO.getAwardedModels();
	}

	public String getAward(Model model) throws SQLException {
		return jdbcDAO.getAward(model);
	}
	
	public void setSystemParameter(final String parameterName, final String parameterValue) throws SQLException {
		jdbcDAO.setSystemParameter(parameterName, parameterValue);
	}

	public String getSystemParameter(final SYSTEMPARAMETER parameter) {
		return jdbcDAO.getSystemParameter(parameter);
	}

	public void saveAwardedModel(final AwardedModel model) throws SQLException {
		jdbcDAO.saveAwardedModel(model);
	}

	public byte[] loadImage(int modelID) throws SQLException {
		return jdbcDAO.loadImage(modelID);
	}

	public List<String[]> getStatistics(String show, ResourceBundle language) throws SQLException {
		return jdbcDAO.getStatistics(show, language);
	}
}

