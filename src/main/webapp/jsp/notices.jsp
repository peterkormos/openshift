<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
    List<MainPageNotice> notices = (List<MainPageNotice>) session.getAttribute(RegistrationServlet.SessionAttribute.Notices.name());

if (notices != null)
{
	for (MainPageNotice notice : notices)
	{
%>
	<div class="flash <%=notice.getType().name()%>"><%=notice.getText()%></div>
	<br>
<%
    }
}
session.removeAttribute(RegistrationServlet.SessionAttribute.Notices.name());
%>
