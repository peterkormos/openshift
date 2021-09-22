<%@page import="java.util.*" %>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil" scope="application"/>

<%
    ResourceBundle language = (ResourceBundle)session.getAttribute(CommonSessionAttribute.Language.name());
	 
	if(language == null)
	{
		final String languageCode = ServletUtil.getOptionalRequestAttribute(request, JudgingServlet.RequestParameter.Language.name());
		language = languageUtil.getLanguage(languageCode);
		
		session.setAttribute(CommonSessionAttribute.Language.name(), language); 
	}

	String judge = (String)session.getAttribute(JudgingServlet.SessionAttribute.Judge.name());
%>

<head>
<link href="../base.css" rel="stylesheet" type="text/css">
</head>
<body>
	
<%
	boolean isNormalUser = !"admin".equals(judge);
//	if(!isNormalUser || judge == null)
	{
%>
<!-- 	<a href="login.jsp">Login</a> -->
<form name='input' 
accept-charset="UTF-8" 
action="../../JudgingServlet/<%=JudgingServlet.RequestType.Login.name()%>"
method='POST' accept-charset="UTF-8" 
style="background: LightGrey; padding: 5px;"
>
	<jsp:include page="fillableFormField.jsp">
	  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.Judge.name() %>"/>
	  <jsp:param name="caption" value='<%= language.getString("judge") %>'/>
	  <jsp:param name="value" value='<%= Optional.ofNullable(judge).orElse("") %>'/>
	</jsp:include>
	
	<%= language.getString("language") %>: 
 <jsp:include page="../language.jsp">
  <jsp:param name="parameterName" value="<%= JudgingServlet.RequestParameter.Language.name() %>"/>
  <jsp:param name="selectLabel" value=""/>
  <jsp:param name="selectValue" value=""/>
  <jsp:param name="required" value="required"/>
</jsp:include>
	
<input type="submit" value='<%= language.getString("login") %>'>
</form>
<%	
	}
 %>	
	<p>
	<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.GetCategories.name()%>">
	<img src="../../icons/add.png" height="30" align="center"> <%= language.getString("judging.type.form") %></a>
	<p>
	<a href="getJudgingForm.jsp">
	<img src="../../icons/add.png" height="30" align="center">
	<%= language.getString("judging.type.looking") %></a>
<%
	if(judge != null)
	{
%>
	<p>
	<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgingSummary.name()%>">
	<img src="../../icons/list.png" height="30" align="center">
	<%= language.getString("list.models") %></a>
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
		<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgings.name()%>">
		<img src="../../icons/list.png" height="30" align="center">
		List judgings</a>
		<p>
		<a href="../../JudgingServlet/<%=JudgingServlet.RequestType.DeleteJudgings.name()%>">
		<img src="../../icons/delete2.png" height="30" align="center">
		Delete judgings</a>
<%	
	}
 %>
 <p>
 <img src="../../RegistrationServlet">
</body>