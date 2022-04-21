<%@page import="servlet.ServletUtil"%>
<%
	String parameterName = ServletUtil.getOptionalRequestAttribute(request, "parameterName");
	if(ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(parameterName))
		parameterName = "language";
 %>
<select name="<%= parameterName %>" 
<%= ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestAttribute(request, "required")) ? "" : "required='"+ServletUtil.getOptionalRequestAttribute(request, "required")+"'" %>
>
  <option value="<%= request.getParameter("selectValue") %>" selected><%= request.getParameter("selectLabel") %></option>
  <option value="" >-------</option>
  <option value="HU">Magyar</option>
  <option value="EN">English</option>
  <option value="SK">Slovensk&aacute;</option>
  <option value="CZ">Cesk&aacute;</option>
  <option value="PL">Polski</option>
  <option value="IT">Italiano</option>
  <option value="DE">Deutsch</option>
  <option value="RU">&#1056;&#1091;&#1089;&#1089;&#1082;&#1080;&#1081;</option>
   <option value="" >-------</option>
</select>
