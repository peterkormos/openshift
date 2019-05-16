<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%
  RegistrationServlet servlet = RegistrationServlet.getInstance(config);
  ServletDAO servletDAO = servlet.getServletDAO();

  User user = servlet.getUser(request);
  List<Model> models = servletDAO.getModels(user.userID);

  session.setAttribute(RegistrationServlet.SessionAttributes.Models.name(), models);
%>

<jsp:include page="listModels.jsp">
	<jsp:param name="withDetailing" value="true" />
</jsp:include>

<%
  session.removeAttribute(RegistrationServlet.SessionAttributes.Models.name());
%>