<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = RegistrationServlet.getServletDAO();

String languageCode;
try {
	languageCode = RegistrationServlet.getLanguageCodeInRequest(request);
} catch (Exception e) {
	languageCode = RegistrationServlet.getLanguageCodeForCurrentUserWithDefault(request);
}
ResourceBundle language = languageUtil.getLanguage(languageCode);

final String modelID = ServletUtil.getRequestParameter(request, RequestParameter.ModelId.getParameterName());
final Model model = servletDAO.getModel(Integer.parseInt(modelID));
session.setAttribute(RegistrationServlet.SessionAttribute.Model.name(), model);

String show;
try {
	show = RegistrationServlet.getShowFromRequest(request);
} catch (Exception e) {
	show = RegistrationServlet.getShowFromSession(request);
}

Optional<Category> categoryOptional = model.getCategoryForShow(show);
if (!categoryOptional.isPresent()) {
	servlet.writeErrorResponse(request, response, "Error: <b>Model's category not found for show!</b>");
	return;
}
Category category = categoryOptional.get();

boolean preRegistrationAllowed = servlet.isPreRegistrationAllowed(show);
%>

<html>
<head>
<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="base.css" rel="stylesheet" type="text/css">
</head>
<body>
	<table border=1>
		<tr>
			<th style='white-space: nowrap'><%=language.getString("show")%></th>
			<th style='white-space: nowrap'><%=language.getString("category.code")%></th>
			<th style='white-space: nowrap'><%=language.getString("category.description")%></th>
			<th style='white-space: nowrap'>GMID</th>
			<th style='white-space: nowrap'><%=language.getString("modelID")%></th>
			<th style='white-space: nowrap'><%=language.getString("scale")%></th>
			<th style='white-space: nowrap'><%=language.getString("models.name")%></th>
		</tr>

		<tr>
			<td><%=show%></td>
			<td><%=category.getCategoryCode()%></td>
			<td><%=category.getCategoryDescription()%></td>
			<td><%=model.getId()%></td>
			<td><%=model.getShowID(category.getId())%></td>
			<td><%=model.getScale()%></td>
			<td><%=model.getName()%></td>
		</tr>
	</table>
	<p>
		<jsp:include page="printModelForm.jsp" />
	</p>
</body>
</html>