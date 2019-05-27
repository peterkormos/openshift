<%@page import="java.util.*" %>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil" scope="application"/>

<%

	ResourceBundle language = (ResourceBundle)session.getAttribute(SessionAttributes.Language.name());
	 
	if(language == null)
	{
		final String languageCode = ServletUtil.getOptionalRequestAttribute(request, "language");
		language = languageUtil.getLanguage(languageCode);
		
		session.setAttribute(SessionAttributes.Language.name(), language); 
	}

	String judge = (String)session.getAttribute(JudgingServlet.SessionAttribute.Judge.name());
 %>

<head>
<link href="../base.css" rel="stylesheet" type="text/css">
</head>
<body>
	<%= language.getString("judge") %>: <%= Optional.ofNullable(judge).orElse("") %> 
	
<%
	boolean isNormalUser = !"admin".equals(judge);
	if(!isNormalUser || judge == null)
	{
%>
	<p>
	<a href="login.jsp">Login</a>
<%	
	}
 %>	
	<p>
	<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.GetCategories.name()%>">Judge</a>
	<p>
	<a href="getJudgingForm.jsp">Simple judging by looking at models...</a>
<%
	if(judge != null)
	{
%>
	<p>
	<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgingSummary.name()%>">List judging summary</a>
<%
	}
 %>
<%
	if(judge != null && !isNormalUser)
	{
%>
 	<p>
	 	<hr>
		<p>
		<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgings.name()%>">List judgings</a>
		<p>
		<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.DeleteJudgings.name()%>">Delete judgings</a>
<%	
	}
 %>
</body>