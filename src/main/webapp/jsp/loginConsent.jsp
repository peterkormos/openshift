<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="datatype.LoginConsent.LoginConsentType"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);

final String languageCode = ServletUtil.getRequestParameter(request, RequestParameter.Language.getParameterName());
ResourceBundle language = languageUtil.getLanguage(languageCode);
%>

<tr>
	<td>
		<%
		for (LoginConsentType lc : LoginConsent.LoginConsentType.values()) {
		%> <label <%=lc.isMandatory() ? "class='flash Warning'" : ""%>><input
			type="checkbox" id="dataUsageConsent<%=lc.name()%>"
			name="dataUsageConsent<%=lc.name()%>"
			<%=lc.isMandatory() ? "required='required'" : ""%>
			onchange="updateMandatoryFieldMark(this); checkSubmit(document.getElementById('inputForm'));">
			<%=language.getString("login.consent." + lc.name())%> <%
 if (lc.isMandatory()) {
 %> <font color='#FF0000' size='+3'>&#8226;</font> <%
 }
 %> </label> <br> <%
 }
 %>
	</td>
</tr>
