<%@page import="java.util.*"%>
<%@page import="servlet.*"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href='base.css' rel='stylesheet' type='text/css'>
</head>
<%
String show = (String) session.getAttribute(RegistrationServlet.SessionAttribute.Show.name());
%>

<body>
	<form name="input" action="../RegistrationServlet" method="POST"
		accept-charset="UTF-8">
		<input type="hidden" name="command" value="addCategoryGroup">

		<table border="0">
			<tr>
				<th colspan="2">&Uacute;j kateg&oacute;riacsoport
					hozz&aacute;ad&aacute;sa...</th>
			</tr>
			<tr>
				<td>Verseny:</td>
				<td><input name="show" type="text" size="50" value="<%=show%>"></td>
			</tr>
			<tr>
				<td>Kateg&oacute;ria csoport (Pl. Feln&otilde;tt, gyerek, ifi,
					stb.):</td>
				<td><input name="group" type="text" size="50"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" value="Ment"></td>
			</tr>
		</table>
	</form>
</body>
</html>
