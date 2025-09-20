<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();

User user = servlet.getUser(request);
String show = RegistrationServlet.getShowFromSession(session);

Map<Integer, Category> categories = (Map<Integer, Category>) ServletUtil.getSessionAttribute(request,
		RegistrationServlet.SessionAttribute.Categories.name());
List<Model> models = (List<Model>) session.getAttribute(RegistrationServlet.SessionAttribute.Models.name());
if (models == null) {
	models = RegistrationServlet.getModelsForShow(show, servletDAO.getModels(user.getId()), categories);
}

for (Model model : models) {
	session.setAttribute(RegistrationServlet.SessionAttribute.Model.name(), model);
%>
<jsp:include page="printModelForm.jsp">
	<jsp:param name="firstModel" value="<%=models.size() == 1%>" />
</jsp:include>
<p>
	<%
	session.removeAttribute(RegistrationServlet.SessionAttribute.Model.name());
	}
	%>