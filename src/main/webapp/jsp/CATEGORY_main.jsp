<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

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

ResourceBundle language = languageUtil.getLanguage("HU");
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
<table style="border: 0px; width: 100%">
	<tr>
		<td style="width: 100%;">
			<div>
				<img style="vertical-align: middle; height: 25mm"
					src="../RegistrationServlet/<%=RegistrationServlet.Command.LOADIMAGE.name()%>/<%=servlet.getLogoIDForShow(show)%>">

				<a href="../RegistrationServlet/inputForLogoUpload">Versenyhez
					log&oacute; felt&ouml;lt&eacute;s</a>
			</div>
		</td>

		<td style="width: 40px; text-align: right; vertical-align: top;">
			<div class="tooltip">
				<a href="../RegistrationServlet/logout"> <img
					src="../icons/exit.png" height="30" align="center" /> <span
					class="tooltiptext tooltiptext-right"> <%=language.getString("logout")%></span>
				</a>
			</div>
		</td>

		<%
		if (user.isSuperAdminUser()) {
		%>
		<td style="width: 40px; text-align: right; vertical-align: top;">
			<form accept-charset="UTF-8" name="input" id="input"
				action="../RegistrationServlet" method="post">
				<input type="hidden" id="command" name="command" value=""> <input
					type="hidden" name="language" value="HU">
				<div class="tooltip">
					<a href="#"
						onClick="document.getElementById('command').name='action';document.getElementById('command').value='modifyUser';document.getElementById('input').action='user.jsp';document.getElementById('input').submit();">
						<img src="../icons/modify2.png" height="30" align="center" /><span
						class="tooltiptext tooltiptext-right"> <%=language.getString("modify.user")%></span>
					</a>
				</div>
			</form>
		</td>
		<%
		}
		%>
	</tr>

	<tr>
		<td style="width: 100%; text-align: left; vertical-align: top;"><FONT
			COLOR='#ff0000'><b><%=show%></b></FONT></td>
	</tr>
</table>

<p></p>

<table style="box-shadow: none" border="0">
	<tr>
		<th style="background:none">1 makettez&#337;...</th>
		<td><a href="../RegistrationServlet/inputForLoginUser">nev&eacute;ben
				bel&eacute;p&eacute;s</a> - <a
			href="../RegistrationServlet/inputForPrint"> nevez&eacute;si
				lapjainak nyomtat&aacute;sa </a> - <a
			href="../RegistrationServlet/inputForPrint"> <a href="#"
				-			onClick="document.getElementById('command').value='inputForModifyModel';this.parentNode.submit();">Makett
					&aacute;tsorol&aacute;sa. Makett sorsz&aacute;ma:</a> <input
				type="number" name="modelID"
				onchange="document.getElementById('command').value='inputForModifyModel'">
		</a></td>
	</tr>
</table>
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
	<jsp:include page="ADMIN_lekerdezes.html" />
</p>
<p>
	<jsp:include page="ADMIN_adatkezeles.html" />
</p>