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
<tr>
	<td>Max. makettek kateg&oacute;ri&aacute;nk&eacute;nt:</td>
	<td><input
		onClick="document.getElementById('paramName').value='<%=RegistrationServlet.SystemParameter.MaxModelsPerCategory.name()%>';document.getElementById('command4').value='setSystemParameter';document.getElementById('paramValue').value=document.getElementById('maxModelsPerCategoryParam').value;document.getElementById('input4').submit();"
		type="number" id="maxModelsPerCategoryParam" size="2"
		value="<%=servlet.getMaxModelsPerCategory(request)%>"></td>
</tr>
