<%@page import="servlet.*" %>

<%= request.getParameter("caption") %>: 
<%
String fieldValue = ServletUtil.getOptionalRequestParameter(request, "value");
	
	if(RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(fieldValue))
	{
%>
		<input type="text" 
		required="required"
		name="<%=request.getParameter("name")%>"
		min="1"
		size="<%=ServletUtil.getOptionalRequestParameter(request, "size").replaceAll(RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE, "20")%>"
		onChange="<%=ServletUtil.getOptionalRequestParameter(request, "onChange").replaceAll(RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE, "")%>"
		> 
	<%
 	}
 		else
 		{
 	%>
		<input type="text" 
		required="required"
		name="<%=request.getParameter("name")%>"
		value="<%=fieldValue%>"
		<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestParameter(request, "disabled")) ? "" : "style='pointer-events: none;'"%>
		min="1"
		size="<%=ServletUtil.getOptionalRequestParameter(request, "size").replaceAll(RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE, "20")%>"
		onChange="<%=ServletUtil.getOptionalRequestParameter(request, "onChange").replaceAll(RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE, "")%>"
		> 

<!-- 		<input type="hidden" -->
<%-- 		name="<%= request.getParameter("name") %>" --%>
<%-- 		value="<%= fieldValue %>">  --%>
<%-- 		<b><%= fieldValue %></b>  --%>
	<%
	}				
 %>
