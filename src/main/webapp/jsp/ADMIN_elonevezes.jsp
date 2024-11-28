<%@page import="servlet.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	show = ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
}
%>

<table style="box-shadow: none" border="0">
	<tr>
		<th>El&otilde;nevez&eacute;s:</th>
		<td>
			<form accept-charset="UTF-8" name="input" id="input4"
				action="../RegistrationServlet" method="post">
				<input type="hidden" id="command4" name="command" value="">
				<input type="hidden" id="paramName" name="paramName" value="">
				<a href="#" class='<%=!servlet.isOnSiteUse() ? "flash OK" : ""%> %>'
					onClick="document.getElementById('paramName').value='ONSITEUSE';document.getElementById('paramValue').value='0';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">Internetes
					m&oacute;d</a> - <a href="#"
					class='<%=servlet.isPreRegistrationAllowed(show) ? "flash OK" : ""%> %>'
					onClick="document.getElementById('paramName').value='REGISTRATION';document.getElementById('paramValue').value='1';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">El&ouml;nevez&eacute;s
					kezd&eacute;se</a> - <a href="#"
					class='<%=!servlet.isPreRegistrationAllowed(show) ? "flash OK" : ""%> %>'
					onClick="document.getElementById('paramName').value='REGISTRATION';document.getElementById('paramValue').value='0';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">El&ouml;nevez&eacute;s
					v&eacute;ge</a> - <a href="#"
					class='<%=servlet.isOnSiteUse() ? "flash OK" : ""%> %>'
					onClick="document.getElementById('paramName').value='ONSITEUSE';document.getElementById('paramValue').value='1';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">Helysz&iacute;ni
					m&oacute;d</a> - <a href="#"
					onClick="document.getElementById('paramName').value='MaxModelsPerCategory';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">Max.
					makettek kateg&oacute;ri&aacute;nk&eacute;nt (<%=servlet.getMaxModelsPerCategory(request)%>):
				</a> <input
		onClick="document.getElementById('paramName').value='MaxModelsPerCategory';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">Max. makettek kateg&oacute;ri&aacute;nk&eacute;nt: </a>
		type="number" id="paramValue" name="paramValue" size="2" value="<%=servlet.getMaxModelsPerCategory(request)%>" 
					onchange="document.getElementById('paramName').value='MaxModelsPerCategory';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">
			</form>
		</td>
	</tr>
</table>