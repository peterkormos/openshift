<%@page import="java.util.List"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>


<form name='input' action='../../RegistrationServlet' method='put'>
	<input type='hidden' name='command' value='deleteAwardedModel'>
	<%
	for (AwardedModel model : RegistrationServlet.servletDAO.getAwardedModels()) {
	%>
	<label> <input type='radio' name='modelID'
		value='<%=model.getId()%>' /> <%=model.id%> - <%=model.scale%> - <%=model.name%>
		- <%=RegistrationServlet.servletDAO.getUser(model.userID).getFullName()%> - <%=model.getAward()%>
	</label> <br>
	<%
}
%>
	<p>
		<input type='submit' value='T&ouml;r&ouml;l'>
</form>
</body>
</html>