<%@page import="datatype.DetailingCriteria"%>
<%@page import="datatype.DetailingGroup"%>
<%@page import="servlet.*"%>
<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="util.*"%>

<%@include file="util.jsp"%>

<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ServletDAO servletDAO = servlet.getServletDAO();

	final ResourceBundle language = (ResourceBundle) session
			.getAttribute(CommonSessionAttribute.Language.name());

	String actionPathPrefix = ServletUtil.getOptionalAttribute(request, "actionPathPrefix").orElse("");
	
	boolean insertAwards = Boolean
			.parseBoolean(ServletUtil.getRequestAttribute(request, "insertAwards", false));
	boolean withDetailing = Boolean
			.parseBoolean(ServletUtil.getRequestAttribute(request, "withDetailing", false));
	boolean onlyPhotos = Boolean.parseBoolean(ServletUtil.getRequestAttribute(request, "onlyPhotos", false));
	boolean forJudges = Boolean.parseBoolean(
			ServletUtil.getRequestAttribute(request, JudgingServlet.RequestParameter.ForJudges.name(), false));

	boolean filterToOversized = ServletUtil.isCheckedIn(request, "filterToOversized");
  List<Model> models = (List<Model>) session.getAttribute(RegistrationServlet.SessionAttribute.Models.name());
  
  String show = RegistrationServlet.getShowFromSession(session);
  if (show == null)
  {
    show = ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
  }
%>

<table style='width: 100%; border-collapse: collapse;' border='1'>
	<tr>
		<th align='center' style='white-space: nowrap'></th>
		<%
			if (!forJudges) {
				if (insertAwards) {
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("award")%>
		</th>
		<%
			}
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("show")%>
		</th>

		<%
			if (withDetailing) {
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("judge")%>
		</th>
		<%
			}
		%>
		<%
			if (!withDetailing) {
		%>

		<th align='center' style='white-space: nowrap'><%=language.getString("name")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("city")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("country")%>
		</th>
		<%
			}
			}
		%>

		<%
			if (!insertAwards) {
				if (onlyPhotos) {
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
			if (!insertAwards) {
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
			if (!insertAwards && withDetailing) {
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("glued.to.base")%>
		</th>

		<th align='center' style='white-space: nowrap'><%=language.getString("comment")%>
		</th>

		<%
			if (withDetailing) {
		%>
		<th align='center' style='white-space: nowrap'><%=language.getString("models.detailing")%>
		</th>
		<%
			}
			}
		%>

		<th align='center' style='white-space: nowrap'><%=language.getString("models.width")%>
		</th>
		<th align='center' style='white-space: nowrap'><%=language.getString("models.length")%>
		</th>
		<th align='center' style='white-space: nowrap'></th>
	</tr>

	<%
		for (final Model model : models) {
			if(filterToOversized && !model.isOversized()) {
				continue;
			}
			
			final Category category = servletDAO.getCategory(model.categoryID);
			
			if (onlyPhotos) {
				try {
					servletDAO.loadImage(model.getId());
				} catch (Exception ex) {
					continue;
				}
			}
	%>
	<tr bgcolor="<%= highlight(model.isOversized())%>">
		<td>
<%
  if (servlet.isRegistrationAllowed(show))
  {
%>
			<div class="tooltip">
				<a
					href="<%=actionPathPrefix%>../RegistrationServlet?command=inputForModifyModel&modelID=<%=model.getId()%>">
					<img src="<%=actionPathPrefix%>../icons/add.png" height="30" align="center" /> <span
					class="tooltiptext"> <%=language.getString("modify")%></span>
				</a>
			</div>

			<div class="tooltip">
				<a
					href="<%=actionPathPrefix%>../RegistrationServlet?command=deleteModel&modelID=<%=model.getId()%>">
					<img src="<%=actionPathPrefix%>../icons/delete2.png" height="30" align="center" /> <span
					class="tooltiptext"> <%=language.getString("delete")%></span>
				</a>
			</div>
<%
}
%>
		</td>

		<%
			final User modelsUser = servletDAO.getUser(model.userID);
				if (!forJudges) {
					if (insertAwards) {
		%>
		<td align='center'><%=servletDAO.getAward(model)%></td>
		<%
			}
		%>
		<td align='center' style='white-space: nowrap'><%=category.group.show%>
		</td>
		<%
			if (withDetailing) {
		%>
		<td align='center'>
			<%
				for (String judge : servlet.judgingServletDAO.getJudges(category.categoryCode, model.getId(),
									model.userID)) {
			%> <a
			href="<%=actionPathPrefix%>../JudgingServlet/<%=JudgingServlet.RequestType.GetJudgingSheet.name()%>?<%=JudgingServlet.RequestParameter.UserID%>=<%=model.getUserID()%>&<%=JudgingServlet.RequestParameter.ModellerID%>=<%=model.userID%>&<%=JudgingServlet.RequestParameter.Category%>=<%=category.categoryCode%>&<%=JudgingServlet.RequestParameter.Judge%>=<%=java.net.URLEncoder.encode(judge)%>"><%=judge%></a>

			<%
				}
			%>
		</td>
		<%
			}
		%>
		<%
			if (!withDetailing) {
		%>
		<td align='center'><%=modelsUser.lastName%></td>

		<%-- 		<td align='center'><%=modelsUser.firstName%></td> --%>

		<td align='center'><%=modelsUser.city%></td>

		<td align='center'><%=modelsUser.country%></td>
		<%
			}
				}
		%>

		<%
			if (!insertAwards) {
					if (onlyPhotos) {
		%>
		<td align='center' style='white-space: nowrap'><img
			alt='<%=category.categoryCode%> - <%=model.getId()%>.jpg'
			src='<%=servlet.getServletURL(request)%>/<%=RegistrationServlet.Command.LOADIMAGE.name()%>/<%=model.getId()%>'>
		</td>
		<%
			}
		%>
		<td align='center'><%=model.userID%></td>

		<td align='center'><%=model.getId()%></td>
		<%
			}
		%>
		<td align='center' style='white-space: nowrap'><%=category.categoryCode%>
		</td>

		<td align='center' style='white-space: nowrap'><%=model.name%></td>

		<%
			if (!insertAwards) {
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
			if (!insertAwards && withDetailing) {
		%>
		<td align='center'><%=RegistrationServlet.getGluedToBaseHTMLCode(language, model, "..")%></td>

		<td align='center'><%=model.comment%></td>

		<%
			if (withDetailing) {
		%>
		<td><table cellpadding='5' style='border-collapse: collapse'
				border='1'>
				<tr>
					<td>&nbsp;</td>

					<%
						for (DetailingGroup group : DetailingGroup.values()) {
					%>
					<td><%=language.getString("detailing." + group.name())%></td>
					<%
						}
					%>
				</tr>

				<%
					for (DetailingCriteria criteria : DetailingCriteria.values()) {
									if (!criteria.isVisible())
										continue;
				%>
				<tr>
					<td><%=language.getString("detailing." + criteria.name())%></td>

					<%
						for (DetailingGroup group : DetailingGroup.values()) {
					%>

					<td align="center"><%=(model.isDetailed(group, criteria) ? "X" : "")%></td>
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

		<td align='center' style='white-space: nowrap'><%=String.valueOf(model.getWidth())%>
		</td>
		<td align='center' style='white-space: nowrap'><%=String.valueOf(model.getLength())%>
		</td>
		<td>
<%
  if (servlet.isRegistrationAllowed(show))
  {
%>
			<div class="tooltip">
				<a
					href="<%=actionPathPrefix%>../RegistrationServlet?command=inputForModifyModel&modelID=<%=model.getId()%>">
					<img src="<%=actionPathPrefix%>../icons/add.png" height="30" align="center" /> <span
					class="tooltiptext"> <%=language.getString("modify")%></span>
				</a>
			</div>

			<div class="tooltip">
				<a
					href="<%=actionPathPrefix%>../RegistrationServlet?command=deleteModel&modelID=<%=model.getId()%>">
					<img src="<%=actionPathPrefix%>../icons/delete2.png" height="30" align="center" /> <span
					class="tooltiptext"> <%=language.getString("delete")%></span>
				</a>
			</div>
<%
}
%>
		</td>
	</tr>
	<%
		}
	%>

</table>
