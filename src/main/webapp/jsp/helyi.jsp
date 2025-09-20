<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

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
		<a href="./login.jsp?language=HU"><b>F&#337;oldali
				bejelentkez&eacute;s</b></a>
	</p>
	<p></p>
	<p>
		<b>Nevezni... </b> <a
			href="./user.jsp?directRegister=true&action=directRegister&language=HU">1
			ember makettjeit</a> - <a
			href="../RegistrationServlet?command=getbatchAddModelPage&language=HU">t&ouml;bb
			ember makettjeit</a>
	</p>
	<%
	if (session.isNew()) {
		String show = RegistrationServlet.getShowFromSession(session);
		ServletDAO servletDAO = RegistrationServlet.getServletDAO();
		if (show == null) {
			final List<String> shows = servletDAO.getShows();
			if (shows.isEmpty())
				show = RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE;
			else {
				show = shows.get(0);
				session.setAttribute(RegistrationServlet.SessionAttribute.Show.name(), show);
			}
		}
	} 
	%>
	<p>
		<b>1 makettez&#337;... </b> <a
			href="../RegistrationServlet/inputForLoginUser?language=HU">
			nev&eacute;ben bel&eacute;p&eacute;s</a> - <a
			href="../RegistrationServlet/inputForPrint?language=HU">
			nevez&eacute;si lapjainak nyomtat&aacute;sa </a>
	</p>
	<p>
		<a href="./judging/judging.jsp?language=HU"><b>Zs&utilde;riz&eacute;s</b></a>
	</p>
</body>
</html>
