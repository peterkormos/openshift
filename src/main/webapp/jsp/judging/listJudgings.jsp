<%@page import="java.util.*"%>

<%@page import="datatype.judging.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@include file="../util.jsp"%>

<%
  highlightStart = 0xEAEAEA;

	ResourceBundle language = JudgingServlet.getLanguage(session, response);
%>

<table style="border: 1px solid black;">

	<tr bgcolor="#ddddff">
		<th><%= language.getString("category") %></th>
		<th>Zs&utilde;ri</th>
		<th><%= language.getString("userID") %></th>
		<th><%= language.getString("modelID") %></th>
		<th><%= language.getString("models.name") %></th>
		<th>Krit&eacute;ria</th>
		<th>Pont</th>
		<th>Megjegyz&eacute;s</th>
		<th>DB ID</th>
	</tr>


	<%
	List<JudgingScore> judgings = (List<JudgingScore>)session.getAttribute(JudgingServlet.SessionAttribute.Judgings.name());
	for(JudgingScore judgingScore : judgings)
	{
%>
	<tr bgcolor="<%=highlight()%>">
		<td><%= judgingScore.getCategory()%></td>
		<td><%= judgingScore.getJudge()%></td>
		<td><%= judgingScore.getModellerID()%></td>
		<td><%= judgingScore.getModelID()%></td>
		<td><%= judgingScore.getModelsName()%></td>
		<td><%= judgingScore.getCriteriaID()%></td>
		<td><%= judgingScore.getScore()%></td>
		<td><%= judgingScore.getComment()%></td>
		<td><%= judgingScore.getId()%></td>
	</tr>

	<%	  
	}
%>

</table>