<%@page import="servlet.*" %>

<%= request.getParameter("caption") != null ? request.getParameter("caption") + ":" : "" %> 

<%
String fieldValue = ServletUtil.getOptionalRequestParameter(request, "value");
String disabledString = ServletUtil.getOptionalRequestParameter(request, "disabled");
boolean disabled = RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(disabledString) ? false : Boolean.parseBoolean(disabledString);

if(disabled)
{
%>
	<b><%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(fieldValue) ? "" : fieldValue%></b>
	<input type="hidden" 
		name="<%=request.getParameter("name")%>"
		value="<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(fieldValue) ? "" : fieldValue%>"
	> 
<%
}
else
{
	%>
<input type="text" 
	required="required"
	name="<%=request.getParameter("name")%>"
	value="<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(fieldValue) ? "" : fieldValue%>"
	min="1"
	size="<%=ServletUtil.getOptionalRequestParameter(request, "size").replaceAll(RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE, "20")%>"
	onChange="<%=ServletUtil.getOptionalRequestParameter(request, "onChange").replaceAll(RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE, "")%>"
> 
<%
}				
 %>
