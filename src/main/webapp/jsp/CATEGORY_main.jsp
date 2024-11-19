<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%

	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ServletDAO servletDAO = servlet.getServletDAO();
	User user = null;
	try {
		user = servlet.getUser(request);
	} catch (Exception ex) {
	}
	
	if (user == null || !user.isAdminUser()) {
		response.sendRedirect("index.jsp");
		return;
	}
%>

<link rel="stylesheet" href="base.css" media="screen" />
<script type="text/javascript" src="findUser.js"></script>
<script src="jquery.min.js"></script>

<!-- 
<link rel="stylesheet" href="base.css" media="screen" />
 -->

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
<img style="height: 25mm" src="../RegistrationServlet/<%=RegistrationServlet.Command.LOADIMAGE.name()%>/<%=servlet.getLogoIDForShow(show)%>">
	<form accept-charset="UTF-8" name="input" id="input"
		action="../RegistrationServlet" method="post">
		<input type="hidden" id="command" name="command" value=""> 
		<input type="hidden" name="language" value="HU">
		Verseny: <FONT COLOR='#ff0000'><b><%=show%></b></FONT> - 
<a href="../RegistrationServlet/inputForLogoUpload">Versenyhez
			log&oacute; felt&ouml;lt&eacute;s</a> 
<%
	if(user.isSuperAdminUser()) {
%>
			-
			<a href="#"
			onClick="document.getElementById('command').name='action';document.getElementById('command').value='modifyUser';document.getElementById('input').action='user.jsp';this.parentNode.submit();">Felhaszn&aacute;l&oacute;i
			adatok lek&eacute;rdez&eacute;se/m&oacute;dos&iacute;t&aacute;sa</a> 			
<%
	}
%>
			- 			
<a href="../RegistrationServlet/logout">Kijelentkez&eacute;s</a>
		<hr>
		<p></p>
		<strong><font size="+2"><u>1 makettez&#337;...</u> </font></strong>
<a href="../RegistrationServlet/inputForLoginUser">nev&eacute;ben
			bel&eacute;p&eacute;s</a> - 
			<a href="../RegistrationServlet/inputForPrint">
			nevez&eacute;si lapjainak nyomtat&aacute;sa </a> - 
			<a href="../RegistrationServlet/inputForPrint">
			<a href="#"
-			onClick="document.getElementById('command').value='inputForModifyModel';this.parentNode.submit();">Makett
			&aacute;tsorol&aacute;sa. Makett sorsz&aacute;ma:</a> <input type="number"
			name="modelID"
			onchange="document.getElementById('command').value='inputForModifyModel'">
	</form>

<p>
	<jsp:include page="ADMIN_elonevezes.jsp" />
</p>

<form accept-charset="UTF-8" name="input"
		action="../RegistrationServlet" method="post">
		<input type="hidden" name="command" value="setSystemParameter">
		<input type="hidden" name="paramName" value="SYSTEMMESSAGE">
		<textarea name="paramValue" cols="100" rows="3"><%=servlet.getSystemMessage()%></textarea>
		<input name="setSystemParameter" type="submit"
			value="Rendszer&#252;zenet be&aacute;ll&iacute;t&aacute;sa">
	</form>

<p>
	<jsp:include page="ADMIN_nyomtatas.html" />
</p>
<p>
	<jsp:include page="ADMIN_kategoria.html" />
</p>
<p>
	<jsp:include page="ADMIN_adatkezeles.html" />
</p>
<p>
	<jsp:include page="ADMIN_lekerdezes.html" />
</p>