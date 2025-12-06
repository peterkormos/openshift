<%@page import="java.util.*"%>
<%@page import="servlet.*"%>
<%@page import="datatype.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();
User user = servlet.getUser(request);

final ResourceBundle language = servlet.getLanguageForCurrentUser(request);

List<User> users = servletDAO.getMasterAwardedUsers();
%>

<jsp:include page="notices.jsp" />

<p></p>

	<table style="border: 0px;">
		<tr>
			<th colspan="7" style='white-space: nowrap'>Mesterek rögzítése</th>
		</tr>
<form accept-charset="UTF-8" name="input" id="input5"
	action="../RegistrationServlet/saveModelClass" method="post">
		<tr>
			<td>Makettez&#337; neve:</td>
			<td colspan="6"><input name="lastname" type="text" id="fullnameID"
				onChange="sendRequest();"> <select id="selectID"
				name="userID">
			</select></td>
		</tr>
		<tr>
			<td>Szakoszt&aacute;ly:</td>
			<td colspan="6"><select name="modelClass">
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
			<td colspan="7"><input type="submit"
				value="<%=language.getString("save")%>"></td>
		</tr>
</form>
			<tr>
				<td colspan="7">&nbsp;</td>
			</tr>

	<tr>
		<th colspan="7" style='white-space: nowrap'>Adatkezel&eacute;s</th>
	</tr>
	<tr>
		<td colspan="2"><a href="../RegistrationServlet/exportMasters">&Ouml;sszes
				adat export&aacute;l&aacute;sa</a></td>

		<form accept-charset="UTF-8" action="../RegistrationServlet"
			method="post" enctype="multipart/form-data" name="input">
			<input type="hidden" name="command" value="importData">
			<td colspan="5"><input type="submit"
				value="Excelb&#337;l import&aacute;l&aacute;s"> <input
				type="file" name="mastersFile"></td>
		</form>
	</tr>
			<tr>
				<td colspan="7">&nbsp;</td>
			</tr>
	<tr>
		<th style='white-space: nowrap'><%=language.getString("name")%></th>

		<th style='white-space: nowrap'><%=language.getString("year.of.birth")%>
		</th>

		<th style='white-space: nowrap'><%=language.getString("country")%>
		</th>

		<th style='white-space: nowrap'><%=language.getString("city")%></th>

		<th style='white-space: nowrap'><%=language.getString("userID")%></th>

		<th style='white-space: nowrap'>Szakoszt&aacute;ly</th>
		<th style='white-space: nowrap'></th>
	</tr>
	<%
	for (final User moUser : users) {
	%>
	<tr>
		<td align="center"><%=moUser.getFullName()%></td>
		<td align="center"><%=moUser.getYearOfBirth()%></td>
		<td align="center"><%=moUser.getCountry()%></td>
		<td align="center"><%=moUser.getCity()%></td>
		<td align="center"><%=moUser.getId()%></td>
		<td align="center"><%=moUser.getHTMLModelClass()%></td>
		<td align="center">
	<%
	if (user.isSuperAdminUser()) {
	%>
			<div class="tooltip">
				<a
					href="../RegistrationServlet/deleteMasterUser?userID=<%=moUser.getId()%>">
					<img src="../icons/delete2.png" height="30" align="center" /> <span
					class="tooltiptext"> <%=language.getString("delete")%></span>
				</a>
			</div>
	<%
	}
	%>
</td>
	</tr>
	<%
	}
	%>
</table>