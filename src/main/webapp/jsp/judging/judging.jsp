<%@page import="java.util.*" %>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil" scope="application"/>

<%

	if(session.getAttribute(SessionAttributes.Language.name()) == null)
	{
		final String languageCode = ServletUtil.getOptionalRequestAttribute(request, "language");
		ResourceBundle language = languageUtil.getLanguage(languageCode);
		
		session.setAttribute(SessionAttributes.Language.name(), language); 
	}
 %>

<head>
<link href="../base.css" rel="stylesheet" type="text/css">
</head>
<body>
	<a href="login.jsp">Login</a>
	<p>
	<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.GetCategories.name()%>">Judge</a>
	<p>
	<a href="getJudgingForm.jsp">Simple judging by looking at models...</a>
	<p>
	<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgings.name()%>">List judgings</a>
	<p>
	<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgingSummary.name()%>">List judging summary</a>
	<p>
	<hr>
	<p>
	<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.DeleteJudgings.name()%>">Delete judgings</a>
</body>