<%
	String maxlength = "60";
	if(request.getParameter("maxlength") != null) 
		maxlength = request.getParameter("maxlength");
%>

<input type='text' maxlength='<%= request.getParameter("maxlength") == null ? 60 : request.getParameter("maxlength") %>' name='<%= request.getParameter("name") %>' placeholder="Max. <%= maxlength %> char."
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