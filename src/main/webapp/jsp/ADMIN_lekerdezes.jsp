<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
User user = null;
try {
	user = servlet.getUser(request);
} catch (Exception ex) {
}

if (user == null || !user.isAdminUser()) {
	response.sendRedirect("index.jsp");
	return;
}
%>

<table style="box-shadow: none" border="0">
	<tr>
		<th style="background: none">Lek&eacute;rdez&eacute;sek:</th>
		<td><a href="../RegistrationServlet/exportExcel"><strong>&Ouml;sszes
					benevezett makett Excelbe</strong></a></td>
		<td><a href="../RegistrationServlet/statistics?<%= RequestParameter.Language.getParameterName()%>=HU"><strong>Statisztika
					k&eacute;sz&iacute;t&eacute;se</strong></a></td>
		<td><a href="listAllModels.jsp"> &Ouml;sszes benevezett
				makett list&aacute;z&aacute;sa</a> - <a href="customQuery.jsp">Egyedi
				lek&eacute;rdez&eacute;sek</a> <%
 if (user.isSuperAdminUser()) {
 %> - <a href="../RegistrationServlet/listUsers">&Ouml;sszes
				felhaszn&aacute;l&oacute; list&aacute;z&aacute;sa</a> <%
 }
 %></td>
	</tr>
</table>