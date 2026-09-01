<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="servlet.RegistrationServlet.*"%>

<%@page import="java.util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil" scope="application"/>

<%
	final String languageCode;
	try {
		languageCode = RegistrationServlet.getLanguageCodeInRequest(request);
	} catch (Exception ex) {
		RegistrationServlet.redirectToStartPage(request, response);
		return;
	}
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ResourceBundle language = languageUtil.getLanguage(languageCode);
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="base.css" media="screen">
</head>
<body>
	<div class="header"></div>
	<table border="0" height="100%" width="100%">
		<tr>
			<td align="center" valign="middle">

				<form name="input" action="../RegistrationServlet/reminder"
					method="put" accept-charset="UTF-8">
					<input type="hidden" name="<%=RequestParameter.Language.getParameterName()%>" value="<%=languageCode %>" >
					<table border="0">
						<tr>
							<td>
								<jsp:include page="textInput.jsp">
									<jsp:param name="name" value="email" />
									<jsp:param name="label"
										value='<%=ServletUtil.getLabel(request, servlet, "email")%>' />
									<jsp:param name="mandatory" value="true" />
								</jsp:include>
							</td>
						</tr>
						<tr>
							<td><input type="submit"
								value="<%=language.getString("send.reminder")%>"></td>
						</tr>
					</table>

				</form>
			</td>
		</tr>
	</table>
</body>
</html>
