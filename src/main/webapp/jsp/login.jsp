<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="datatype.LoginConsent.LoginConsentType"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);

final String languageCode;
try {
	languageCode = RegistrationServlet.getLanguageCodeInRequest(request);
} catch (Exception ex) {
	RegistrationServlet.redirectToStartPage(request, response);
	return;
}

ResourceBundle language = languageUtil.getLanguage(languageCode);
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javascript" src="util.js"></script>

<script> 
	    function checkSubmit(form) {
	    	var showNotSet = form.<%=RequestParameter.Language.getParameterName()%> == null || form.<%=RequestParameter.Language.getParameterName()%>.value == '';
	    	var dataUsageNoConsent = !document.getElementById('dataUsageConsentCompetition').checked;
	    	var submitDisabled = (showNotSet || dataUsageNoConsent);
	    	var noticeDiv = document.getElementById('noticeDiv');
	    	var submitButton = document.getElementById('submitbutton');
	    	
	    	if (submitDisabled)
	        {  
		        if (showNotSet)
			    {
					noticeDiv.innerHTML = '<%=language.getString("select.show")%>';
				}
		        else if (dataUsageNoConsent) 
			    {
					noticeDiv.innerHTML = '<%=language.getString("data.usage.no.consent.warning")%>';
			}

			noticeDiv.className = "flash ERROR";

			submitButton.className = "disabledClass";
			submitButton.disabled = true;

			return false;
		} else {
			noticeDiv.innerHTML = '&nbsp;';
			noticeDiv.className = "";

			submitButton.className = "";
			submitButton.disabled = false;

			return true;
		}
	}
</script>
</head>

<link rel="stylesheet" href="base.css" media="screen" />

<body>
	<form name="input" id="inputForm" onSubmit="return checkSubmit(this)"
		action="../RegistrationServlet" method="post" accept-charset="UTF-8">

		<input type="hidden" name="command" value="login"> <input
			type="hidden"
			name="<%=RequestParameter.Language.getParameterName()%>"
			value="<%=languageCode%>">

		<table border="0" height="100%" width="100%">
			<tr>
				<td align="center" valign="middle">
					<table border="0">
						<tr>
							<td colspan="2"><FONT COLOR='#ffffff'>Verzi&oacute;:
									<%=servlet.getVersion()%></FONT></td>
						</tr>
							<jsp:include page="shows.jsp"></jsp:include>
						<tr>
							<td align="center">
								<jsp:include page="textInput.jsp">
									<jsp:param name="name" value="email" />
									<jsp:param name="label"
										value='<%=ServletUtil.getLabel(request, servlet, "email")%>' />
									<jsp:param name="mandatory" value="true" />
								</jsp:include>
							</td>
						</tr>
						<tr>
							<td align="center">
								<jsp:include page="textInput.jsp">
									<jsp:param name="name" value="password" />
									<jsp:param name="inputType" value="password" />
									<jsp:param name="label"
										value='<%=ServletUtil.getLabel(request, servlet, "password")%>' />
									<jsp:param name="mandatory" value="true" />
								</jsp:include>
								<p>
									<a
										href="reminder.jsp?<%=RequestParameter.Language.getParameterName()%>=<%=languageCode%>"><%=language.getString("password.reminder")%></a>
							</td>
						</tr>
						<jsp:include page="loginConsent.jsp"></jsp:include>
						<tr>
							<td colspan="2" align="center"><input name="submit"
								id="submitbutton" class="disabledClass" type="submit"
								value="<%=language.getString("login")%>">
								<p>
								<div id="noticeDiv">&nbsp;</div></td>
						</tr>
					</table>

					<p>
						<font color='#FF0000' size='+3'>&#8226;</font>
						<%=language.getString("mandatory.fields")%></p>
				</td>
			</tr>
		</table>

	</form>
</body>
</html>

