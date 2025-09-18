<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<form id='modelSelect' action='../RegistrationServlet' method='put' accept-charset="UTF-8">
<input type='hidden' name='command' value='<%= request.getParameter("action") %>'>
<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	User user = servlet.getUser(request);

	String show = RegistrationServlet.getShowFromSession(session);

	for (final Model model : servlet.getServletDAO().getModelsForShow(show, user.getId()))
	{
%>
<label>
		<input type='radio' name='modelID' value='<%=model.getId()%>'/>
		<%=model.scale%>
		-
		<%=model.producer%> 
		-
		<%=model.name%>
</label>
		<br>
<%
	}
%>
<p>
<input name='<%= request.getParameter("action") %>' type='submit' value='<%= request.getParameter("submitLabel") %>'>
</form>
