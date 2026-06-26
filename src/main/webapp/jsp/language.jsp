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

Map<String, String> languageIcons = LanguageUtil.getLanguageIcons();
%>

<div class="input-caption-container" style="display: inline-block;">
	<fieldset
		id="languageGroup"
		style="display: inline; padding: 15px;">

		<%
		if (user != null && RegistrationServlet.isAdminSession(session, User.AdminTypes.SuperAdmin)) {
		%>

		<label>
			<input
			name='<%=parameterName%>' type='radio' 
			onchange="updateMandatoryFieldMark(this);"
		<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestParameter(request, "required")) ? ""
				: "required='" + ServletUtil.getOptionalRequestParameter(request, "required") + "'"%>
				value="<%=User.AdminTypes.SuperAdmin.getLanguage()%>"
			>
			<%=User.AdminTypes.SuperAdmin%> 
		</label>
		<label>
			<input
			name='<%=parameterName%>' type='radio' 
			onchange="updateMandatoryFieldMark(this);"
		<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestParameter(request, "required")) ? ""
				: "required='" + ServletUtil.getOptionalRequestParameter(request, "required") + "'"%>
				value="<%=User.AdminTypes.ShowAdmin.getLanguage()%>"
			>
			<%=User.AdminTypes.ShowAdmin%> 
		</label>
		<%
		}
		
		for(Entry<String, String> language : languageIcons.entrySet()) {
		%>
		<label>
			<input
			name='<%=parameterName%>' type='radio' 
			onchange="updateMandatoryFieldMark(this);"
		<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(ServletUtil.getOptionalRequestParameter(request, "required")) ? ""
				: "required='" + ServletUtil.getOptionalRequestParameter(request, "required") + "'"%>
				value="<%=language.getKey() %>"
				<%=language.getKey().equals(request.getParameter("selectValue")) ? "checked='checked'" : "" %>
			>
			<img src="<%=request.getParameter("pathOffset") != null ? request.getParameter("pathOffset") : ""%>../icons/<%=language.getValue() %>">
		</label>
		<%
		}		
		%>
	</fieldset>
	<label for="languageGroup" class="input-caption"><%=request.getParameter("label")%></label>
	<font color="#FF0000" size="+3">&#8226;</font>
</div>
