package servlet;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.ResourceBundle;
import java.util.function.Function;
import java.util.stream.Collectors;

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
  public final static int INVALID_USERID = -1;

  public enum SystemParameter
  {
	REGISTRATION(true), ONSITEUSE(true), SYSTEMMESSAGE, MaxModelsPerCategory, // 
	PrintLanguage, MaxModelsPerPage, PageBreakAtPrint;

	private boolean booleanValue;
	
	SystemParameter()
	{
	}
	
	SystemParameter(boolean booleanValue)
	{
		this.booleanValue = booleanValue;
	}

	public boolean isBooleanValue() {
		return booleanValue;
	}
  };
 
  public ServletDAO(String dbURL, String dbUserName, String dbPassword,
          URL configFile) 
  {
      super(configFile);
	this.jdbcDAO = new JDBCDAO(dbURL, dbUserName, dbPassword, this);
  }

	boolean userExists(final String email) throws Exception {
		return !getList(User.class, "upper(email) = upper('" + email + "')").isEmpty();
	}

  public List<Category> getCategoryList(final String show)
  {
	return getCategoryList(0, show);
  }
  
  public List<Category> getCategoryList(final int categoryGroupId, final String show) 
  {
		if (categoryGroupId != 0) {
			if (show == null) {
				return getList(Category.class, " r.group.id = " + categoryGroupId + " order by id");
			} else {
				return getList(Category.class, " r.group.id = " + categoryGroupId + " and r.group.show = '" + show + "' order by id");
			}
		}

		if (show != null) {
			return getList(Category.class, " r.group.show = '" + show + "' order by id");
		} else {
			return getAll(Category.class);
		}
  }

  public CategoryGroup getCategoryGroup(final String name)
  {
	  return get(CategoryGroup.class, " r.name = '" + name + "'");
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

	public List<CategoryGroup> getCategoryGroups(final String show) {
		return getList(CategoryGroup.class, " r.show = '" + show + "' order by id");
	}

  public List<User> getUsers() throws SQLException
  {
	  return getList(User.class, "enabled=true order by lastName, firstName");
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
		email = ServletUtil.sanitizeUserInput(email);

		List<User> users = getList(User.class, "upper(email) = upper('" + email + "')");
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

  public boolean getYesNoSystemParameter(final SystemParameter parameter) 
  {
	final String value = jdbcDAO.getSystemParameter(parameter);
	return getYesNoSystemParameter(value);
  }

	public static boolean getYesNoSystemParameter(final String value) {
		if ("-".equals(value)) {
			return false;
		} else {
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

	List<Model> models = getModels(where);
    if(ServletUtil.isCheckedIn(request, "filterToOversized")) {
	  models = models.stream().filter(Model::isOversized).collect(Collectors.toList());
    }

	return models;
  }

	public int getModelsInCategory(final int userID, final int categoryID) {
		return getModels("userID = " + userID + " and categoryID = " + categoryID).size();
	}

  public List<Model> getModels(final int userID)
  {
	return userID == INVALID_USERID ? getAll(Model.class) : getModels("user.id = " + userID);
  }

  public List<Model> getModelsInCategory(final int categoryID)
  {
	return getModels("categoryID = " + categoryID);
  }

  public List<Model> getModels(final String where)
  {
	  return where.isEmpty() ?  getAll(Model.class) : getList(Model.class, where);
  }

  public Model getModel(final int modelID) 
  {
	return get(modelID, Model.class);
  }

  public Category getCategory(final int categoryID)
  {
	return get(Category.class, " r.id = " + categoryID);
  }

  public Category getCategory(final String categoryCode)
  {
	return get(Category.class, " r.categoryCode = '" + categoryCode + "'");
  }
  
  public void deleteEntries(final String table) throws SQLException
  {
	  jdbcDAO.deleteEntry(table, null, 0);
  }

	public void deleteEntries(final String table, final String whereClause) throws SQLException {
		jdbcDAO.deleteEntries(table, whereClause);
	}
	
	public void deleteEntry(final String table, final String idField, final int id) throws SQLException {
		jdbcDAO.deleteEntry(table, idField, id);
	}
	
public void deleteModel(final Model model) throws SQLException
  {
	delete(model);
	jdbcDAO.deleteEntry("MAK_PICTURES", "ID", model.getId());
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
	delete(Model.class, "user.id = " + userID);

	delete(User.class, "id = " + userID);
  }

  public void modifyUser(final User newUser, final User oldUser) throws SQLException
  {
	  delete(User.class, "id = " +newUser.getId());
	save(newUser);
  }

  public List<User> getSimilarLastNames(final String lastname) throws SQLException
  {
	  return getList(User.class, "lastName like '%" + lastname + "%'");
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

	public Map<Integer, List<AwardedModel>> getAwardedModelsMap() throws SQLException {
		return getAwardedModels().stream().collect(Collectors.groupingBy(AwardedModel::getCategoryID));
	}

	public String getAward(Model model) throws SQLException {
		return jdbcDAO.getAward(model);
	}
	
	public void setSystemParameter(final String parameterName, final String parameterValue) throws SQLException {
		jdbcDAO.setSystemParameter(parameterName, parameterValue);
	}

	public String getSystemParameter(final SystemParameter parameter) {
		return jdbcDAO.getSystemParameter(parameter);
	}

	public String getSystemParameterWithDefault(final SystemParameter parameter, String defaultValue) {
		String systemParameter = getSystemParameter(parameter);
		return ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(systemParameter) ? defaultValue : systemParameter;
	}

	public void saveAwardedModel(final AwardedModel model) throws SQLException {
		jdbcDAO.saveAwardedModel(model);
	}

	public byte[] loadImage(int modelID) throws SQLException {
		return jdbcDAO.loadImage(modelID);
	}

	public List<String[]> getStatistics(String show, ResourceBundle language, boolean detailedStatistics) throws SQLException {
		return jdbcDAO.getStatistics(show, language, detailedStatistics);
	}

	public List<User> getUsersWithModel() {
	      Session session = null;
	      
	      try
	      {
	          session = getHibernateSession();
	          
	          session.beginTransaction();

	          Query query = session.createQuery("select distinct u from Model m, User u where m.user.id = u.id order by u.id");
	          
	        return new LinkedList<User>(query.list());
	      }
	      finally
	      {
	          closeSession(session);
	      }
	}
	
	public List<Model> getModelsForShow(final String show, final int userID) {
		final List<Model> models = getModels(userID);
		final Iterator<Model> it = models.iterator();
		while (it.hasNext()) {
			final Model model = it.next();

			if (show != null && !getCategory(model.categoryID).group.show.equals(show)) {
				it.remove();
			}
		}

		return models;
	}
}