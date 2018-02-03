<input type='text' maxlength="60" name='<%= request.getParameter("name") %>'
<%
	String value = request.getParameter("value");

	if (value != null)
	{
%>
		value='<%= value %>'
<%
	}
%>

> 

<%
	if (Boolean.parseBoolean(request.getParameter("mandatory")))
	{
%>
	  <font color='#FF0000' size='+3'>&#8226;</font>
<% 
	}
%>