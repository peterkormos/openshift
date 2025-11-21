<%@page import="java.util.*"%>
<%@page import="servlet.*"%>
<%@page import="datatype.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();

final ResourceBundle language = servlet.getLanguageForCurrentUser(request);

List<User> users = servletDAO.getMasterAwardedUsers();
%>


<form accept-charset="UTF-8" name="input" id="input5"
	action="../RegistrationServlet/saveModelClass" method="post">
	<table style="border: 0px;">
		<tr>
			<th colspan="2" style='white-space: nowrap'>Mesterek rögzítése</th>
		</tr>
		<tr>
			<td>Makettez&#337; neve:</td>
			<td><input name="lastname" type="text" id="fullnameID"
				onChange="sendRequest();"> <select id="selectID"
				name="userID">
			</select></td>
		</tr>
		<tr>
			<td>Szakoszt&aacute;ly:</td>
			<td><select name="modelClass">
					<%
					for (String mc : RegistrationServlet.getModelClassList()) {
					%>
					<option value='<%=ServletUtil.encodeString(mc)%>'><%=ServletUtil.encodeString(mc)%></option>
					<%
					}
					%>
			</select></td>
		</tr>
		<tr>
			<td colspan="2"><input type="submit"
				value="<%=language.getString("save")%>"></td>
		</tr>
	</table>


</form>

<table style='border-collapse: collapse;' border='1'>
	<tr>
		<th style='white-space: nowrap'><%=language.getString("name")%></th>

		<th style='white-space: nowrap'><%=language.getString("year.of.birth")%>
		</th>

		<th style='white-space: nowrap'><%=language.getString("country")%>
		</th>

		<th style='white-space: nowrap'><%=language.getString("city")%></th>

		<th style='white-space: nowrap'>Szakoszt&aacute;ly</th>
	</tr>
	<%
	for (final User moUser : users) {
	%>
	<tr>
		<td><%=moUser.getFullName()%></td>
		<td><%=moUser.getYearOfBirth()%></td>
		<td><%=moUser.getCountry()%></td>
		<td><%=moUser.getCity()%></td>
		<td><%=moUser.getHTMLModelClass()%></td>
	</tr>
	<%
	}
	%>
</table>