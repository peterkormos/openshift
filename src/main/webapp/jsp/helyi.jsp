<%@page import="java.io.*"%>
<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="util.*"%>

<%@include file="util.jsp"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<html>
<head>
<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="./base.css" media="screen" />
</head>
<body>
	<div class="header"></div>
	<p>
		<a href="./login.jsp?<%=RequestParameter.Language.getParameterName()%>=HU"><b>F&#337;oldali
				bejelentkez&eacute;s</b></a>
	</p>
	<p></p>
	<p>
		<%
		addAdminLink(session, out, "./user.jsp?directRegister=true&"+RequestParameter.Action.getParameterName()+"=directRegister&" + RequestParameter.Language.getParameterName() + "=HU", "Regisztr&aacute;lni egy (tal&aacute;n) ismeretlen makettez&#337;t &eacute;s makettjeit");
		%>

<!-- 		- <a -->
<!-- 			href="../RegistrationServlet?command=getbatchAddModelPage&" + RequestParameter.Language.getParameterName() + "=HU">t&ouml;bb -->
<!-- 			ember makettjeit</a> -->
	</p>
	<p>
		<b>Egy m&aacute;r regisztr&aacute;lt makettez&#337;... </b>
		<%
		addAdminLink(session, out, "../RegistrationServlet/inputForLoginUser?" + RequestParameter.Language.getParameterName() + "=HU",
				"nev&eacute;ben bel&eacute;p&eacute;s");
		%>
		-
		<%
		addAdminLink(session, out, "../RegistrationServlet/inputForPrint?" + RequestParameter.Language.getParameterName() + "=HU",
				"nevez&eacute;si lapjainak nyomtat&aacute;sa");
		%>
	</p>
	<p>
		<a href="./judging/judging.jsp?" + RequestParameter.Language.getParameterName() + "=HU"><b>Zs&utilde;riz&eacute;s</b></a>
	</p>
</body>
</html>
