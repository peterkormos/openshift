<%@page import="java.util.*"%>
<%@page import="servlet.*"%>
<%@page import="datatype.judging.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
ResourceBundle language = (ResourceBundle) session.getAttribute(CommonSessionAttribute.Language.name());
String languageCode = null;

if (language == null) {
	languageCode = ServletUtil.getOptionalRequestAttribute(request, JudgingServlet.RequestParameter.Language.name());
	if (ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(languageCode)) {
		languageCode = "HU";
	}
	language = languageUtil.getLanguage(languageCode);

	session.setAttribute(CommonSessionAttribute.Language.name(), language);
} else
	languageCode = language.getLocale().getLanguage();

String judge = (String) session.getAttribute(JudgingServlet.SessionAttribute.Judge.name());
boolean isNormalUser = !"admin".equals(judge);
%>

<head>
<link href="../base.css" rel="stylesheet" type="text/css">
</head>
<body>

	<!-- 	<a href="login.jsp">Login</a> -->
	<form name='input' accept-charset="UTF-8"
		action="../../JudgingServlet/<%=JudgingServlet.RequestType.Login.name()%>"
		method='POST' accept-charset="UTF-8"
		style="background: LightGrey; padding: 5px;">
		<jsp:include page="fillableFormField.jsp">
			<jsp:param name="name"
				value="<%=JudgingServlet.RequestParameter.Judge.name()%>" />
			<jsp:param name="caption" value='<%=language.getString("judge")%>' />
			<jsp:param name="value"
				value='<%=Optional.ofNullable(judge).orElse("")%>' />
		</jsp:include>

		<%=language.getString("language")%>:
		<jsp:include page="../language.jsp">
			<jsp:param name="parameterName"
				value="<%=JudgingServlet.RequestParameter.Language.name()%>" />
			<jsp:param name="selectLabel" value="<%=languageCode%>" />
			<jsp:param name="selectValue" value="<%=languageCode%>" />
			<jsp:param name="required" value="required" />
		</jsp:include>

		<input type="submit" value='<%=language.getString("login")%>'>
		<span style="color: LightGrey; text-align: right;"> <%=JudgingServlet.VERSION%>
		</span>
	</form>
	<p>
		<a
			href="../../JudgingServlet/<%=JudgingServlet.RequestType.GetCategories.name()%>">
			<img src="../../icons/add.png" height="30" align="center"> <%=language.getString("judging.type.form")%></a>
	<p>
		<a
			href="../../JudgingServlet/<%=JudgingServlet.RequestType.GetCategories.name()%>?<%=JudgingServlet.RequestParameter.SimpleJudging.name()%>=true">
			<img src="../../icons/add.png" height="30" align="center"> <%=language.getString("judging.type.looking")%></a>
		<%
		if (judge != null) {
		%>
	
	<p>
		<a
			href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgingSummary.name()%>">
			<img src="../../icons/list.png" height="30" align="center"> <%=language.getString("list.models")%>
			- &Ouml;sszes&iacute;t&#337; t&aacute;bl&aacute;zatok
		</a>
		<%
		}
		%>

		<%
		if (judge != null && !isNormalUser) {
		%>
		<jsp:include page="judging_admin.jsp" />
		<%
		}
		%>
	
	<p>
		<img src="../../RegistrationServlet">
</body>