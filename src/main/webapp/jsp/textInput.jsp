<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%@page import="java.util.*"%>

<%
	User user = RegistrationServlet.getUser(request);
	
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	final ResourceBundle language = servlet.getLanguage(user.language);

	String maxlength = "60";
	if(request.getParameter("maxlength") != null) 
		maxlength = request.getParameter("maxlength");
%>

<input type='text' maxlength='<%= request.getParameter("maxlength") == null ? 60 : request.getParameter("maxlength") %>' name='<%= request.getParameter("name") %>' placeholder="<%= String.format(language.getString("input.text.maxlength"), maxlength)%>"
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