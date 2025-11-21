<%@page import="servlet.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	show = RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE;
}
%>

<tr>
	<td colspan="2"><a href="#"
		onClick="document.getElementById('command4').value='printAllModels';document.getElementById('paramName').name='printPreRegisteredModels';document.getElementById('paramName').value='true';document.getElementById('input4').submit();">
			Nevez&eacute;si lapok nyomtat&aacute;sa (El&ouml;nevezettek) </a></td>
</tr>
<tr>
	<td>Nyelv megad&aacute;sa:</td>
	<td>
		<%
		for (RegistrationServlet.PrintLanguages pl : RegistrationServlet.PrintLanguages.values()) {
		%> <a href="#"
		class='<%=pl.name().equals(servlet.getPrintLanguage(request)) ? "flash OK" : ""%> %>'
		onClick="document.getElementById('paramName').value='<%=RegistrationServlet.SystemParameter.PrintLanguage.name()%>';document.getElementById('paramValue').value='<%=pl.name()%>';document.getElementById('command4').value='setSystemParameter';document.getElementById('input4').submit();">
			<%=pl.name()%></a> <%
 }
 %>
	</td>
</tr>
<tr>
	<td><a href="#"
		onClick="document.getElementById('command4').value='printAllModels';document.getElementById('input4').submit();">
			Max. makettek oldalank&eacute;nt: </a></td>
	<td><input type="number"
		name="<%=RegistrationServlet.SystemParameter.MaxModelsPerPage.name()%>"
		size="2" value="3"></td>
</tr>
<tr>
	<td><a href="#"
		onClick="document.getElementById('command4').value='printAllModels';document.getElementById('input4').submit();">
			Lapt&ouml;r&eacute;s nyomtat&aacute;skor</a></td>
	<td><label>igen: <input type="radio"
			name="<%=RegistrationServlet.SystemParameter.PageBreakAtPrint.name()%>"
			value="<%=Boolean.TRUE%>" checked='checked'></label> <label>nem:
			<input type="radio"
			name="<%=RegistrationServlet.SystemParameter.PageBreakAtPrint.name()%>"
			value="<%=Boolean.FALSE%>">
	</label></td>
</tr>
<!--
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
