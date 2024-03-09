<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
	User user = null;
	    RegistrationServlet servlet = RegistrationServlet.getInstance(config);
		ServletDAO servletDAO = servlet.getServletDAO();
	try 
	{
		user = servlet.getUser(request);
	}
	catch(Exception ex) {
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
		Verseny: <FONT COLOR='#ff0000'><b><%=show%></b></FONT>
			- <a
			href="#"
			onClick="document.getElementById('command').value='inputForLogoUpload';this.parentNode.submit();">Versenyhez log&oacute; felt&ouml;lt&eacute;s</a>
		 - <input
			type="hidden" id="command" name="command" value=""> <input
			type="hidden" name="language" value="HU"> <a href="#"
			onClick="document.getElementById('command').name='action';document.getElementById('command').value='modifyUser';document.getElementById('input').action='user.jsp';this.parentNode.submit();">Felhaszn&aacute;l&oacute;i
			adatok lek&eacute;rdez&eacute;se/m&oacute;dos&iacute;t&aacute;sa</a> 			
			- <a
			href="#"
			onClick="document.getElementById('command').value='logout';this.parentNode.submit();">Kijelentkez&eacute;s</a>
	</form>

	<form accept-charset="UTF-8" name="input"
	id="input3"
		action="../RegistrationServlet" method="post">
		<input type="hidden" id="command3" name="command">

		<div id="ADMIN_kategoria"></div>
		<script>
			$(function() {
				$("#ADMIN_kategoria").load("ADMIN_kategoria.html");
			});
		</script>
		<p></p>
	</form>
</body>
</html>
