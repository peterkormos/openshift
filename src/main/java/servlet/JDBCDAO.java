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
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import datatype.AwardedModel;
import datatype.Model;
import servlet.ServletDAO.SYSTEMPARAMETER;

public class JDBCDAO {
	public static Logger logger = Logger.getLogger(JDBCDAO.class);

	private final String dbURL;
	private final String dbUserName;
	private final String dbPassword;
	private Connection dBConnection;

	private ServletDAO servletDAO;

	public JDBCDAO(String dbURL, String dbUserName, String dbPassword, ServletDAO servletDAO) throws SQLException {
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

	public String getAward(Model model) throws SQLException {
		PreparedStatement queryStatement = null;
		ResultSet rs = null;

		try {
			queryStatement = getDBConnection().prepareStatement(
					"SELECT * FROM MAK_AWARDEDMODELS" + (model == null ? "" : " WHERE ID = " + model.getId()));

			rs = queryStatement.executeQuery();

			return rs.next() ? ServletDAO.decodeStringFromDB(rs, "AWARD") : "-";
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
				returned.add(new AwardedModel(servletDAO.getModel(rs.getInt("ID")),
						ServletDAO.decodeStringFromDB(rs, "AWARD")));
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
				returned.add(ServletDAO.decodeStringFromDB(rs, "MODEL_SHOW"));
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

			queryStatement.setString(2, model.award);

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

	public String getSystemParameter(final SYSTEMPARAMETER parameter) {
		PreparedStatement queryStatement = null;
		ResultSet rs = null;

		try {
			queryStatement = getDBConnection()
					.prepareStatement("SELECT * FROM MAK_SYSTEM where PARAM_NAME = '" + parameter + "'");

			rs = queryStatement.executeQuery();

			if (rs.next()) {
				return rs.getString("PARAM_VALUE");
			} else {
				return "-";
			}
		} catch (final Exception ex) {
			logger.fatal("!!! ServletDAO.getSystemParameter(): parameterName: " + parameter, ex);
			return "-";
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
		PreparedStatement queryStatement = null;
		final ResultSet rs = null;

		try {
			queryStatement = getDBConnection()
					.prepareStatement("delete from " + table + (idField == null ? "" : " where " + idField + " = ?"));

			if (idField != null) {
				queryStatement.setInt(1, id);
			}

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

	public byte[] loadImage(int modelID) throws SQLException {
		final PreparedStatement ps = getDBConnection().prepareStatement("select PHOTO from MAK_PICTURES where ID=?");
		ps.setInt(1, modelID);
		final ResultSet resultSet = ps.executeQuery();

		if (!resultSet.next()) {
			resultSet.close();
			ps.close();

			throw new IllegalStateException("Image not found. modelID: " + modelID);
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
}
