<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();

User user = servlet.getUser(request);
List<Model> models = servletDAO.getModels(user.userID);

for (Model model : models) {
	session.setAttribute(RegistrationServlet.SessionAttribute.Model.name(), model);
%>
    <jsp:include page="printModelForm.jsp" />
    <p>
<%
session.removeAttribute(RegistrationServlet.SessionAttribute.Model.name());
}
%>