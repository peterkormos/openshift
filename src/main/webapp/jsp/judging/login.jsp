<%@page import="java.util.ResourceBundle"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="servlet.*" %>
    
<!DOCTYPE html>
<html>

<head>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> -->
<link href="../base.css" rel="stylesheet" type="text/css">
</head>

<jsp:useBean id="languageUtil" class="util.LanguageUtil" scope="application"/>
<%
	String languageCode = ServletUtil.getOptionalRequestAttribute(request, "language");

	ResourceBundle language = languageUtil.getLanguage(languageCode);
 %>
<body>
<form name='input' 
accept-charset="UTF-8" 
action="../../JudgingServlet/<%=JudgingServlet.RequestType.Login.name()%>"
method='POST' accept-charset="UTF-8" 
>
	<jsp:include page="fillableFormField.jsp">
	  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.Judge.name() %>"/>
	  <jsp:param name="caption" value='Judge'/>
	</jsp:include>
	<p>
	<%= language.getString("language") %>: 
 <jsp:include page="../language.jsp">
  <jsp:param name="parameterName" value="<%= JudgingServlet.RequestParameter.Language.name() %>"/>
  <jsp:param name="selectLabel" value=""/>
  <jsp:param name="selectValue" value=""/>
</jsp:include>
	<p>
<input type="submit" value='<%= language.getString("save") %>'>
</form>

</body>
</html>