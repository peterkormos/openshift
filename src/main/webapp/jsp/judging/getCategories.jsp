<%@page import="java.util.*"%>
<%@page import="servlet.*"%>
<%@page import="datatype.*"%>
<%@page import="util.*"%>


<%
ResourceBundle language = JudgingServlet.getLanguage(session, response);

    Boolean simpleJudging = (Boolean) session.getAttribute(JudgingServlet.SessionAttribute.SimpleJudging.name());
    if(simpleJudging == null) {
        simpleJudging = Boolean.valueOf(ServletUtil.getOptionalRequestParameter(request, JudgingServlet.RequestParameter.SimpleJudging.name()));
    }
%>

<head>
<link href="../base.css" rel="stylesheet" type="text/css">
</head>

<jsp:include page="../notices.jsp" />

<form
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.GetJudgingForm.name()%>"
	method="post">
    <input type="hidden"
        name="<%=JudgingServlet.RequestParameter.SimpleJudging.name()%>"
        value="<%=simpleJudging%>">

<table style='width: 100%; border-collapse: collapse;' border='1'>
	<tr>
		<th align='center' style='white-space: nowrap'><%= language.getString("category") %></th>
		<th align='center' style='white-space: nowrap'>Action</th>
	</tr>
	
	<%
		List<Category> categories = (List<Category>) session.getAttribute(JudgingServlet.SessionAttribute.Categories.name());

	  for (Category category : categories)
	  {
	%>
	<tr>
		<td>
			<label>
			<input type="radio" name="<%=JudgingServlet.RequestParameter.Category.name()%>" value="<%= category.getCategoryCode() %>" onclick="submit()">
			<%= category.getCategoryCode()%> - <%= category.getCategoryDescription()%>
			</label>
		</td>
		<td>
			<a href="../../JudgingServlet/<%= JudgingServlet.RequestType.GetModels.name() %>?<%= JudgingServlet.RequestParameter.Category %>=<%=category.getCategoryCode()%>&<%= JudgingServlet.RequestParameter.ForJudges %>=true">
			<%= language.getString("list.models") %>
			</a>
		</td>
	</tr>
	<%
	  }
	%>
	</table>
</form