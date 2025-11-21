<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);

User user = null;
try {
	user = servlet.getUser(request);
} catch (Exception ex) {
}

if (user == null || !user.isAdminUser()) {
	response.sendRedirect("index.jsp");
	return;
}

final ResourceBundle language = servlet.getLanguageForCurrentUser(request);
%>

<head>
<link rel="stylesheet" href="base.css" media="screen" />
<script type="text/javascript" src="findUser.js"></script>
</head>

<body
	<%=request.getRequestURL().indexOf("localhost") > -1 ? "" : "style='background-color: #cff6c9;'"%>>

	<table style='border: 0px; width: 100%'>
		<tr>
			<td style="width: 100%;"></td>

			<td style="width: 40px; text-align: right; vertical-align: top;">
				<div class="tooltip">
					<a href="../RegistrationServlet/logout"> <img
						src="../icons/exit.png" height="30" align="center" /> <span
						class="tooltiptext tooltiptext-right"> <%=language.getString("logout")%></span>
					</a>
				</div>
			</td>
		</tr>
	</table>
	<p>
		<jsp:include page="ADMIN_mesteroklevel.jsp" />
	</p>
</body>