<%@page import="java.util.List"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>


<form name='input' action='../../RegistrationServlet' method='put'>
	<input type='hidden' name='command' value='deleteAwardedModel'>
	<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ServletDAO servletDAO = servlet.getServletDAO();
	for (AwardedModel awardedModel : servletDAO.getAwardedModels()) {
		Model model = servletDAO.getModel(awardedModel.getModelID());
	%>
	<label> <input type='radio' name='modelID'
		value='<%=model.getId()%>' /> <%=model.getId()%> - <%=model.getScale()%> - <%=model.getName()%>
		- <%=model.getUser().getFullName()%> - <%=awardedModel.getAward()%>
	</label> <br>
	<%
}
%>
	<p>
		<input type='submit' value='T&ouml;r&ouml;l'>
</form>
</body>
</html>