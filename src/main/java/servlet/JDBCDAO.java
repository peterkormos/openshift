package servlet;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.stream.Collectors;

import org.apache.log4j.Logger;

import datatype.AwardedModel;
import datatype.Category;
import datatype.Model;
import datatype.User;
import servlet.ServletDAO.SystemParameter;

public class JDBCDAO {
	public static Logger logger = Logger.getLogger(JDBCDAO.class);

	private final String dbURL;
	private final String dbUserName;
	private final String dbPassword;
	private Connection dBConnection;

	private ServletDAO servletDAO;

	public JDBCDAO(String dbURL, String dbUserName, String dbPassword, ServletDAO servletDAO)  {
		this.dbURL = dbURL;
		this.dbUserName = dbUserName;
		this.dbPassword = dbPassword;
		this.servletDAO = servletDAO;
	}

	private Connection getDBConnection() throws SQLException {
		if (this.dBConnection == null || this.dBConnection.isClosed() || !this.dBConnection.isValid(0)) {
			logger.debug("ServletDAO.getDBConnection(): Acquiring new DB connnection");
			this.dBConnection = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
			this.dBConnection.setAutoCommit(true);
		}

		return this.dBConnection;
	}

	public void closeResultSet(ResultSet rs) {
		try {
			if (rs != null) {
				rs.close();
			}
		} catch (final Exception ex) {
			logger.fatal("", ex);
		}
	}

	public static String decodeStringFromDB(final ResultSet rs, final String column) throws SQLException {
		final String value = rs.getString(column);

		if (value == null) {
			return "";
		} else {
			return rs.getString(column);
		}

	}

	public String getAward(Model model) throws SQLException {
		PreparedStatement queryStatement = null;
		ResultSet rs = null;

		try {
			queryStatement = getDBConnection().prepareStatement(
					"SELECT * FROM MAK_AWARDEDMODELS" + (model == null ? "" : " WHERE ID = " + model.getId()));

			rs = queryStatement.executeQuery();

			return rs.next() ? decodeStringFromDB(rs, "AWARD") : "-";
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.getAward(): ", ex);
			}
		}
	}

	public List<AwardedModel> getAwardedModels() throws SQLException {
		PreparedStatement queryStatement = null;
		ResultSet rs = null;

		try {
			queryStatement = getDBConnection().prepareStatement("SELECT * FROM MAK_AWARDEDMODELS");

			rs = queryStatement.executeQuery();

			final List<AwardedModel> returned = new LinkedList<AwardedModel>();
			while (rs.next()) {
				returned.add(new AwardedModel(servletDAO.getModel(rs.getInt("ID")), decodeStringFromDB(rs, "AWARD")));
			}

			return returned;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.getAwardedModels(): ", ex);
			}
		}
	}

	public List<String> getShows() throws SQLException {
		final List<String> returned = new LinkedList<String>();

		PreparedStatement queryStatement = null;
		ResultSet rs = null;

		try {
			queryStatement = getDBConnection().prepareStatement("SELECT distinct MODEL_SHOW FROM MAK_CATEGORY_GROUP");

			rs = queryStatement.executeQuery();

			while (rs.next()) {
				returned.add(decodeStringFromDB(rs, "MODEL_SHOW"));
			}

			return returned;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! getShows(): ", ex);
			}
		}
	}

	public void saveAwardedModel(final AwardedModel model) throws SQLException {
		PreparedStatement queryStatement = null;
		final ResultSet rs = null;

		logger.trace("ServletDAO.saveAwardedModel(): " + model);

		try {
			queryStatement = getDBConnection()
					.prepareStatement("insert into MAK_AWARDEDMODELS" + " (ID, AWARD) values (?,?)");

			queryStatement.setInt(1, model.getId());

			queryStatement.setString(2, model.getAward());

			queryStatement.executeUpdate();

		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.saveAwardedModel(): ", ex);
			}
		}
	}

	public String getSystemParameter(final SystemParameter parameter) {
		PreparedStatement queryStatement = null;
		ResultSet rs = null;

		try {
			queryStatement = getDBConnection()
					.prepareStatement("SELECT * FROM MAK_SYSTEM where PARAM_NAME = '" + parameter + "'");

			rs = queryStatement.executeQuery();

			if (rs.next()) {
				return rs.getString("PARAM_VALUE");
			} else {
				return ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
			}
		} catch (final Exception ex) {
			logger.fatal("!!! ServletDAO.getSystemParameter(): parameterName: " + parameter, ex);
			return ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.registrationAllowed(): ", ex);
			}
		}
	}

	public void setSystemParameter(final String parameterName, final String parameterValue) throws SQLException {
		PreparedStatement queryStatement = null;

		try {
			queryStatement = getDBConnection()
					.prepareStatement("update MAK_SYSTEM set PARAM_VALUE=? where PARAM_NAME=?");

			queryStatement.setString(1, parameterValue);
			queryStatement.setString(2, parameterName);

			if (queryStatement.executeUpdate() == 0) {
				queryStatement.close();

				queryStatement = getDBConnection()
						.prepareStatement("insert into MAK_SYSTEM (PARAM_VALUE, PARAM_NAME) values (?,?)");
				queryStatement.setString(1, parameterValue);
				queryStatement.setString(2, parameterName);

				queryStatement.executeUpdate();
			}
		} finally {
			try {
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.setSystemParameter(): parameterName: " + parameterName
						+ " parameterValue: " + parameterValue, ex);
			}
		}
	}

	public void deleteEntry(final String table, final String idField, final int id) throws SQLException {
		deleteEntries(table, (idField == null ? null : idField + " = " + id));
	}
	
	public void deleteEntries(final String table, final String whereClause) throws SQLException {
		PreparedStatement queryStatement = null;
		final ResultSet rs = null;

		try {
			queryStatement = getDBConnection()
					.prepareStatement("delete from " + table + (whereClause == null ? "" : " where " + whereClause ));

			queryStatement.executeUpdate();

		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.deleteEntry(): ", ex);
			}
		}
	}

	public StringBuilder execute(final String sql) throws SQLException {
		Statement queryStatement = null;
		ResultSet rs = null;

		try {
			logger.debug("ServletDAO.execute(): " + sql);
			if (sql.toLowerCase().indexOf("select") > -1) {
				queryStatement = getDBConnection().createStatement();
				rs = queryStatement.executeQuery(sql);

				final StringBuilder buff = new StringBuilder();
				buff.append(sql);
				buff.append("\n<br>\n");
				buff.append("<table border='1'>\n");
				final ResultSetMetaData rsm = rs.getMetaData();
				buff.append("  <tr>\n");
				for (int i = 1; i <= rsm.getColumnCount(); i++)
					buff.append("    <th>" + rsm.getColumnName(i) + "</th>\n");
				buff.append("  </tr>\n");

				boolean highlight = false;
				while (rs.next()) {
					if (highlight)
						buff.append("  <tr bgcolor='eaeaea' >\n");
					else
						buff.append("  <tr>\n");
					for (int i = 1; i <= rsm.getColumnCount(); i++)
						buff.append("    <td>" + rs.getString(i) + "</td>\n");
					buff.append("  </tr>\n");
					highlight = !highlight;
				}
				buff.append("</table>\n");

				return buff;
			} else {
				queryStatement = getDBConnection().prepareStatement(sql);
				PreparedStatement.class.cast(queryStatement).executeUpdate();
				return null;
			}
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}

				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.execute(): ", ex);
			}
		}
	}

	public String simpleQuery(final String field, String table) throws SQLException {
		PreparedStatement queryStatement = null;
		ResultSet rs = null;

		try {
			queryStatement = getDBConnection().prepareStatement("SELECT " + field + " FROM " + table);

			rs = queryStatement.executeQuery();

			if (rs.next()) {
				return rs.getString(1);
			}

			return "";
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.simpleQuery(): ", ex);
			}
		}
	}

	public void saveImage(int modelID, InputStream stream) throws SQLException, IOException, SQLException {
		PreparedStatement ps = null;
		try {
			ps = getDBConnection().prepareStatement("delete from MAK_PICTURES where ID=?");
			ps.setInt(1, modelID);
			ps.executeUpdate();
			ps.close();

			ps = getDBConnection().prepareStatement("INSERT INTO MAK_PICTURES (ID, PHOTO) VALUES (?, ?)");
			ps.setInt(1, modelID);
			ps.setBinaryStream(2, stream);
			ps.executeUpdate();
		} finally {
			ps.close();
		}
	}

	public byte[] loadImage(int id) throws SQLException {
		final PreparedStatement ps = getDBConnection().prepareStatement("select PHOTO from MAK_PICTURES where ID=?");
		ps.setInt(1, id);
		final ResultSet resultSet = ps.executeQuery();

		if (!resultSet.next()) {
			resultSet.close();
			ps.close();

			throw new IllegalStateException("Image not found. ID: " + id);
		}

		final Blob blob = resultSet.getBlob(1);
		final byte[] image = blob.getBytes(1, (int) blob.length());

		resultSet.close();
		ps.close();

		return image;
	}

	public Map<Integer, byte[]> getPhotos() throws SQLException {
		final Map<Integer, byte[]> photos = new HashMap<Integer, byte[]>();

		for (final Model model : servletDAO.getModels(ServletDAO.INVALID_USERID)) {
			try {
				final byte[] loadedImage = loadImage(model.getId());
				logger.debug("ServletDAO.loadImage(): model.getId(): " + model.getId() + " loadedImage.length: "
						+ loadedImage.length);
				photos.put(model.getId(), loadedImage);
			} catch (final Exception e) {
			}
		}

		return photos;
	}

	public List<String[]> getStatistics(final String show, ResourceBundle language) throws SQLException {
		final List<String[]> returned = new LinkedList<String[]>();
		final List<String[]> tablespaceStatas = new LinkedList<String[]>();
		tablespaceStatas.add(new String[] { "&nbsp", "" });
		tablespaceStatas.add(new String[] { "Versenymunk&aacute;k helyig&eacute;nye (cm<sup>2</sup>):", "" });

		final PreparedStatement queryStatement = null;
		final ResultSet rs = null;

		try {
			// aktiv kategoriak
			final List<Category> categories = servletDAO.getCategoryList(show);

//		  returned.add(new String[] { "Kateg&oacute;ri&aacute;k sz&aacute;ma: ", String.valueOf(categories.size()) });

			returned.add(new String[] { "&nbsp", "" });
			final List<User> users = servletDAO.getUsers();
			final Map<String, HashSet<Integer>> modelersPerCountry = new HashMap<>();
			final Map<String, HashSet<Model>> modelsPerCountrySet = new HashMap<>();

			int allModels = 0;

			returned.add(new String[] { language.getString("models.number.per.category") + ": ", "" });
			returned.add(new String[] { "&nbsp", "" });

			for (final Category category : categories) {
				if (!category.group.show.equals(show)) {
					continue;
				}

				final List<Model> models = servletDAO.getModelsInCategory(category.getId());

				returned.add(
						new String[] { "<b>" + category.categoryCode + " - " + category.categoryDescription + "</b>",
								String.valueOf(models.size()) });

				// benevezett makettek szama
				allModels += models.size();

				for (final Model model : models) {
					// jelenleg nevezok
					for (final User user : users) {
						if (user.getId() == model.getUserID()) {
							HashSet<Integer> userIDs = modelersPerCountry.get(user.country);
							if (userIDs == null) {
								userIDs = new HashSet<Integer>();
								modelersPerCountry.put(user.country, userIDs);
							}
							userIDs.add(user.getId());

							HashSet<Model> modelsPerCountry = modelsPerCountrySet.get(user.country);
							if (modelsPerCountry == null) {
								modelsPerCountry = new HashSet<Model>();
								modelsPerCountrySet.put(user.country, modelsPerCountry);
							}
							modelsPerCountry.add(model);
						}
					}
				}

				createCustomStats(models, category, tablespaceStatas);
			}

			returned.add(new String[] { "&nbsp", "" });

			// benevezett makettek szama
			returned.add(new String[] { language.getString("models.number") + ": ", String.valueOf(allModels) });
//		  returned.add(new String[] { "Felt&ouml;lt&ouml;tt k&eacute;pek sz&aacute;ma: ", simpleQuery("count(*)", "MAK_PICTURES") });

			returned.add(new String[] { "&nbsp", "" });

			// ossz regisztralt felhasznalo
			int modelers = 0;
			for (final String country : modelersPerCountry.keySet()) {
				modelers += modelersPerCountry.get(country).size();
			}

			returned.add(new String[] { language.getString("competitors.number") + ": ", String.valueOf(modelers) });

			// jelenleg nevezok
			for (final String country : modelersPerCountry.keySet().stream().sorted().collect(Collectors.toList())) {
				returned.add(new String[] {
						language.getString("competitors.number.per.country") + ": <b>" + country + "</b>",
						String.valueOf(modelersPerCountry.get(country).size()) });
			}

			returned.add(new String[] { "&nbsp", "" });

			// nevezett makettek száma országonként
			for (final String country : modelsPerCountrySet.keySet().stream().sorted().collect(Collectors.toList())) {
				returned.add(new String[] { "Nevezett makettek sz&aacute;ma orsz&aacute;gonk&eacute;nt: <b>" + country + "</b>",
						String.valueOf(modelsPerCountrySet.get(country).size()) });
			}

			// helyfoglalás
			returned.addAll(tablespaceStatas);
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (queryStatement != null) {
					queryStatement.close();
				}
			} catch (final Exception ex) {
				logger.fatal("!!! ServletDAO.getStatistics(): ", ex);
			}
		}

		return returned;
	}

	private void createCustomStats(final List<Model> models, final Category category,
			final List<String[]> tablespaceStatas) {
		int tablespace = models.stream().mapToInt(m -> (int) m.getWidth() * m.getLength()).sum();

		tablespaceStatas
				.add(new String[] { "<b>" + category.categoryCode + " - " + category.categoryDescription + "</b>",
						String.valueOf(tablespace) });
	}
}
