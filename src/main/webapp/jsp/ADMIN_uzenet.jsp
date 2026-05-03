<%@page import="servlet.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
String show = RegistrationServlet.getShowFromSession(session);
%>

<tr>
	<th colspan="5"><input name="setSystemParameter" type="submit"
		onClick="document.getElementById('paramName').value='SYSTEMMESSAGE';document.getElementById('paramValue').value=document.getElementById('paramSystemMessage').value;document.getElementById('command4').value='setSystemParameter';"
		value="Rendszer&#252;zenet be&aacute;ll&iacute;t&aacute;sa"></th>
</tr>
<tr>
	<td colspan="2"><textarea id="paramSystemMessage" cols="100"
			rows="3"><%=servlet.getSystemMessage(show)%></textarea></td>
</tr>
