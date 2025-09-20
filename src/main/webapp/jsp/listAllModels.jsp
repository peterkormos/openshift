<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<link href="base.css" rel="stylesheet" type="text/css">

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();

User user = servlet.getUser(request);
final String show = RegistrationServlet.getShowFromSession(session);

final List<Model> models = servletDAO.getModelsForShow(show, ServletDAO.INVALID_USERID);

final Iterator<Model> it = models.iterator();
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