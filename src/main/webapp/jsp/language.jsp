<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);

User user = null;
try {
	user = servlet.getUser(request);
} catch (Exception ex) {
}

String parameterName = ServletUtil.getOptionalRequestAttribute(request, "parameterName");
if (RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(parameterName))
	parameterName = RequestParameter.Language.getParameterName();
%>

<div class="input-caption-container" style="display: inline-block;">
	<select name="<%=parameterName%>"
		<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestAttribute(request, "required")) ? ""
				: "required='" + ServletUtil.getOptionalRequestAttribute(request, "required") + "'"%>
		onchange="updateMandatoryFieldMark(this);">
		<option value="<%=request.getParameter("selectValue")%>" selected><%=request.getParameter("selectLabel")%></option>
		<option value="">-------</option>
		<%
		if (user != null && RegistrationServlet.isAdminSession(session)) {
		%>

		<option value="<%=User.AdminTypes.SuperAdmin.getLanguage()%>"><%=User.AdminTypes.SuperAdmin%></option>
		<option value="<%=User.AdminTypes.ShowAdmin.getLanguage()%>"><%=User.AdminTypes.ShowAdmin%></option>
		<%
		}
		%>
		<option value="HU">Magyar</option>
		<option value="EN">English</option>
		<option value="SK">Slovensk&aacute;</option>
		<option value="CZ">Cesk&aacute;</option>
		<option value="PL">Polski</option>
		<option value="IT">Italiano</option>
		<option value="DE">Deutsch</option>
		<option value="RU">&#1056;&#1091;&#1089;&#1089;&#1082;&#1080;&#1081;</option>
		<option value="">-------</option>
	</select> <label for="<%=parameterName%>" class="input-caption"><%=request.getParameter("label")%></label>
	<font color="#FF0000" size="+3">&#8226;</font>
</div>
