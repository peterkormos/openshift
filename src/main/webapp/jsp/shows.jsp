<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="datatype.LoginConsent.LoginConsentType"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = RegistrationServlet.getServletDAO();

final List<String> shows = servletDAO.getShows();
String showIdHttpParameter = request.getParameter(RequestParameter.ShowId.getParameterName());

if (showIdHttpParameter != null)
	try {
		shows.retainAll(Arrays.asList(shows.get(Integer.parseInt(showIdHttpParameter) - 1)));
	} catch (Exception ex) {
	}

for (final String show : shows) {
%>
<tr>
	<td align="center"><label> <input type='radio' name='show'
			onchange="updateMandatoryFieldMark(this.parentNode); checkSubmit(document.getElementById('inputForm'));"
			value='<%=StringEncoder.toBase64(show.getBytes())%>'
			<%=(shows.size() == 1 ? " checked='checked'" : "")%> /> <img
			style="height: 25mm; vertical-align: middle;"
			src="../RegistrationServlet/<%=RegistrationServlet.Command.LOADIMAGE.name()%>/<%=servlet.getLogoIDForShow(show)%>">
			<span style="color: red"><b> <%=show%></b></span>
	</label> <%
 }
 %> <%=shows.isEmpty() || shows.size() == 1 ? "" : "<font color='#FF0000' size='+3'>&#8226;</font>"%>
	</td>
</tr>

