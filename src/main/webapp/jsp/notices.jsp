<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
List<MainPageNotice> notices = (List<MainPageNotice>) session.getAttribute(SessionAttributes.Notices.name());

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
session.removeAttribute(SessionAttributes.Notices.name());
%>
