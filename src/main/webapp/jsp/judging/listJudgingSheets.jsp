<%@page import="java.util.*"%>

<%@page import="datatype.judging.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@include file="../util.jsp"%>

<%
	for (int i = 0; i < 3; i++) {
		session.setAttribute("s1", "" + i);
%>
<jsp:include page="getJudgingSheet2.jsp" />

<%
	}
%>
