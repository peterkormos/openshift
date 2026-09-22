<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="servlet.RegistrationServlet"%>
<link rel="stylesheet" href="base.css" media="screen" />
<body>
	<form action="../RegistrationServlet" method="get">
		<input name="command" value="login" type="hidden">
		<table border="0" height="100%" width="100%">
			<tr>
				<td align="center" valign="middle">
					<table border="0">
						<jsp:include page="shows.jsp">
							<jsp:param name="adminLogin" value="true" />
						</jsp:include>
						<input
							name="<%=RegistrationServlet.RequestParameter.Language.getParameterName()%>"
							value="<%=RegistrationServlet.DEFAULT_LANGUAGE%>>" type="hidden">
						<tr>
							<td colspan="2">email: <input name="email">
							</td>
						</tr>
						<tr>
							<td colspan="2">password: <input name="password">
							</td>
						</tr>

						</tr>
						<tr>
							<td colspan="2"><input type="submit"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>