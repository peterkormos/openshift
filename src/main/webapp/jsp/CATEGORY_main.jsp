<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
User user = null;
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = servlet.getServletDAO();
try {
	user = servlet.getUser(request);
} catch (Exception ex) {
}

if (user == null || !"CATEGORY".equals(user.language)) {
	response.sendRedirect("../index.jsp");
	return;
}
%>

<html>
<head>
<link rel="stylesheet" href="base.css" media="screen" />
<script type="text/javascript" src="findUser.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>

<!-- 
<link rel="stylesheet" href="base.css" media="screen" />
 -->

<body>
	<%
	String show = (String) session.getAttribute(RegistrationServlet.SessionAttribute.Show.name());
	if (show == null) {
		final List<String> shows = servletDAO.getShows();
		if (shows.isEmpty())
			show = ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
		else {
			show = shows.get(0);
			session.setAttribute(RegistrationServlet.SessionAttribute.Show.name(), show);
		}
	}
	%>
	<form accept-charset="UTF-8" name="input" id="input"
		action="../RegistrationServlet" method="post">
		<input type="hidden" id="command" name="command" value=""> 
		<input type="hidden" name="language" value="HU">
		Verseny: <FONT COLOR='#ff0000'><b><%=show%></b></FONT> - <a href="#"
			onClick="document.getElementById('command').value='inputForLogoUpload';this.parentNode.submit();">Versenyhez
			log&oacute; felt&ouml;lt&eacute;s</a> - <a
			href="#"
			onClick="document.getElementById('command').value='logout';this.parentNode.submit();">Kijelentkez&eacute;s</a>
		<hr>
		<p></p>
		<strong><font size="+2"><u>1 makettez&#337;...</u> </font></strong>
		<a href="#"
			onClick="document.getElementById('command').value='inputForLoginUser';this.parentNode.submit();">nev&eacute;ben
			bel&eacute;p&eacute;s</a> - <a href="#"
			onClick="document.getElementById('command').value='inputForPrint';this.parentNode.submit();">
			nevez&eacute;si lapjainak nyomtat&aacute;sa </a> - <a href="#"
			onClick="document.getElementById('command').value='inputForModifyModel';this.parentNode.submit();">Makett
			&aacute;tsorol&aacute;sa. Sorsz&aacute;m:</a> <input type="text"
			name="modelID"
			onchange="document.getElementById('command').value='inputForModifyModel'">
	</form>

	<div id="ADMIN_elonevezes"></div>
	<script>
		$(function() {
			$("#ADMIN_elonevezes").load("ADMIN_elonevezes.html");
		});
	</script>
	</p>

	Rendszer&#252;zenet:
	<FONT COLOR='#ff0000'><b><%=servlet.getSystemMessage()%></b></FONT>
	<p>
	<form accept-charset="UTF-8" name="input"
		action="../RegistrationServlet" method="post">
		<input type="hidden" name="command" value="setSystemParameter">
		<input type="hidden" name="paramName" value="SYSTEMMESSAGE">
		<textarea name="paramValue" cols="100" rows="5"></textarea>
		<input name="setSystemParameter" type="submit"
			value="Rendszer&#252;zenet">
	</form>

	<form accept-charset="UTF-8" name="input" id="input3"
		action="../RegistrationServlet" method="post">
		<input type="hidden" id="command3" name="command">

		<div id="ADMIN_nyomtatas"></div><script>
			$(function() {
				$("#ADMIN_nyomtatas").load("ADMIN_nyomtatas.html");
			});
		</script>
<p></p>
		<div id="ADMIN_kategoria"></div>
		<script>
			$(function() {
				$("#ADMIN_kategoria").load("ADMIN_kategoria.html");
			});
		</script>
		<p></p>
	</form>

	<div id="ADMIN_adatkezeles"></div>
	<script>
		$(function() {
			$("#ADMIN_adatkezeles").load("ADMIN_adatkezeles.html");
		});
	</script>
	<p></p>

	<div id="ADMIN_lekerdezes"></div>
	<script>
		$(function() {
			$("#ADMIN_lekerdezes").load("ADMIN_lekerdezes.html");
		});
	</script>

</body>
</html>
