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
	if (RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE.equals(languageCode)) {
		languageCode = RegistrationServlet.DEFAULT_LANGUAGE;
	}
	language = languageUtil.getLanguage(languageCode);

	session.setAttribute(CommonSessionAttribute.Language.name(), language);
} else
	languageCode = language.getLocale().getLanguage();
%>

<hr>
<p>
	<a
		href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgingSheets.name()%>">
		<img src="../../icons/list.png" height="30" align="center"> <%=language.getString("list.models")%>
		- pontoz&oacute;lapok
	</a>
<p>
<p>
	<a
		href="../../JudgingServlet/<%=JudgingServlet.RequestType.ListJudgings.name()%>">
		<img src="../../icons/list.png" height="30" align="center">
		<%=language.getString("list.models")%>
		- zs&#369;ripontok krit&eacute;riumonk&eacute;nt
	</a>
<p>
	<a
		href="../../JudgingServlet/<%=JudgingServlet.RequestType.JoinCategoryWithForm.name()%>">
		<img src="../../icons/add.png" height="30" align="center">
		Pontoz&oacute;lap - kateg&oacute;ria &ouml;sszerendel&eacute;se
	</a>
<p>
	<a
		href="../../JudgingServlet/<%=JudgingServlet.RequestType.DeleteRecords.name()%>?<%=JudgingServlet.RequestParameter.Class.name()%>=<%=JudgingScore.class.getName()%>">
		<img src="../../icons/delete2.png" height="30" align="center">
		Minden egyes zs&#369;ripont t&ouml;rl&eacute;se
	</a>
<p>
	<a
		href="../../JudgingServlet/<%=JudgingServlet.RequestType.DeleteRecords.name()%>?<%=JudgingServlet.RequestParameter.Class.name()%>=<%=JudgingCriteria.class.getName()%>">
		<img src="../../icons/delete2.png" height="30" align="center">
		Minden egyes krit&eacute;ria t&ouml;rl&eacute;se
	</a>
<p>
	<a
		href="../../JudgingServlet/<%=JudgingServlet.RequestType.DeleteRecords.name()%>?<%=JudgingServlet.RequestParameter.Class.name()%>=<%=JudgingSheet.class.getName()%>">
		<img src="../../icons/delete2.png" height="30" align="center">
		Minden egyes pontoz&oacute;lap t&ouml;rl&eacute;se
	</a>
<p>
	<a
		href="../../JudgingServlet/<%=JudgingServlet.RequestType.DeleteRecords.name()%>?<%=JudgingServlet.RequestParameter.Class.name()%>=<%=JudgingCategoryToSheetMapping.class.getName()%>">
		<img src="../../icons/delete2.png" height="30" align="center">
		Pontoz&oacute;lap - kateg&oacute;ria &ouml;sszerendel&eacute;sek
		t&ouml;rl&eacute;se
	</a>
<p>
<form accept-charset="UTF-8"
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.ImportData.name()%>"
	method="post" enctype="multipart/form-data" name="input">
	Pontoz&oacute;lap konfigur&aacute;ci&oacute;k bet&ouml;lt&eacute;se: <input
		type="file" name="zipFile"> <input type="submit"
		value="Adatok import&aacute;l&aacute;sa">
</form>
