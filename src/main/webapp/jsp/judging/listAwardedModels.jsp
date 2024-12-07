<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();

final List<Model> models = new LinkedList<Model>();

for (AwardedModel am : servletDAO.getAwardedModels()) {
	models.add(am);
}

session.setAttribute(RegistrationServlet.SessionAttribute.Models.name(), models);
%>

<jsp:include page="../listModels.jsp">
	<jsp:param name="actionPathPrefix" value="../" />
	<jsp:param name="insertAwards" value="true" />
</jsp:include>

<%
session.removeAttribute(RegistrationServlet.SessionAttribute.Models.name());
%>