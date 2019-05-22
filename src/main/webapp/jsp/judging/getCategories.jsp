<%@page import="java.util.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>


<%
	ResourceBundle language = (ResourceBundle)session.getAttribute(SessionAttributes.Language.name());
%>

<form
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.GetJudgingForm.name()%>"
	method="post">
	<%= language.getString("category.code") %>:
	<p>
	<%
	    Set<String> categories = (Set<String>) session.getAttribute(JudgingServlet.RequestType.GetCategories.name());

		  for (String category : categories)
		  {
	%>
			<label>
			<%= category %>
			<input type="radio" name="<%=JudgingServlet.RequestParameter.Category.name()%>" value="<%= category %>" onclick="submit()">
			</label>
			<br>
	<%
		  }
	%>
	
</form>