<%@page import="java.util.concurrent.atomic.AtomicInteger"%>
<%@page import="java.util.*"%>

<%@page import="datatype.judging.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@include file="../util.jsp"%>

<%
  highlightStart = 0xEAEAEA;

	ResourceBundle language = (ResourceBundle)session.getAttribute(SessionAttributes.Language.name());
%>


<%
  Map<String, AtomicInteger> scoredModelsByCategory = new LinkedHashMap<String, AtomicInteger>();

  Collection<JudgingResult> scoresByCategory = (Collection<JudgingResult>) session
		  .getAttribute(JudgingServlet.SessionAttribute.Judgings.name());

  int maxScore = 0;
  for (JudgingResult judgingResult : scoresByCategory)
  {
		if (judgingResult.getMaxScore() > maxScore)
		  maxScore = judgingResult.getMaxScore();

		AtomicInteger scoredModels = scoredModelsByCategory.get(judgingResult.getCategory());

		if (scoredModels == null)
		{
		  scoredModels = new AtomicInteger();
		  scoredModelsByCategory.put(judgingResult.getCategory(), scoredModels);
		}

		scoredModels.incrementAndGet();
  }
%>

<table style="border: 1px solid black;">
	<tr bgcolor="#ddddff">
		<th><%= language.getString("category") %></th>
		<th>Zs&utilde;rizett makettek sz&aacute;ma</th>
	</tr>
	<%
	  for (Map.Entry entry : scoredModelsByCategory.entrySet())
	  {
	%>
	<tr bgcolor="<%=highlight()%>">
		<td><%=entry.getKey()%></td>
		<td align="center"><%=entry.getValue()%></td>
	</tr>
	<%
	  }
	%>
</table>
<p>
<table style="border: 1px solid black;">
	<tr bgcolor="#ddddff">
		<th><%= language.getString("category") %></th>
		<th>Zs&utilde;ri</th>
		<th><%= language.getString("userID") %></th>
		<th><%= language.getString("modelID") %></th>
		<%
		  for (int i = 0; i <= maxScore; i++)
		  {
		%>
		<th><%=i%></th>
		<%
		  }
		%>
		<th>Total</th>
	</tr>

	<%
	  for (JudgingResult judgingResult : scoresByCategory)
	  {
	%>

	<tr bgcolor="<%=highlight()%>">
		<td><%=judgingResult.getCategory()%></td>
		<td><%=judgingResult.getJudge()%></td>
		<td><%=judgingResult.getModellerID()%></td>
		<td><%=judgingResult.getModelID()%></td>
		<%
			int total = 0;
		  for (int i = 0; i <= maxScore; i++)
				{

				  AtomicInteger count = judgingResult.getScores().get(i);
				  if (count != null)
				  {
				  	total += count.get(); 
		%>
		<td><%=count.get()%></td>
		<%
		  }
				  else
				  {
		%>
		<td>0</td>
		<%
		  }
				}
		%>
		<td><%= total %></td>
	</tr>
	<%
	  }
	%>
</table>