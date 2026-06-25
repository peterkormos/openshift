<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Map.*"%>

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

String parameterName = ServletUtil.getOptionalRequestParameter(request, "parameterName");
if (RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(parameterName))
	parameterName = RequestParameter.Language.getParameterName();

Map<String, String> languages = LanguageUtil.getLanguages();
%>

<div class="input-caption-container" style="display: inline-block;">
	<select name="<%=parameterName%>"
		<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestParameter(request, "required")) ? ""
				: "required='" + ServletUtil.getOptionalRequestParameter(request, "required") + "'"%>
		onchange="updateMandatoryFieldMark(this);"
		required='required'
		>
		<option value="<%=request.getParameter("selectValue")%>" selected><%=request.getParameter("selectLabel")%></option>
		<hr>
		<%
		if (user != null && RegistrationServlet.isAdminSession(session, User.AdminTypes.SuperAdmin)) {
		%>

		<option value="<%=User.AdminTypes.SuperAdmin.getLanguage()%>"><%=User.AdminTypes.SuperAdmin%></option>
		<option value="<%=User.AdminTypes.ShowAdmin.getLanguage()%>"><%=User.AdminTypes.ShowAdmin%></option>
		<%
		}
		
		for(Entry<String, String> language : languages.entrySet()) {
		%>
			<option value="<%=language.getKey() %>"><%=language.getValue() %></option>
		<%
		}		
		%>
	</select> <label for="<%=parameterName%>" class="input-caption"><%=request.getParameter("label")%></label>
	<font color="#FF0000" size="+3">&#8226;</font>
</div>
