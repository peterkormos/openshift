<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%
final RegistrationServlet servlet = RegistrationServlet.getInstance(config);
final Model model = (Model) session.getAttribute(RegistrationServlet.SessionAttribute.Model.name());
String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	show = RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE;
}

boolean isLinkedToShow = model.isLinkedToShow(show);
boolean pulseButton = Boolean.parseBoolean(request.getParameter("pulseButton")) || !isLinkedToShow;
if (servlet.isRegistrationAllowed(show, session)) {
%>
<div class="tooltip">
	<a <%=pulseButton ? "class='pulseBtn'" : ""%>
		href="../RegistrationServlet/inputForModifyModel?<%=RegistrationServlet.RequestParameter.ModelId.getParameterName()%>=<%=model.getId()%>">
		<img src="../icons/modify2.png" height="30" align="center" />
		<span class="tooltiptext"> <%=ServletUtil.getLabel(request, servlet, "modify")%></span>
		<%=ServletUtil.getLabel(request, servlet, "modify")%>
	</a>
</div>
<%
}
%>