<%@page import="datatype.DetailingCriteria"%>
<%@page import="datatype.DetailingGroup"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
	final User user = RegistrationServlet.getUser(request);

	final RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	final ResourceBundle language = (ResourceBundle) session
			.getAttribute(CommonSessionAttribute.Language.name());
	final ServletDAO servletDAO = servlet.getServletDAO();

	final Model model = (Model) session.getAttribute(RegistrationServlet.SessionAttribute.Model.name());
	final Category category = servletDAO.getCategory(model.categoryID);
	String show = RegistrationServlet.getShowFromSession(session);
	if (show == null) {
		show = ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
	}

	boolean insertAwards = Boolean
			.parseBoolean(ServletUtil.getRequestAttribute(request, "insertAwards", false));
	boolean withDetailing = Boolean
			.parseBoolean(ServletUtil.getRequestAttribute(request, "withDetailing", false));
	boolean onlyPhotos = Boolean.parseBoolean(ServletUtil.getRequestAttribute(request, "onlyPhotos", false));
	boolean forJudges = Boolean.parseBoolean(
			ServletUtil.getRequestAttribute(request, JudgingServlet.RequestParameter.ForJudges.name(), false));

	boolean firstModel = Boolean.parseBoolean(request.getParameter("firstModel"));
%>

<table style="border: 1px solid black">
	<tr>
		<td>
			<%
				if (servlet.isRegistrationAllowed(show)) {
			%>
			<div class="tooltip">
				<a
											<%= firstModel ? "class='pulseBtn'" : ""%>
					href="../RegistrationServlet?command=inputForModifyModel&modelID=<%=model.getId()%>">
					<img src="../icons/add.png" height="30" align="center" 
					/> <span
					class="tooltiptext"> <%=language.getString("modify")%></span>
					 <%=language.getString("modify")%>
				</a>
			</div>

			<div class="tooltip">
				<a
											<%= firstModel ? "class='pulseBtn'" : ""%>
					href="../RegistrationServlet?command=deleteModel&modelID=<%=model.getId()%>">
					<img src="../icons/delete2.png" height="30" align="center" 
					/> <span
					class="tooltiptext"> <%=language.getString("delete")%></span>
					 <%=language.getString("delete")%>
				</a>
			</div> <%
 	}
 %> <%
 	List<String> judges = servlet.judgingServletDAO.getJudges(category.categoryCode, model.getId(),
 			model.getUserID());
 	if (!judges.isEmpty()) {
 %><p> <%=language.getString("judge")%>: <%
 	}
 	for (String judge : judges) {
 %><br> <a
			href="../JudgingServlet/<%=JudgingServlet.RequestType.GetJudgingSheet.name()%>?<%=JudgingServlet.RequestParameter.ModelID%>=<%=model.getId()%>&<%=JudgingServlet.RequestParameter.ModellerID%>=<%=model.getUserID()%>&<%=JudgingServlet.RequestParameter.Category%>=<%=category.categoryCode%>&<%=JudgingServlet.RequestParameter.Judge%>=<%=java.net.URLEncoder.encode(judge)%>"><%=judge%></a>

			<%
				}
			%>
		</td>
	</tr>
	<tr>
		<td>
			<table style="border-collapse: collapse">
				<tr>
					<td style="border-bottom: 1px solid; border-bottom-style: dashed;">
						<table style="box-shadow: none; height: 100%; width: 100%">
							<tr>
								<td style="white-space: nowrap;"><%=language.getString("glued.to.base")%></td>

								<td><font><%=RegistrationServlet.getGluedToBaseHTMLCode(language, model, "..")%></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td><table style="box-shadow: none; height: 100%; width: 100%">
							<tr>
								<td valign="top"><%=language.getString("userID")%></td>
								<td valign="top"><%=language.getString("modelID")%></td>
								<td valign="top"><%=language.getString("scale")%></td>

								<td valign="top"><%=language.getString("category.code")%></td>
							</tr>
							<tr>
								<td valign="middle"><font><%=user.getId()%></font></td>
								<td valign="middle"><font><%=model.getId()%></font></td>
								<td valign="middle"><font><%=model.getScale()%></font></td>
								<td valign="middle"><font
									style="border: 1px solid black; padding: 1mm; font-size: 4mm; white-space: nowrap;"><%=category.categoryCode%></font></td>
							</tr>
							<tr height="3mm">
								<td colspan="2"><font><%=model.getProducer()%></font></td>
							</tr>
							<tr>
								<td colspan="4"><b><font
										style="font-family: Calibri, Optima, Arial, sans-serif; font-size: 5mm"><%=model.getName()%></font></b></td>
							</tr>
							<tr>
								<td colspan="2"><font><%=model.getIdentification()%></font></td>
								<td colspan="2"><font><%=model.getMarkings()%></font></td>
							</tr>
<!-- 							<tr> -->
<%-- 								<td colspan="2"><%=language.getString("models.producer")%></td> --%>
<%-- 								<td colspan="2"><%=language.getString("models.markings")%></td> --%>
<!-- 							</tr> -->
						</table></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="height: 1.5mm;"></td>
	</tr>
	<tr>
		<td>
			<table cellpadding='5' style='width: 100%; border-collapse: collapse'
				border='1'>
				<tr>
					<td>&nbsp;</td>
					<%
						for (DetailingGroup group : DetailingGroup.values()) {
					%>
					<td align="center"><%=language.getString("detailing." + group.name())%></td>
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
					<td align="center"><%=model.isDetailed(group, criteria) ? "X" : "&nbsp"%>
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
