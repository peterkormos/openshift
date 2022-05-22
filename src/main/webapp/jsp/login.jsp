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

final String languageCode = ServletUtil.getRequestAttribute(request, "language");
ResourceBundle language = languageUtil.getLanguage(languageCode);

String showIdHttpParameter = request.getParameter("showId");
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
	    	var dataUsageNoConsent = !document.getElementById('dataUsageConsentCompetition').checked
	    	var submitDisabled =  
									(showNotSet || dataUsageNoConsent) 
									;
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
			} 
			else 
			{
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
			type="hidden" name="language" value="<%=languageCode%>">
		<%
		    if (showIdHttpParameter != null) {
		%>
		<input type="hidden" name="showId" value="<%=showIdHttpParameter%>">
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
							<td colspan="2"><FONT COLOR='#ff0000'><b><%=servlet.getSystemMessage()%></b></FONT></td>
						</tr>
						<tr bgcolor='F6F4F0'>
							<td><%=language.getString("show")%>:</td>
							<td>
								<%
								    for (final String show : shows) {
								%> <label><input type='radio' name='show'
									onchange="updateMandatoryFieldMark(this);"
									value='<%=StringEncoder.toBase64(show.getBytes())%>'
									<%=(shows.size() == 1 ? " checked='checked'" : "")%> /> <span
									style="color:red"><b> <%=show%></b></span>
								 <%=shows.isEmpty() || shows.size() == 1 ?  "" : "<font color='#FF0000' size='+3'>&#8226;</font>"%>									
									</label><br> <%
								     }
								 %> 
							</td>
						</tr>
						<tr>
							<td><FONT COLOR='#ff0000'><b><%=language.getString("email")%></b></FONT>:</td>
							<td><input type="text" name="email" id="email"
								onchange="updateMandatoryFieldMark(this);"> <font
								color='#FF0000' size='+3'>&#8226;</font></td>
						</tr>
						<tr bgcolor='F6F4F0'>
							<td><%=language.getString("password")%>:</td>
							<td><input type="password" name="password"
								onchange="updateMandatoryFieldMark(this);">
								<font color='#FF0000' size='+3'>&#8226;</font>
								<p>
									<a href="reminder.jsp?language=<%=languageCode%>"><%=language.getString("password.reminder")%></a>
									</td>
						</tr>
						<tr>
							<td colspan="2">
<%
		    for (LoginConsentType lc : LoginConsent.LoginConsentType.values() ) {
		%>
							<label
							<%= lc.isMandatory() ? "class='flash Warning'" : "" %>
							><input type="checkbox"
									id="dataUsageConsent<%=lc.name() %>"
									name="dataUsageConsent<%=lc.name() %>"
									<%= lc.isMandatory() ? "required='required'" : "" %> 
									onchange="checkSubmit(document.getElementById('inputForm')) && updateMandatoryFieldMark(this);">
									<%= language.getString("login.consent." + lc.name()) %> 
		<%
		    if (lc.isMandatory()) {
		%>
									<font color='#FF0000' size='+3'>&#8226;</font>
		<%
		    }
		%>
									
									</label>
									<br>
		<%
		    }
		%>									
									</td>
						</tr>
						<tr>
							<td colspan="2" align="center"><input name="submit"
								id="submitbutton" 
								class = "disabledClass"
								type="submit"
								value="<%=language.getString("login")%>">
								<p>
								
								<div id="noticeDiv" class="flash">
								&nbsp;
								</div></td>
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

