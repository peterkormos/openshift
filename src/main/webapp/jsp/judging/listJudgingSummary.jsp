<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.concurrent.atomic.AtomicInteger"%>
<%@page import="java.util.*"%>

<%@page import="datatype.judging.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@include file="../util.jsp"%>

<%
  highlightStart = 0xEAEAEA;

	ResourceBundle language = JudgingServlet.getLanguage(session, response);
	
	String judge = (String)session.getAttribute(JudgingServlet.SessionAttribute.Judge.name());
	boolean isNormalUser = !"admin".equals(judge);

  Map<String, AtomicInteger> scoredModelsByCategory = new LinkedHashMap<String, AtomicInteger>();

  Collection<JudgingResult> scoresByCategory = (Collection<JudgingResult>) session
		  .getAttribute(JudgingServlet.SessionAttribute.Judgings.name());
  session.removeAttribute(JudgingServlet.SessionAttribute.Judgings.name());
  
  if(scoredModelsByCategory == null)
  	response.sendRedirect(JudgingServlet.DEFAULT_PAGE);
  	
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

<head>
<link href="../base.css" rel="stylesheet" type="text/css">
</head>

<%
	List<JudgingError> judgingErrors = JudgingServlet.checkJudgingResults(scoresByCategory);
	
	for(JudgingError judgingError : judgingErrors)
	{
	%>
		<div style="background-color: <%= judgingError.getErrorType().getBackgrouondColor() %>;">
			<%= language.getString("category") %>: <%= judgingError.getCategory() %> 
			<%= language.getString("modelID") %>: <%= judgingError.getModelID() == 0 ? "-" : judgingError.getModelID() %> 
			Error: <%= judgingError.getErrorMessage() %>
		</div>
		<p>
	<%
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
		<th><%= language.getString("judge") %></th>
		<th><%= language.getString("userID") %></th>
		<th><%= language.getString("modelID") %></th>
		<th><%= language.getString("models.name") %></th>
		<%
		  for (int i = 0; i <= maxScore; i++)
		  {
		%>
		<th><%=i%></th>
		<%
		  }
		%>
		<th>Total</th>
		<th>Action</th>
	</tr>

	<%
	  for (JudgingResult judgingResult : scoresByCategory)
	  {
		if(judge != null && 
			isNormalUser && 
			!judge.equals(judgingResult.getJudge())
			)
			continue;
	%>

	<tr bgcolor="<%=highlight()%>" 
	
	<% 
		 if(judgingErrors.contains(new JudgingError(judgingResult.getCategory(), judgingResult.getModelID())))
		 {
		 %>
		 	class="flash ERROR"	
		 <%
		 }
	%>
	
	>
		<td align="center"><%=judgingResult.getCategory()%></td>
		<td><%=judgingResult.getJudge()%></td>
		<td><%=judgingResult.getModellerID()%></td>
		<td><%=judgingResult.getModelID()%></td>
		<td><%=judgingResult.getModelsName()%></td>
		<%
			int total = 0;
		  for (int i = 0; i <= maxScore; i++)
				{

				  int count = judgingResult.getCountForScore(i);
				  	total += count; 
					%>
					<td><%= count %></td>
					<%
				}
		%>
		<td><%= total %></td>
		<td>
		<a href="../../JudgingServlet/<%= JudgingServlet.RequestType.GetJudgingForm.name() %>?<%= JudgingServlet.RequestParameter.ModelID %>=<%=judgingResult.getModelID()%>&<%= JudgingServlet.RequestParameter.ModellerID %>=<%=judgingResult.getModellerID()%>&<%= JudgingServlet.RequestParameter.Category %>=<%=judgingResult.getCategory()%>&<%= JudgingServlet.RequestParameter.Judge %>=<%=judgingResult.getJudge()%>">
		<%= language.getString("modify") %></a>
		
		<a href="../../JudgingServlet/<%= JudgingServlet.RequestType.DeleteJudgingForm.name() %>?<%= JudgingServlet.RequestParameter.ModelID %>=<%=judgingResult.getModelID()%>&<%= JudgingServlet.RequestParameter.ModellerID %>=<%=judgingResult.getModellerID()%>&<%= JudgingServlet.RequestParameter.Category %>=<%=judgingResult.getCategory()%>&<%= JudgingServlet.RequestParameter.Judge %>=<%=judgingResult.getJudge()%>">
		<%= language.getString("delete") %></a>
</td>
	</tr>
	<%
	  }
	%>
</table>