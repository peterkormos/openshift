<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
User user = null;
try {
	user = RegistrationServlet.getUser(request);
} catch (Exception ex) {
	out.print(ex.getMessage());
	return;
}

RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = RegistrationServlet.getServletDAO();

ResourceBundle language = languageUtil.getLanguage(user.language);

String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	show = ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
}

	List<Model> models = servletDAO.getModels(user.getId());
	Map<Integer, Category> categories = (Map<Integer, Category>) ServletUtil.getSessionAttribute(request,
			RegistrationServlet.SessionAttribute.Categories.name());
	models = RegistrationServlet.getModelsForShow(show, models, categories);
%>
<html>
<head>

<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="base.css" rel="stylesheet" type="text/css">
</head>
<body>

	<div class="header"></div>

	<form name="input" id="input" onsubmit="myFunction()"
		action="../RegistrationServlet" method="put" accept-charset="UTF-8">
		<input type="hidden" id="command" name="command" value="">
		<table style="border: 0px; width: 100%">
			<tr>
				<td rowspan="2"><img style="height: 25mm"
					src="../RegistrationServlet/<%=RegistrationServlet.Command.LOADIMAGE.name()%>/<%=servlet.getLogoIDForShow(show)%>">
				</td>
				<td colspan="5" style="width: 100%; white-space: nowrap">
				<FONT
					COLOR='#ff0000'> <b> <%=show%>
					</b>
				</FONT>
				<br>
				<FONT
					COLOR='#ff0000'> <b> <%=servlet.getSystemMessage()%>
					</b>
				</FONT>
				</td>
			</tr>

			<tr>
				<%
				if (servlet.isRegistrationAllowed(show)) {
				%>
				<td style="white-space: nowrap; vertical-align: top;">
					<div class="tooltip">
						<a href="../RegistrationServlet/inputForAddModel"
						<%= models.isEmpty() ? "class='pulseBtn'" : ""%>
						> <img
							src="../icons/add.png" height="30" align="center" /> <span
							class="tooltiptext"> <%=language.getString("add")%></span>
							 <%=language.getString("add")%>
						</a>
					</div>
				</td>
				<%
				}
				%>

				<td style="white-space: nowrap; vertical-align: top;">
					<div class="tooltip">
						<a href="../RegistrationServlet/sendEmail"> <img
							src="../icons/email.png" height="30" align="center" /> <span
							class="tooltiptext"> <%=language.getString("send.email")%></span>
							 <%=language.getString("send.email")%>
						</a>
					</div>
				</td>

				<td style="width: 100%; white-space: nowrap"></td>

				<td style="width: 40px; text-align: right; vertical-align: top;">
					<div class="tooltip">
						<a href="../RegistrationServlet/logout"> <img
							src="../icons/exit.png" height="30" align="center" /> <span
							class="tooltiptext tooltiptext-right"> <%=language.getString("logout")%></span>
						</a>
					</div>
				</td>

				<td style="width: 40px; text-align: right; vertical-align: top;">
					<div class="tooltip">
						<a href="#"
							onClick="document.getElementById('command').name='action';document.getElementById('command').value='modifyUser';document.getElementById('input').action='user.jsp';document.getElementById('input').submit();">
							<img src="../icons/modify2.png" height="30" align="center" /><span
							class="tooltiptext tooltiptext-right"> <%=language.getString("modify.user")%></span>
						</a>
					</div>
				</td>
			</tr>
		</table>
	</form>
	<p></p>

	<%
	if (!(servlet.isPreRegistrationAllowed(show) || servlet.isOnSiteUse())) {
	%>
	<strong><font color='#FF0000'><%=language.getString("pre-registration.closed")%></font></strong>
	<%
	}
	%>


	<jsp:include page="notices.jsp" />

	<p></p>
	<!--
  <a href="#" onClick="document.getElementById('command').value='inputForPhotoUpload';document.getElementById('input').submit();">
  <img src="../icons/photo.png" height="30" align="center">language.getString("photo")to")%>
  </a>
 
<p></p>
   -->

	<%-- 
  <a href="#" onClick="document.getElementById('command').value='listMyModels';document.getElementById('input').submit();">
  <img src="../icons/list.png" height="30" align="center"> <%=language.getString("list.models")%></a>

<p></p>
 --%>

	<jsp:include page="ADMIN_helyi.jsp" />

	<jsp:include page="listMyModels.jsp" />

</body>
</html>
