<%@page import="servlet.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	show = RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE;
}
%>

<tr>
	<td><a href="#"
		class='<%=servlet.isPreRegistrationAllowed(show) ? "flash OK" : ""%> %>'
		onClick="document.getElementById('paramName').value='<%=RegistrationServlet.SystemParameter.REGISTRATION.name()%>';document.getElementById('paramValue').value='1';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">El&ouml;nevez&eacute;s
			kezd&eacute;se</a></td>
	<td><a href="#"
		class='<%=!servlet.isPreRegistrationAllowed(show) ? "flash OK" : ""%> %>'
		onClick="document.getElementById('paramName').value='<%=RegistrationServlet.SystemParameter.REGISTRATION.name()%>';document.getElementById('paramValue').value='0';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">El&ouml;nevez&eacute;s
			v&eacute;ge</a></td>
</tr>
