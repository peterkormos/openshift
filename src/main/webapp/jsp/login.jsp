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
ServletDAO servletDAO = servlet.getServletDAO();

final String languageCode = ServletUtil.getRequestAttribute(request, RequestParameter.Language.getParameterName());
ResourceBundle language = languageUtil.getLanguage(languageCode);

String showIdHttpParameter = request.getParameter(RequestParameter.ShowId.getParameterName());
final List<String> shows = servletDAO.getShows();

if (showIdHttpParameter != null)
	try {
		shows.retainAll(Arrays.asList(shows.get(Integer.parseInt(showIdHttpParameter) - 1)));
	} catch (Exception ex) {
	}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javascript" src="util.js"></script>

<script> 
	    function checkSubmit(form) {
	    	var showNotSet = form.show == null || form.show.value == '';
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
			noticeDiv.className = "flash";

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
		<%
		if (showIdHttpParameter != null) {
		%>
		<input type="hidden"
			name="<%=RequestParameter.ShowId.getParameterName()%>"
			value="<%=showIdHttpParameter%>">
		<%
		}
		%>

		<table border="0" height="100%" width="100%">
			<tr>
				<td align="center" valign="middle">
					<table border="0">
						<tr>
							<td colspan="2"><FONT COLOR='#ffffff'>Verzi&oacute;:
									<%=servlet.getVersion()%></FONT></td>
						</tr>
						<tr>
							<td><FONT COLOR='#ff0000'><b><%=servlet.getSystemMessage()%></b></FONT></td>
						</tr>
						<tr>
							<td align="center">
								<%
								for (final String show : shows) {
								%> <label> <input type='radio' name='show'
									onchange="updateMandatoryFieldMark(this); checkSubmit(document.getElementById('inputForm'));"
									value='<%=StringEncoder.toBase64(show.getBytes())%>'
									<%=(shows.size() == 1 ? " checked='checked'" : "")%> /> <img
									style="height: 25mm; vertical-align: middle;"
									src="../RegistrationServlet/<%=RegistrationServlet.Command.LOADIMAGE.name()%>/<%=servlet.getLogoIDForShow(show)%>">
									<span style="color: red"><b> <%=show%></b></span> <%=shows.isEmpty() || shows.size() == 1 ? "" : "<font color='#FF0000' size='+3'>&#8226;</font>"%>
							</label><br> <%
 }
 %>
							</td>
						</tr>
						<tr>
							<td align="center">
								<div class="input-caption-container" style="width: 200px">
									<input type="text" name="email" id="email" placeholder=" "
										onchange="updateMandatoryFieldMark(this);" /> <label
										for="email" class="input-caption"><%=language.getString("email")%></label>
									<font color='#FF0000' size='+3'>&#8226;</font>
								</div>
							</td>
						</tr>
						<tr>
							<td align="center">
								<div class="input-caption-container" style="width: 200px">
									<input type="password" name="password" id="password"
										placeholder=" " onchange="updateMandatoryFieldMark(this);" />
									<label for="password" class="input-caption"><%=language.getString("password")%></label>
									<font color='#FF0000' size='+3'>&#8226;</font>
								</div>
								<p>
									<a
										href="reminder.jsp?<%=RequestParameter.Language.getParameterName()%>=<%=languageCode%>"><%=language.getString("password.reminder")%></a>
							</td>
						</tr>
						<tr>
							<td>
								<%
								for (LoginConsentType lc : LoginConsent.LoginConsentType.values()) {
								%> <label <%=lc.isMandatory() ? "class='flash Warning'" : ""%>><input
									type="checkbox" id="dataUsageConsent<%=lc.name()%>"
									name="dataUsageConsent<%=lc.name()%>"
									<%=lc.isMandatory() ? "required='required'" : ""%>
									onchange="updateMandatoryFieldMark(this); checkSubmit(document.getElementById('inputForm'));">
									<%=language.getString("login.consent." + lc.name())%> <%
 if (lc.isMandatory()) {
 %> <font color='#FF0000' size='+3'>&#8226;</font> <%
 }
 %> </label> <br> <%
 }
 %>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center"><input name="submit"
								id="submitbutton" class="disabledClass" type="submit"
								value="<%=language.getString("login")%>">
								<p>
								<div id="noticeDiv" class="flash">&nbsp;</div></td>
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

