<%@page import="java.util.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="datatype.*"%>
<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="base.css" media="screen" />
</head>

<%
String show = null;
try {
	show = RegistrationServlet.getShowFromRequestAsIs(request);
} catch (final Exception e) {
}
%>
 
<body style="font-family: sans-serif;">
	<div class="header"></div>
	<table border="0" height="100%" width="100%">
		<tr>
			<td align="center" valign="middle">Welcome to <b>MORES</b>, the <b>MO</b>del <b>RE</b>gistration <b>S</b>ystem....
				<p></p>
				<table border="0" cellspacing="5">
					<tbody>
<%
	Map<String, String> languageIcons = LanguageUtil.getLanguageIcons();
	for(Entry<String, String> languageEntry : languageIcons.entrySet()) {
		ResourceBundle language = languageUtil.getLanguage(languageEntry.getKey());
%>
						<tr>
							<td><img src="<%=request.getParameter("pathOffset") != null ? request.getParameter("pathOffset") : ""%>../icons/<%=languageEntry.getValue() %>"></td>
							<td><a href="login.jsp?<%= RequestParameter.Language.getParameterName() %>=<%=languageEntry.getKey() %>&<%=RegistrationServlet.addHTMLShowReference(show)%>"><%=language.getString("login") %></a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td align="center"><a
								href="user.jsp?<%=RegistrationServlet.RequestParameter.Action.getParameterName()%>=register&<%= RequestParameter.Language.getParameterName()%>=<%=languageEntry.getKey() %>&<%=RegistrationServlet.addHTMLShowReference(show)%>"><%=language.getString("register") %></a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td  align="right"><a href="reminder.jsp?<%= RequestParameter.Language.getParameterName()%>=<%=languageEntry.getKey() %>"><%=language.getString("forgot.password") %></a></td>
						</tr>
<%
	}		
%>
					</tbody>
				</table>
				<p>This site was developed and is maintained for free.</p> 
				<p>
				<form action="https://www.paypal.com/cgi-bin/webscr" method="post"
					target="_top">
					<input type="hidden" name="cmd" value="_s-xclick"> <input
						type="hidden" name="hosted_button_id" value="ZYUMYVHTYC75A">
					<input type="image"
						src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif"
						border="0" name="submit"
						alt="PayPal - The safer, easier way to pay online!"> <img
						alt="" border="0"
						src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif"
						width="1" height="1">
				</form>
			</td>
		</tr>
	</table>
</body>
</html>