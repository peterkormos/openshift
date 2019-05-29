<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
	User user = RegistrationServlet.getUser(request);
	
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	final ResourceBundle language = (ResourceBundle)session.getAttribute(SessionAttributes.Language.name());

	int maxlength = 60;
	if(request.getParameter("maxlength") != null) 
		maxlength = Integer.parseInt(request.getParameter("maxlength"));
		
	boolean mandatory = Boolean.parseBoolean(request.getParameter("mandatory"));		
%>

<input type='text' maxlength='<%= maxlength %>' name='<%= request.getParameter("name") %>' placeholder="<%= String.format(language.getString("input.text.maxlength"), maxlength)%>"
<%
	String value = request.getParameter("value");

	if (value != null)
	{
%>
		value='<%= value %>'
<%
	}
%>
<%= mandatory ?  "required='required'" : "" %>
> 

<%
	if (mandatory)
	{
%>
	  <font color='#FF0000' size='+3'>&#8226;</font>
<% 
	}
%>