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

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="../jsp/base.css" media="screen">
</head>

<body>
	<div class="header"></div>
	<table border="0" height="100%" width="100%">
		<tr>
			<td align="center" valign="middle">
				<table border="0">
					<tr>
						<td colspan="3">
							<jsp:include page="notices.jsp" />
						</td>
					</tr>
					<tr>
						<td><a
							href="../jsp/login.jsp?<%=RequestParameter.Language.getParameterName()%>=<%=languageCode%>"><%=language.getString("login")%>?</a></td>
						<td>
							<div align="center">-</div>
						</td>
						<td align="right"><a
							href="../jsp/reminder.jsp?<%=RequestParameter.Language.getParameterName()%>=<%=languageCode%>"><%=language.getString("password.reminder")%>?</a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>

