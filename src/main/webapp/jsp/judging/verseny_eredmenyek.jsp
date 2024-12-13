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
	session.setAttribute(CommonSessionAttribute.Language.name(), language);
} else
	languageCode = language.getLocale().getLanguage();

language = languageUtil.getLanguage(languageCode);
%>

<head>
<link rel="stylesheet" href="../base.css" media="screen" />
</head>
<body>
	<table style="box-shadow: none; border-collapse: collapse;" border="1">
		<tr>
			<td>D&iacute;jazott makettek:</td>
			<td><a href="../../RegistrationServlet/getawardedModelsPage">megad&aacute;sa</a></td>
			<td><a href="deleteAwardedModel.jsp">t&ouml;rl&eacute;se</a></td>
		</tr>
		<tr>
			<td><a href="listAwardedModels.jsp">D&iacute;jazott makettek
					adatainak mod&oacute;s&iacute;t&aacute;sa<br>(RegServlet admin
					belepes utan !)
			</a></td>
			<td><a href="simpleAwardedModels.jsp">Egyszer&#369;
					eredm&eacute;nylista</a></td>
			<td><a href="awardedModels.jsp">Kateg&oacute;ri&aacute;kra
					bontott eredm&eacute;nylista</a></td>
		</tr>
		</tr>
		<tr>
			<td></td>
			<td><a href="../../RegistrationServlet/printAwardedModels"><%=language.getString("print.models")%></a></td>
			<td><a href="../../RegistrationServlet/getPresentationPage"><%=language.getString("presentation")%></a></td>
		</tr>
	</table>
	</p>
</body>