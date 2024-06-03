<%@page import="servlet.RegistrationServlet.Command"%>
<%@page import="java.util.List"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>


<%
  final String CATEGORY_ID = "categoryID";

  RegistrationServlet servlet = RegistrationServlet.getInstance(config);
%>
<body>
	<hr>
	<p>
		<font size="+1">Kateg&oacute;ri&aacute;k</font>
	</p>
	<p>
		<%
		  List<AwardedModel> awardedModels = RegistrationServlet.servletDAO.getAwardedModels();

		  List<Category> categories = RegistrationServlet.servletDAO.getCategoryList(RegistrationServlet.getShowFromSession(session));

		  for (Category category : categories)
		  {
		%>
		<a href="awardedModels.jsp?<%=CATEGORY_ID%>=<%=category.getId()%>"><%=category.categoryCode%>
			- <%=category.categoryDescription%></a> <br>
		<%
		  }

		  String categoryID = ServletUtil.getOptionalRequestAttribute(request, CATEGORY_ID);

		  if (!ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(categoryID))
		  {
				categories.clear();
				categories.add(RegistrationServlet.servletDAO.getCategory(Integer.parseInt(categoryID)));
		  }

		  for (Category category : categories)
		  {
		%>
	
	<hr>
	<p>
		<font size="+1">Kateg&oacute;ria: <%=category.categoryCode%> -
			<%=category.categoryDescription%></font>
	</p>
	<table width="100%" border="1">
		<tr>
			<td>
				<table width="100%" border="0">
					<tr>
						<th width="25%">[Makett]</th>
						<th width="25%">[Makettez&otilde;]</th>
						<th width="25%">[Helyez&eacute;s]</th>
						<%
						  //				  if (RegistrationServlet.onSiteUse)
								{
						%>
						<th width="25%">[K&eacute;p]</th>
						<%
						  }
						%>
					</tr>
					<%
					  for (AwardedModel awardedModel : awardedModels)
							{
							  if (awardedModel.categoryID != category.getId())
								continue;
					%>
					<tr>
						<td align="center"><%=awardedModel.name%></td>
						<td align="center"><%=RegistrationServlet.servletDAO.getUser(awardedModel.userID).getFullName()%></td>
						<td align="center"><%=awardedModel.award%></td>
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
			</td>
		</tr>
	</table>
	<%
	  }
	%>

</body>
</html>