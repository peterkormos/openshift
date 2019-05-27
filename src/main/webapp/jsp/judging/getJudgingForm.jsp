<%@page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%@page import="servlet.*"%>
<%@page import="datatype.judging.*"%>
<%@page import="util.*"%>

<%@include file="../util.jsp"%>

<%
    highlightStart = 0xEAEAEA;

    String judge = (String) session.getAttribute(JudgingServlet.SessionAttribute.Judge.name());
    
    if (judge == null)
        judge = ServletUtil.getOptionalRequestAttribute(request, JudgingServlet.RequestParameter.Judge.name());

    List<JudgingCriteria> criteriaList = (List<JudgingCriteria>) session
            .getAttribute(JudgingServlet.SessionAttribute.JudgingCriteriasForCategory.name());

    if (criteriaList == null) {
        criteriaList = Arrays.asList(JudgingCriteria.getDefault());
    }
    String category = (String) session.getAttribute(JudgingServlet.SessionAttribute.Category.name());

    ResourceBundle language = JudgingServlet.getLanguage(session, response);

    int maxlength = JudgingScore.MAX_COMMENT_LENGTH;
    
    String unjudgedCriteriaStyle = "background-color: grey;";
%>

<%
    Map<Integer, List<JudgingScore>> scores = (Map<Integer, List<JudgingScore>>) session.getAttribute(JudgingServlet.SessionAttribute.Judgings.name());
    session.removeAttribute(JudgingServlet.SessionAttribute.Judgings.name());
    
    JudgedModel judgedModel = null;
    if(scores != null)
    {
    	Optional<List<JudgingScore>> optional = scores.values().stream().findFirst();
    	if(optional.isPresent())
      		judgedModel = optional.get().get(0);
    } 
 %>

<head>
<link href="../base.css" rel="stylesheet" type="text/css">
</head>

<p>
<form
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.SaveJudging.name()%>"
	method="post">

 	<input type="hidden"
	name="<%=JudgingServlet.RequestParameter.JudgingCriterias.name()%>"
	value="<%=criteriaList.size()%>">			 

	<table style="border: 1px solid black;">
		<tr>
			<td colspan="3">
			<jsp:include page="fillableFormField.jsp">
			  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.Category.name() %>"/>
			  <jsp:param name="value" value='<%= category == null ? "" : category %>'/>
			  <jsp:param name="caption" value='<%= language.getString("category.code") %>'/>
			</jsp:include>
			
			<jsp:include page="fillableFormField.jsp">
			  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.Judge.name() %>"/>
			  <jsp:param name="value" value='<%= judge %>'/>
			  <jsp:param name="caption" value='<%= language.getString("judge") %>'/>
			</jsp:include>
			</td>
		</tr>

		<tr>
			<td colspan="3">
			<jsp:include page="fillableFormField.jsp">
			  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.ModellerID.name() %>"/>
			  <jsp:param name="value" value='<%= judgedModel == null ? "" : judgedModel.getModellerID() %>'/>
			  <jsp:param name="size" value='3'/>
			  <jsp:param name="caption" value='<%= language.getString("userID") %>'/>
			</jsp:include>

			<jsp:include page="fillableFormField.jsp">
			  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.ModelID.name() %>"/>
			  <jsp:param name="value" value='<%= judgedModel == null ? "" : judgedModel.getModelID() %>'/>
			  <jsp:param name="size" value='3'/>
			  <jsp:param name="caption" value='<%= language.getString("modelID") %>'/>
			</jsp:include>

			</td>
		</tr>
		<tr>
			<td colspan="3">
			<jsp:include page="fillableFormField.jsp">
			  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.ModelsName.name() %>"/>
			  <jsp:param name="value" value='<%= judgedModel == null ? "" : judgedModel.getModelsName() %>'/>
			  <jsp:param name="caption" value='<%= language.getString("models.name") %>'/>
			</jsp:include>
			</td>
		</tr>
		
		

		<tr height="20px">
		</tr>

		<tr bgcolor="#ddddff">
			<th><%= language.getString("judging.criteria") %></th>
			<th><%= language.getString("judging.criteria.description") %></th>
			<th><%= language.getString("judging.criteria.score") %></th>
		</tr>
			<%
				  for (JudgingCriteria criteria : criteriaList)
				  {
				  	boolean hasScore = judgedModel != null && scores.get(criteria.getId()) != null;
				%>
				<tr bgcolor="<%=highlight()%>"
				<%= hasScore ? "" : "style = '"+unjudgedCriteriaStyle+"'"%>
				>
					<td><%=criteria.getId()%></td>
					<td><%=criteria.getDescription()%></td>
					<td>
						<label>
						<input type="radio" 
						name="<%=JudgingServlet.RequestParameter.JudgingCriteria.name()%><%= criteria.getId() %>"
						value="<%= ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE %>"
						onchange="parentNode.parentNode.parentNode.style = '<%= unjudgedCriteriaStyle %>';"
						><%= ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE %> 
						</label>

						<%
						  for (int i = 0; i < criteria.getMaxScore() + 1; i++)
								{
								
// 								judgingScores.get(i)
						%> 
						<label>
						<input type="radio" 
						name="<%=JudgingServlet.RequestParameter.JudgingCriteria.name()%><%= criteria.getId() %>"
						value="<%=i%>"
						<%= hasScore && scores.get(criteria.getId()).get(0).getScore() == i ? "checked='checked'" : "" %>
						onchange="parentNode.parentNode.parentNode.style = '';"
						><%=i%> 
						</label>
		<%
		   }
		 %>
					</td>
				</tr>
				<%
				  }
			 %> 		

		<tr>
			<td colspan="3" style="vertical-align: top;">
			<%= language.getString("comment") %>: 
			<textarea
					name='<%=JudgingServlet.RequestParameter.Comment.name()%>'
					maxlength='<%= maxlength %>'
					cols='50' rows='3' placeholder="<%= String.format(language.getString("input.text.maxlength"), maxlength) %>"
					><%= judgedModel != null ? scores.values().iterator().next().get(0).getComment() : "" %></textarea></td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<input type="submit" value='<%= language.getString("save") %>'>
				<input name='finishRegistration' type='submit' value='<%= language.getString("finish.model.registration") %>'>
			</td>
		</tr>
	</table>
</form>

<%!
Map<String, String> loadFile(File file) throws IOException
  {
	Map<String, String> props = new LinkedHashMap<String, String>();
	BufferedReader reader = new BufferedReader(new FileReader(file));

	String line = null;
	while ((line = reader.readLine()) != null)
	{
	  String[] kv = line.split("=");
	  props.put(kv[0], kv[1]);
	}

	reader.close();

	return props;
  }
  %>