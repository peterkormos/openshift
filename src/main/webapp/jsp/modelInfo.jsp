<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="servlet.JudgingServlet.SessionAttribute"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
ServletDAO servletDAO = RegistrationServlet.getServletDAO();

servlet.debugRequest(request);

String languageCode;
try {
	languageCode = RegistrationServlet.getLanguageCodeInRequest(request);
} catch (Exception e) {
	languageCode = RegistrationServlet.getLanguageCodeForCurrentUserWithDefault(request);
}
ResourceBundle language = languageUtil.getLanguage(languageCode);

final String modelID = ServletUtil.getRequestParameter(request, RequestParameter.ModelId.getParameterName());
final Model model;
try {
	model = servletDAO.getModel(Integer.parseInt(modelID));
	session.setAttribute(RegistrationServlet.SessionAttribute.Model.name(), model);
} catch (Exception e) {
	RegistrationServlet.redirectToStartPage(request, response);
	return;
}

String show;
try {
	show = RegistrationServlet.getShowFromRequest(request);
} catch (Exception e) {
	show = RegistrationServlet.getShowFromSession(request);
}

Optional<Category> categoryOptional = model.getCategoryForShow(show);
if (!categoryOptional.isPresent()) {
	RegistrationServlet.redirectToStartPage(request, response);
	return;
}
Category category = categoryOptional.get();

boolean preRegistrationAllowed = servlet.isPreRegistrationAllowed(show);

String judge = (String) session.getAttribute(SessionAttribute.Judge.name());
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
<p>
Mit lenne j&oacute; l&aacute;tni itt? Seg&iacute;ts minket fejleszteni a rendszert &eacute;s &iacute;rd meg nek&uuml;nk ötleteidet...
<hr>
</p>
	<%
	if (judge != null) {
	%>
	<p>
		<a
			href="../JudgingServlet/<%=JudgingServlet.RequestType.GetJudgingForm.name()%>?<%=JudgingServlet.RequestParameter.SimpleJudging.name()%>=false&<%=JudgingServlet.RequestParameter.Category.name()%>=<%=category.getId()%>">
			<img src="../icons/add.png" height="30" align="center"> <%=language.getString("judging.type.form")%></a>
		<a
			href="../JudgingServlet/<%=JudgingServlet.RequestType.GetJudgingForm.name()%>?<%=JudgingServlet.RequestParameter.SimpleJudging.name()%>=true&<%=JudgingServlet.RequestParameter.Category.name()%>=<%=category.getId()%>">
			<img src="../icons/stare.png" height="30" align="center"> <%=language.getString("judging.type.looking")%></a>
	</p>
	<%
	}
	%>
	<p>
		<jsp:include page="printModelForm.jsp" />
	</p>
	<%
	if (judge != null) {
	%>
	<hr>
	<b> <%=category.getCategoryCode()%> - <%=category.getCategoryDescription()%>:
	</b>
	<%
	for (Model modelInCategory : servletDAO.getModelsInCategory(category.getId())) {
		session.setAttribute(RegistrationServlet.SessionAttribute.Model.name(), modelInCategory);
	%>
	<p>
		<jsp:include page="printModelForm.jsp" />
	</p>
	<%
	session.removeAttribute(RegistrationServlet.SessionAttribute.Model.name());
	}
	}
	%>

</body>
</html>