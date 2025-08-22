<%@page import="servlet.RegistrationServlet.Command"%>
<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>


<%
final String CATEGORY_ID = "categoryID";

RegistrationServlet servlet = RegistrationServlet.getInstance(config);
%>
<head>
<link rel="stylesheet" href="../base.css" media="screen" />
</head>
<body>
	<p>
		<font size="+1">Kateg&oacute;ri&aacute;k</font>
	</p>
	<p>
		<%
		Map<Integer,List<AwardedModel>> awardedModels = RegistrationServlet.servletDAO.getAwardedModelsMap();

		List<Category> categories = RegistrationServlet.servletDAO
				.getCategoryList(RegistrationServlet.getShowFromSession(session));

		for (Category category : categories) {
		%>
		<a href="awardedModels.jsp?<%=CATEGORY_ID%>=<%=category.getId()%>"><%=category.categoryCode%>
			- <%=category.categoryDescription%></a> <br>
		<%
		}

		String categoryID = ServletUtil.getOptionalRequestAttribute(request, CATEGORY_ID);

		if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(categoryID)) {
		categories.clear();
		categories.add(RegistrationServlet.servletDAO.getCategory(Integer.parseInt(categoryID)));
		}

		for (Category category : categories) {
			if (!awardedModels.containsKey(category.getId()))
				continue;
		%>
	
	<p>
		<font size="+1"><%=category.categoryCode%> - <%=category.categoryDescription%></font>
	</p>
	<table style='width: 100%; border-collapse: collapse;' border='1'>
		<tr>
			<th width="25%">Makett</th>
			<th width="25%">Makettez&otilde;</th>
			<th width="25%">Helyez&eacute;s</th>
			<%
			//				  if (RegistrationServlet.onSiteUse)
			{
			%>
			<th width="25%">K&eacute;p</th>
			<%
			}
			%>
		</tr>
		<%
		for (AwardedModel awardedModel : awardedModels.get(category.getId())) {
		%>
		<tr>
			<td align="center"><%=awardedModel.name%></td>
			<td align="center"><%=RegistrationServlet.servletDAO.getUser(awardedModel.getUserID()).getFullName()%></td>
			<td align="center"><%=awardedModel.getAward()%></td>
			<%
			//				  if (RegistrationServlet.onSiteUse)
			{
			%>
			<td align="center"><img
				src='<%=servlet.getServletURL(request)%>/<%=Command.LOADIMAGE.name()%>/<%=awardedModel.getId()%>'>
			</td>
			<%
			}
			%>
		</tr>
		<%
		}
		%>
	</table>
	<%
	}
	%>

</body>
</html>