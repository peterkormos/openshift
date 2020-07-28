<%@page import="servlet.*" %>

<%= request.getParameter("caption") %>: 
<%
	String fieldValue = ServletUtil.getOptionalRequestAttribute(request, "value");
	
	if(ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(fieldValue))
	{
	%>
		<input type="text" 
		required="required"
		name="<%= request.getParameter("name") %>"
		min="1"
		size="<%= ServletUtil.getOptionalRequestAttribute(request, "size").replaceAll(ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE, "20") %>"
		onChange="<%= ServletUtil.getOptionalRequestAttribute(request, "onChange").replaceAll(ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE, "") %>"
		> 
	<%
	}
	else
	{
	%>
		<input type="text" 
		required="required"
		name="<%= request.getParameter("name") %>"
		value="<%= fieldValue %>"
		<%= ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestAttribute(request, "disabled")) ? "" : "disabled" %>
		min="1"
		size="<%= ServletUtil.getOptionalRequestAttribute(request, "size").replaceAll(ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE, "20") %>"
		onChange="<%= ServletUtil.getOptionalRequestAttribute(request, "onChange").replaceAll(ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE, "") %>"
		> 

<!-- 		<input type="hidden" -->
<%-- 		name="<%= request.getParameter("name") %>" --%>
<%-- 		value="<%= fieldValue %>">  --%>
<%-- 		<b><%= fieldValue %></b>  --%>
	<%
	}				
 %>
