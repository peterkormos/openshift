<%@page import="servlet.RegistrationServlet.Command"%>
<%@page import="java.util.List"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%@include file="../util.jsp"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
List<AwardedModel> awardedModels = RegistrationServlet.servletDAO.getAwardedModels();
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="../base.css" media="screen">
</head>
<body>
	<table style='width: 100%; border-collapse: collapse;' border='1'>
		<tr>
			<th width="25%">Kateg&oacute;ria</th>
			<th width="25%">Makett</th>
			<th width="25%">Makettez&otilde;</th>
			<th width="25%">Helyez&eacute;s</th>
		</tr>
		<%
		List<Category> categories = RegistrationServlet.servletDAO
				.getCategoryList(RegistrationServlet.getShowFromSession(session));

		final String CATEGORY_ID = "categoryID";
		String categoryID = ServletUtil.getOptionalRequestAttribute(request, CATEGORY_ID);

		if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(categoryID)) {
			categories.clear();
			categories.add(RegistrationServlet.servletDAO.getCategory(Integer.parseInt(categoryID)));
		}

		for (Category category : categories) {
		%>
		<%
		for (AwardedModel awardedModel : awardedModels) {
			if (awardedModel.categoryID != category.getId())
				continue;
		%>
		<tr bgcolor="<%=highlight()%>">
			<td align="center"><%=category.categoryCode%> - <%=category.categoryDescription%></td>
			<td align="center"><%=awardedModel.name%></td>
			<td align="center"><%=RegistrationServlet.servletDAO.getUser(awardedModel.getUserID()).getFullName()%></td>
			<td align="center"><%=awardedModel.getAward()%></td>
		</tr>
		<%
		}
		%>
		<%
		}
		%>
	</table>

</body>
</html>