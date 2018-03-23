<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%@page import="java.util.*"%>

<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ResourceBundle language = servlet.getLanguage(request.getParameter("language"));
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="base.css" media="screen">
</head>
<body>
	<div class="header"></div>
	<table border="0" height="100%" width="100%">
		<tr>
			<td align="center" valign="middle">

				<form name="input" action="../RegistrationServlet/reminder"
					method="put" accept-charset="UTF-8">

					<table border="0">
						<tr>
							<td><%=language.getString("email")%>:</td>
							<td><input type="text" name="email"></td>
						</tr>
						<tr>
							<td></td>
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
