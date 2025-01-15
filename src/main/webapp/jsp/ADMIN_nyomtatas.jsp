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
		<th style="background: none">Nyomtat&aacute;s:</th>
		<td>
			<form accept-charset="UTF-8" name="input" id="input6"
				action="../RegistrationServlet" method="post">
				<input type="hidden" id="command6" name="command" value="">
				<input type="hidden" id="paramName6" name="paramName" value="">
				<input type="hidden" id="paramValue6" name="paramValue" value="">
				Nyelv megad&aacute;sa:
				<%
				for (RegistrationServlet.PrintLanguages pl : RegistrationServlet.PrintLanguages.values()) {
				%>
				<a href="#"
					class='<%=pl.name().equals(servlet.getPrintLanguage(request)) ? "flash OK" : ""%> %>'
					onClick="document.getElementById('paramName6').value='<%=ServletDAO.SystemParameter.PrintLanguage.name()%>';document.getElementById('paramValue6').value='<%=pl.name()%>';document.getElementById('command6').value='setSystemParameter';document.getElementById('input6').submit();">
					<%=pl.name()%></a> -
				<%
					}
					%>
				<a
					href="../RegistrationServlet/printAllModels?printPreRegisteredModels=true">
					Nevez&eacute;si lapok nyomtat&aacute;sa (El&ouml;nevezettek) </a>
			</form> <!--
-
<a
	href="../RegistrationServlet/printAllModels?printPreRegisteredModels=false">
    Nevez&eacute;si 
    lapok nyomtat&aacute;sa (Helysz&iacute;nen nevezettek)</a> - 
<a
	href="../RegistrationServlet/printAllModels?printPreRegisteredModels=true&printCardsForAllModels=true">
	A
		makettek mell&eacute; kisk&aacute;rty&aacute;k nyomtat&aacute;sa</a>
-->
		</td>
	</tr>
</table>