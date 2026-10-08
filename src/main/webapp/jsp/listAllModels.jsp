<%@page import="java.util.*"%>
<%@page import="java.util.function.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<link href="base.css" rel="stylesheet" type="text/css">

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();

User user = null;
try {
	user = servlet.getUserOrRedirectToStartPage(request, response);
} catch (Exception ex) {
}

if (user == null || !user.isAdminUser()) {
	return;
}

final String show = RegistrationServlet.getShowFromSession(session);

final List<? extends Model> models = RegistrationServlet.toPrintedModel(RegistrationServlet.getModelsForShow(show, servletDAO.getModels(ServletDAO.INVALID_USERID)), show);
models.sort(new Comparator<Model>() {
	@Override
	public int compare(Model o1, Model o2) {
		return Integer.compare(o2.getId(), o1.getId());
	}
});

session.setAttribute(RegistrationServlet.SessionAttribute.Models.name(), models);
%>

<jsp:include page="listModels.jsp"></jsp:include>

<%
    session.removeAttribute(RegistrationServlet.SessionAttribute.Models.name());
%>