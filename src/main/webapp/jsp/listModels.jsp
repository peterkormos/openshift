<%@page import="datatype.Detailing.DetailingCriteria"%>
<%@page import="datatype.Detailing.DetailingCriteria"%>
<%@page import="datatype.Detailing.DetailingGroup"%>
<%@page import="servlet.*"%>
<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="util.*"%>

<%@include file="util.jsp"%>

<%
    highlightStart = 0xEAEAEA;

  RegistrationServlet servlet = RegistrationServlet.getInstance(config);
  ServletDAO servletDAO = servlet.getServletDAO();
  User user = servlet.getUser(request);

  final ResourceBundle language = (ResourceBundle)session.getAttribute(CommonSessionAttribute.Language.name());

  boolean insertAwards = Boolean.parseBoolean(ServletUtil.getRequestAttribute(request, "insertAwards", false));
  boolean withDetailing = Boolean.parseBoolean(ServletUtil.getRequestAttribute(request, "withDetailing", false));
  boolean onlyPhotos = Boolean.parseBoolean(ServletUtil.getRequestAttribute(request, "onlyPhotos", false));

  List<Model> models = (List<Model>) session.getAttribute(RegistrationServlet.SessionAttribute.Models.name());
%>

<table border=0>
	<tr>
		<%
		  if (insertAwards)
		  {
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("award")%>
		</th>
		<%
		  }
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("show")%>
		</th>

<!-- 
 		<%
		  if (withDetailing)
		  {
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("email")%>
		</th>
		<%
		  }
		%>
 -->
		<%
		  if (!withDetailing)
		  {
		%>

		<th align='center' style='white-space: nowrap'><%=language.getString("name")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("city")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("country")%>
		</th>
		<%
		  }
		%>

		<%
		  if (!insertAwards)
		  {
				if (onlyPhotos)
				{
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("photo")%>
		</th>
		<%
		  }
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("userID")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("modelID")%>
		</th>
		<%
		  }
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("category.code")%>
		</th>
		<th align='center' style='white-space: nowrap'><%=language.getString("models.name")%>
		</th>

		<%
		  if (!insertAwards)
		  {
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("scale")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("models.identification")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("models.markings")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("models.producer")%>
		</th>

		<%
		  }
		%>


		<th align='center' style='white-space: nowrap'><%=language.getString("category.description")%>
		</th>

		<%
		  if (!insertAwards && withDetailing)
		  {
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("glued.to.base")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("comment")%>
		</th>

		<%
		  if (withDetailing)
				{
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("models.detailing")%>
		</th>

		<%
		  }
		  }
		%>

	</tr>

	<%
	  for (final Model model : models)
	  {
			final Category category = servletDAO.getCategory(model.categoryID);

			if (onlyPhotos)
			{
			  try
			  {
				servletDAO.loadImage(model.modelID);
			  }
			  catch (Exception ex)
			  {
				continue;
			  }
			}
	%>
	<tr bgcolor="<%=highlight()%>">

		<%
		  final User modelsUser = servletDAO.getUser(model.userID);
				if (insertAwards)
				{
		%>
		<td align='center'><%=model.award%></td>
		<%
		  }
		%>
		<td align='center' style='white-space: nowrap'><%=category.group.show%>
		</td>
<!-- 
		<%
		  if (withDetailing)
		  {
		%>
		<td align='center'><%=modelsUser.email%></td>
		<%
		  }
		%>
 -->
		<%
		  if (!withDetailing)
		  {
		%>
		<td align='center'><%=modelsUser.lastName%></td>

<%-- 		<td align='center'><%=modelsUser.firstName%></td> --%>

		<td align='center'><%=modelsUser.city%></td>

		<td align='center'><%=modelsUser.country%></td>
		<%
		  }
		%>

		<%
		  if (!insertAwards)
				{
				  if (onlyPhotos)
				  {
		%>
		<td align='center' style='white-space: nowrap'><img
			alt='<%=category.categoryCode%> - <%=model.modelID%>.jpg'
			src='<%=servlet.getServletURL(request)%>/<%=RegistrationServlet.Command.LOADIMAGE.name()%>/<%=model.modelID%>'>
		</td>
		<%
		  }
		%>
		<td align='center'><%=model.userID%></td>

		<td align='center'><%=model.modelID%></td>
		<%
		  }
		%>
		<td align='center' style='white-space: nowrap'><%=category.categoryCode%>
		</td>

		<td align='center' style='white-space: nowrap'><%=model.name%></td>

		<%
		  if (!insertAwards)
				{
		%>
		<td align='center'><%=model.scale%></td>

		<td align='center' style='white-space: nowrap'><%=model.identification%>
		</td>

		<td align='center' style='white-space: nowrap'><%=model.markings%>
		</td>

		<td align='center' style='white-space: nowrap'><%=model.producer%>
		</td>

		<%
		  }
		%>

		<td align='center' style='white-space: nowrap'><%=category.categoryDescription%>
		</td>

		<%
		  if (!insertAwards && withDetailing)
				{
		%>
		<td align='center'><%=RegistrationServlet.getGluedToBaseHTMLCode(language, model, "..")%></td>

		<td align='center'><%=model.comment%></td>

		<%
		  if (withDetailing)
				  {
		%>
		<td><table cellpadding='5' border='1'>
				<tr>
					<td>&nbsp;</td>

					<%
					for (DetailingGroup group : DetailingGroup.values())
								{
					%>
					<td><%=language.getString("detailing." + group.name())%>
					</td>
					<%
					  }
					%>
				</tr>

				<%
				for (DetailingCriteria criteria : DetailingCriteria.values())
							{
						if(!criteria.isVisible())
							continue;
				%>
				<tr>
					<td><%=language.getString("detailing." + criteria.name())%>
					</td>

					<%
					for (DetailingGroup group : DetailingGroup.values())
								  {
					%>

					<td><input type='checkbox'
						<%=(model.getDetailingGroup(group).getCriteria(criteria) ? "checked" : "")%>></td>
					<%
					  }
					%>
				</tr>
				<%
				  }
				%>
			</table></td>
		<%
		  }
				}
		%>

	</tr>
	<%
	  }
	%>

</table>
