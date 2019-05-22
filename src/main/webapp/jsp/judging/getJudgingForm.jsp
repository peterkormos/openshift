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

    int maxlength = 1000;
%>
<p>
<form
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.SaveJudging.name()%>"
	method="post">

 	<input type="hidden"
	name="<%=JudgingServlet.RequestParameter.JudgingCriterias.name()%>"
	value="<%=criteriaList.size()%>">			 

	<table style="border: 1px solid black;">
		<tr>
			<td colspan="3"><%= language.getString("category.code") %>:
			<%
				if(category == null)
				{
				%>
					<input type="text" size="4"
					name="<%=JudgingServlet.RequestParameter.Category.name()%>"
					> 
				<%
				}
				else
				{
				%>
					<input type="hidden"
					name="<%=JudgingServlet.RequestParameter.Category.name()%>"
					value="<%=category%>"> 
					<b><%=category%></b> 
				<%
				}
			 %> 
				Judge: 
			<%
				if(ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE.equals(judge))
				{
				%>
					<input type="text" required="required"
					name="<%=JudgingServlet.RequestParameter.Judge.name()%>"
					> 
				<%
				}
				else
				{
				%>
					<input type="hidden"
					name="<%=JudgingServlet.RequestParameter.Judge.name()%>"
					value="<%=judge%>"> 
					<b><%=judge%></b> 
				<%
				}
			 %> 
			</td>
		</tr>

		<tr>
			<td colspan="3"><%= language.getString("userID") %>: <input type="number" min="1"
				required="required"
				name="<%=JudgingServlet.RequestParameter.ModellerID.name()%>"
				size="3"> <%= language.getString("modelID") %>: <input type="number" min="1"
				required="required"
				name="<%=JudgingServlet.RequestParameter.ModelID.name()%>" size="3">
			</td>
		</tr>

		<tr height="20px">
		</tr>

		<tr bgcolor="#ddddff">
			<th>Criteria</th>
			<th>Description</th>
			<th>Score</th>
		</tr>
			<%
				  for (JudgingCriteria criteria : criteriaList)
				  {
				%>
				<tr bgcolor="<%=highlight()%>">
					<td><%=criteria.getId()%></td>
					<td><%=criteria.getDescription()%></td>
					<td>
						<%
						  for (int i = 0; i < criteria.getMaxScore() + 1; i++)
								{
						%> <input type="radio"
						name="<%=JudgingServlet.RequestParameter.Score.name()%><%=criteria.getId()%>"
						value="<%=i%>"><%=i%> <%
		   }
		 %>
					</td>
				</tr>
				<%
				  }
			 %> 		

		<tr>
			<td colspan="3" valign="top"><%= language.getString("comment") %>: <textarea
					name='<%=JudgingServlet.RequestParameter.Comment.name()%>'
					maxlength='<%= maxlength %>'
					cols='50' rows='3' placeholder="Max. <%= maxlength %> char.">
				</textarea></td>
		</tr>
		<tr>
			<td colspan="3" align="center"><input type="submit" value='<%= language.getString("save") %>'></td>
		</tr>
	</table>
</form>

<%!Map<String, String> loadFile(File file) throws IOException
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
  }%>