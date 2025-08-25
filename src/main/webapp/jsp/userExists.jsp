<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%@page import="java.util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
final String languageCode = ServletUtil.getRequestAttribute(request, RequestParameter.Language.getParameterName());
ResourceBundle language = languageUtil.getLanguage(languageCode);
%>

<head>

<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="../jsp/base.css" rel="stylesheet" type="text/css">
</head>

<%=language.getString("select.another.email")%>
<br>
<a
	href="../jsp/reminder.jsp?<%=RequestParameter.Language.getParameterName()%>=<%=languageCode%>"><%=language.getString("password.reminder")%>?</a>
