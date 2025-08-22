<%@page import="servlet.*"%>
<%@page import="datatype.judging.*"%>
<%@page import="datatype.*"%>
<%@page import="java.util.*"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8;">
<link href="../base.css" rel="stylesheet" type="text/css">
</head>

<%
	ResourceBundle language = JudgingServlet.getLanguage(session, response);

	List<Category> categories = (List<Category>) session
			.getAttribute(JudgingServlet.SessionAttribute.Categories.name());
	List<JudgingSheet> judgingSheets = (List<JudgingSheet>) session
			.getAttribute(JudgingServlet.SessionAttribute.Forms.name());

	Map<Integer, JudgingSheet> categoryMapping = (Map<Integer, JudgingSheet>) session
			.getAttribute(JudgingServlet.SessionAttribute.JudgingCategoryToSheetMapping.name());
%>

<form
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.SaveCategoryWithForm.name()%>"
	method="post">

	<%
		for (Category category : categories) {
			JudgingSheet currentJudgingSheet = categoryMapping.get(category.getId());
	%>
	<select
		name="<%=JudgingServlet.RequestParameter.Category.name()%><%=category.getId()%>"
		id="<%=JudgingServlet.RequestParameter.Category.name()%><%=category.getId()%>">
		<%
			if (currentJudgingSheet != null) {
		%>
		<option value="<%=currentJudgingSheet.getId()%>" selected><%=currentJudgingSheet.getName()%></option>
		<%
			} else {
		%>
		<option value="" selected></option>
		<%
			}
				for (JudgingSheet judgingSheet : judgingSheets) {
		%>
		<option value='<%=judgingSheet.getId()%>'><%=judgingSheet.getName()%></option>
		<%
			}
		%>
	</select>
	<%=category.getCategoryCode()%>
	-
	<%=category.getCategoryDescription()%>
	<br>
	<%
		}
	%>

	<input type="submit" value='<%=language.getString("save")%>'> <a
		href="../../JudgingServlet"><%=language.getString("proceed.to.main")%></a>
</form>