<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%
List<MainPageNotice> notices = (List<MainPageNotice>) session.getAttribute(RegistrationServlet.SessionAttributes.Notices.name());

if (notices != null)
{
	for (MainPageNotice notice : notices)
	{
%>
	<div class="flash <%= notice.getType().name() %>"><%= notice.getText() %></div>
	<br>
<%
	}
}
session.removeAttribute(RegistrationServlet.SessionAttributes.Notices.name());
%>
