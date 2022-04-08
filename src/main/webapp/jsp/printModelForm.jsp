<%@page import="datatype.Detailing.DetailingCriteria"%>
<%@page import="datatype.Detailing.DetailingGroup"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
final User user = RegistrationServlet.getUser(request);

final RegistrationServlet servlet = RegistrationServlet.getInstance(config);
final ResourceBundle language = (ResourceBundle) session.getAttribute(CommonSessionAttribute.Language.name());
final ServletDAO servletDAO = servlet.getServletDAO();

final Model model = (Model) session.getAttribute(RegistrationServlet.SessionAttribute.Model.name());
final Category category = servletDAO.getCategory(model.categoryID);
String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	show = ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
}
%>

<table style="border: 1px solid black">
	<tr>
		<td>
			<%
			if (servlet.isRegistrationAllowed(show)) {
			%>
			<div class="tooltip">
				<a
					href="../RegistrationServlet?command=inputForModifyModel&modelID=<%=model.modelID%>">
					<img src="../icons/modify.png" height="30" align="center" /> <span
					class="tooltiptext"> <%=language.getString("modify")%></span>
				</a>
			</div>

			<div class="tooltip">
				<a
					href="../RegistrationServlet?command=deleteModel&modelID=<%=model.modelID%>">
					<img src="../icons/delete2.png" height="30" align="center" /> <span
					class="tooltiptext"> <%=language.getString("delete")%></span>
				</a>
			</div> <%
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
								<td><font><%=model.getIdentification()%></font></td>
								<td valign="middle"><font><%=user.getYearOfBirth()%></font></td>
							</tr>
							<tr>
								<td><%=language.getString("models.identification")%></td>
								<td><%=language.getString("year.of.birth")%></td>
							</tr>
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
								<td valign="middle"><font><%=user.getUserID()%></font></td>
								<td valign="middle"><font><%=model.getModelID()%></font></td>
								<td valign="middle"><font><%=model.getScale()%></font></td>
								<td valign="middle"><font
									style="border: 1px solid black; padding: 1mm; font-size: 4mm; white-space: nowrap;"><%=category.categoryCode%></font></td>
							</tr>
							<tr>
								<td colspan="4"><b><font
										style="font-family: Calibri, Optima, Arial, sans-serif; font-size: 5mm"><%=model.getName()%></font></b></td>
							</tr>
							<tr height="3mm">
								<td colspan="2"><font><%=model.getProducer()%></font></td>
								<td colspan="2"><font><%=model.getMarkings()%></font></td>
							</tr>
							<tr>
								<td colspan="2"><%=language.getString("models.producer")%></td>
								<td colspan="2"><%=language.getString("models.markings")%></td>
							</tr>
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
					<td align="center"><%=model.getDetailingGroup(group).getCriteria(criteria) ? "X" : "&nbsp"%>
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