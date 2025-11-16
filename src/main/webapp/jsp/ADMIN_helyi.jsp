<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);

String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	show = RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE;
}

if (servlet.isAdminSession(session)) {

	User user = null;
	try {
		user = RegistrationServlet.getUser(request);
	} catch (Exception ex) {
		out.print(ex.getMessage());
		return;
	}

	ResourceBundle language = languageUtil.getLanguage(user.language);
%>

<a href='helyi.jsp'>Helyi bel&eacute;p&eacute;si oldal
	bet&ouml;lt&eacute;se...</a>
<p>

	Egy makett nevez&eacute;si lapj&aacute;nak nyomtat&aacute;sa:
	<jsp:include page="modelSelect.jsp">
		<jsp:param name="action" value="printMyModels" />
		<jsp:param name="submitLabel"
			value='<%=language.getString("print.models")%>' />
	</jsp:include>
	<%
	}
	%>