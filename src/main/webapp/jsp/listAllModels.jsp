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
	user = servlet.getUser(request);
} catch (Exception ex) {
}

if (user == null || !user.isAdminUser()) {
	RegistrationServlet.redirectToStartPage(request, response);
	return;
}

final String show = RegistrationServlet.getShowFromSession(session);

final List<? extends Model> models = RegistrationServlet.toPrintedModel(servletDAO.getModelsForShow(show, ServletDAO.INVALID_USERID));
models.sort(new Comparator<Model>() {
	@Override
	public int compare(Model o1, Model o2) {
		return Integer.compare(o2.getId(), o1.getId());
	}
});

final Iterator<? extends Model> it = models.iterator();
while (it.hasNext()) {
	final Model model = it.next();

	if (show != null && !servletDAO.getCategory(model.categoryID).group.show.equals(show)) {
		it.remove();
	}
}

session.setAttribute(RegistrationServlet.SessionAttribute.Models.name(), models);
%>

<jsp:include page="listModels.jsp"></jsp:include>

<%
    session.removeAttribute(RegistrationServlet.SessionAttribute.Models.name());
%>