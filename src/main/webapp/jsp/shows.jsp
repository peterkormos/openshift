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
String showInRequest = null;

try {
	showInRequest = RegistrationServlet.getShowFromRequest(request);
	shows.retainAll(Arrays.asList(showInRequest));
} catch (final Exception e) {
}

for (final String show : shows) {
%>
<tr>
	<td align="center"><label> <input type='radio' name='<%=RequestParameter.Show.getParameterName() %>'
			onchange="updateMandatoryFieldMark(this.parentNode); checkSubmit(document.getElementById('inputForm'));"
			value='<%=StringEncoder.toBase64(show.getBytes())%>'
			<%=(shows.size() == 1 ? " checked='checked'" : "")%> 
			required='required'
			/> <img
			style="height: 25mm; vertical-align: middle;"
			src="../RegistrationServlet/<%=RegistrationServlet.Command.LOADIMAGE.name()%>/<%=servlet.getLogoIDForShow(show)%>">
			<span style="color: red"><b> <%=show%></b></span>
	</label> <%
 }
 %> <%=shows.isEmpty() || shows.size() == 1 ? "" : "<font color='#FF0000' size='+3'>&#8226;</font>"%>
	</td>
</tr>

