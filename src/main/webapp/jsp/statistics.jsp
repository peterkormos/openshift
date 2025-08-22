<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="util.*"%>

<%@include file="util.jsp"%>
<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = RegistrationServlet.getServletDAO();

ResourceBundle language = languageUtil
		.getLanguage(ServletUtil.getOptionalRequestAttribute(request, RequestParameter.Language.getParameterName()));
boolean shortStatistics = Boolean.valueOf(ServletUtil.getOptionalRequestAttribute(request, "shortStatistics"));

String show = RegistrationServlet.getShowFromSession(request);
List<String> shows = show == null ? servletDAO.getShows() : Arrays.asList(new String[] { show });
String showId = ServletUtil.getOptionalRequestAttribute(request, RequestParameter.ShowId.getParameterName());
if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(showId)) {
	shows.retainAll(Arrays.asList(shows.get(Integer.parseInt(showId) - 1)));
}
%>

<!DOCTYPE html>
<html>
<head>
<link href="base.css" rel="stylesheet" type="text/css">
</head>
<body>
	<%
	for (String currentShow : shows) {
		String logoURL = "../RegistrationServlet/" + RegistrationServlet.Command.LOADIMAGE.name() + "/"
		+ servlet.getLogoIDForShow(currentShow);
	%>
	<table style='width: 100%; border-collapse: collapse;' border='1'>
		<tr>
			<th><b><%=language.getString("show")%></b></th>
			<th align='center'><img style="height: 25mm" src='<%=logoURL%>'>
				<br> <%=currentShow%></th>
		</tr>
		<%
		for (final String[] stat : servletDAO.getStatistics(currentShow, language, !shortStatistics)) {
		%>
		<tr bgcolor="<%=highlight()%>">
			<td><%=stat[0]%></td>
			<td align='center'><%=stat[1]%></td>
		</tr>
		<%
		}
		%>
	</table>
	<p>
		<%
		}
		%>
	
</body>
</html>