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

	List<Category> categories = (List<Category>) session.getAttribute(JudgingServlet.SessionAttribute.Categories.name());
	List<JudgingSheet> judgingSheets = (List<JudgingSheet>) session.getAttribute(JudgingServlet.SessionAttribute.Forms.name());
%>

<form
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.SaveCategoryWithForm.name()%>"
	method="post">

<%
	for (Category category : categories)
	{
%>
		<select name="<%=JudgingServlet.RequestParameter.Category.name() %><%= category.getId() %>" id="<%=JudgingServlet.RequestParameter.Category.name() %><%= category.getId() %>">
			<option value="" selected></option>
	<%
		for (JudgingSheet judgingSheet : judgingSheets)
		{
	%>
			<option value='<%=judgingSheet.getId()%>'><%=judgingSheet.getName()%></option>
	<%
		}
	%>
		</select> 
<%= category.getCategoryCode() %> - <%= category.getCategoryDescription() %>
		<br>
<%
	}
%>

	<input type="submit" value='<%=language.getString("save")%>'>
	<a href="../../JudgingServlet"><%=language.getString("proceed.to.main")%></a>
</form>