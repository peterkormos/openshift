<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ServletDAO servletDAO = servlet.getServletDAO();

	User user = servlet.getUser(request);
	String show = RegistrationServlet.getShowFromSession(session);
	List<Model> models = servletDAO.getModels(user.getId());
	Map<Integer, Category> categories = (Map<Integer, Category>) ServletUtil.getSessionAttribute(request,
			RegistrationServlet.SessionAttribute.Categories.name());

	models = RegistrationServlet.getModelsForShow(show, models, categories);
	
	for(Model model : models) {
		session.setAttribute(RegistrationServlet.SessionAttribute.Model.name(), model);
%>
<jsp:include page="printModelForm.jsp" />
<p>
	<%
		session.removeAttribute(RegistrationServlet.SessionAttribute.Model.name());
		};
	%>