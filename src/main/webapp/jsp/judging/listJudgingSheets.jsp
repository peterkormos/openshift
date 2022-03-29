<%@page import="java.util.*"%>

<%@page import="datatype.judging.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@include file="../util.jsp"%>

<%
	Collection<JudgingResult> judgingResults = (Collection<JudgingResult>) session
			.getAttribute(JudgingServlet.SessionAttribute.Judgings.name());

	for (JudgingResult judgingResult : judgingResults) {
		session.setAttribute(JudgingServlet.SessionAttribute.Judgings.name(), judgingResult);
%>
<jsp:include page="getJudgingSheet.jsp" >
	<jsp:param name="listMode" value='true' />
</jsp:include>
<p>
<%
	}
	session.removeAttribute(JudgingServlet.SessionAttribute.Judgings.name());
%>
