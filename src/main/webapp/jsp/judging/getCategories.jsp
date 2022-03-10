<%@page import="java.util.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>


<%
	ResourceBundle language = JudgingServlet.getLanguage(session, response);

    Boolean simpleJudging = (Boolean) session.getAttribute(JudgingServlet.SessionAttribute.SimpleJudging.name());
    if(simpleJudging == null) {
        simpleJudging = Boolean.valueOf(ServletUtil.getOptionalRequestAttribute(request, JudgingServlet.RequestParameter.SimpleJudging.name()));
    }
%>

<head>
<link href="../base.css" rel="stylesheet" type="text/css">
</head>

<form
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.GetJudgingForm.name()%>"
	method="post">
    <input type="hidden"
        name="<%=JudgingServlet.RequestParameter.SimpleJudging.name()%>"
        value="<%=simpleJudging%>">

	<%= language.getString("category.code") %>:
	<p>
	<%
		List<String> categories = (List<String>) session.getAttribute(JudgingServlet.SessionAttribute.Categories.name());

	  for (String category : categories)
	  {
	%>
			<label>
			<%= category %>
			<input type="radio" name="<%=JudgingServlet.RequestParameter.Category.name()%>" value="<%= category %>" onclick="submit()">
			</label>
		<a href="../../JudgingServlet/<%= JudgingServlet.RequestType.GetModelsInCategory.name() %>?<%= JudgingServlet.RequestParameter.Category %>=<%=category%>&<%= JudgingServlet.RequestParameter.ForJudges %>=true">
		<%= language.getString("list.models") %>
		</a>
			<br>
	<%
	  }
	%>
	
</form>