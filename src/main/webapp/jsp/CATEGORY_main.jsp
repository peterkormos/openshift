<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="servlet.RegistrationServlet.RequestParameter"%>
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

String languageCode = RegistrationServlet.DEFAULT_LANGUAGE;
ResourceBundle language = languageUtil.getLanguage(languageCode);

String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	final List<String> shows = servletDAO.getShows();
	if (shows.isEmpty())
		show = RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE;
	else {
		show = shows.get(0);
	}
	session.setAttribute(RegistrationServlet.SessionAttribute.Show.name(), show);
}
%>

<link rel="stylesheet" href="base.css" media="screen" />
<script type="text/javascript" src="findUser.js"></script>
<script src="jquery.min.js"></script>

<body
	<%=request.getRequestURL().indexOf("localhost") > -1 ? "" : "style='background-color: #cff6c9;'"%>>
	<table style='border: 0px; width: 100%'>
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
					<input type="hidden" id="command" name="command" value="">
					<input type="hidden"
						name="<%=RequestParameter.Language.getParameterName()%>"
						value="<%=languageCode%>>">
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

	<form accept-charset="UTF-8" name="input" id="input4"
		action="../RegistrationServlet" method="post">
		<input type="hidden" id="command4" name="command" value=""> 
		<input
			type="hidden" id="paramName" name="paramName" value="">
		<input
			type="hidden" id="paramValue" name="paramValue" value="">

		<table style="box-shadow: none; border: 0px;">
			<tr>
				<th colspan="5">1 makettez&#337;...</th>
			</tr>

			<tr>
				<td><a href="../RegistrationServlet/inputForLoginUser">nev&eacute;ben
						bel&eacute;p&eacute;s</a></td>
				<td><a href="../RegistrationServlet/inputForPrint">
						nevez&eacute;si lapjainak nyomtat&aacute;sa </a></td>
			</tr>
			<tr>
				<td><a href="#"
					onClick="document.getElementById('command4').value='inputForModifyModel';document.getElementById('input4').submit();">Makett
						&aacute;tsorol&aacute;sa: </a></td>
				<td><input placeholder="Makett sorsz&aacute;ma" type="number"
					name="modelID"
					onchange="document.getElementById('command4').value='inputForModifyModel'">
				</td>
			</tr>

			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>

			<tr>
				<th colspan="5">El&otilde;nevez&eacute;s</th>
			</tr>
			<jsp:include page="ADMIN_elonevezes.jsp" />

			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>

			<tr>
				<th colspan="5"><input name="setSystemParameter" type="submit"
					onClick="document.getElementById('paramName').value='SYSTEMMESSAGE';document.getElementById('command4').value='setSystemParameter';"
					value="Rendszer&#252;zenet be&aacute;ll&iacute;t&aacute;sa"></th>
			</tr>
			<tr>
				<td colspan="2"><textarea name="paramValue" cols="100" rows="3"><%=servlet.getSystemMessage(show)%></textarea>
				</td>
			</tr>

			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>

			<tr>
				<th colspan="5">Nyomtat&aacute;s</th>
			</tr>
			<jsp:include page="ADMIN_nyomtatas.jsp" />


			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>

			<tr>
				<th colspan="5">&nbsp;</th>
			</tr>
			<jsp:include page="ADMIN_kategoria.jsp" />

			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>

			<jsp:include page="ADMIN_lekerdezes.jsp" />

			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr>
				<th colspan="5">Adatkezel&eacute;s</th>
			</tr>

			<p>
				<jsp:include page="ADMIN_adatkezeles.jsp" />
			</p>
		</table>
	</form>
</body>