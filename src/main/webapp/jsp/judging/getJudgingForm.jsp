<%@page import="datatype.Model"%>
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
    
    String unjudgedCriteriaStyle = "background-color: lightgrey;";
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
    else
    	scores = new HashMap<Integer, List<JudgingScore>>();  
    
	Model model = (Model)session.getAttribute(CommonSessionAttribute.Model.name());
    if(judgedModel == null && model != null)
    {
    		judgedModel = new JudgedModel(model);
    }
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8;">
<link href="../base.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
// <!--
function setModelInSession(value)
{
	var url = "../../RegistrationServlet?command=setModelInSession&modelID=" + value;
	var req = false;

	if (window.XMLHttpRequest) 
	{ // Mozilla, Safari,...
   		req = new XMLHttpRequest();

	if (req.overrideMimeType)
    	req.overrideMimeType('text/xml');
  	} 
	else if (window.ActiveXObject) 
	{ // IE
   		try 
		{
		    req = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) 
		{
      		try 
			{
       			req = new ActiveXObject("Microsoft.XMLHTTP");
      		} catch (e) 
			{}
     	}
   }
   
	req.open("GET", url, true);
	req.onreadystatechange= function()
	{   
	 
		if (req.readyState == 4 && 'ok' == req.responseText)
		{
			location.reload(true);
		}
	}

	req.send(null);
}

//-->
</script>

</head>

<p>
<p id="resp" />

<form
accept-charset='UTF-8'
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.SaveJudging.name()%>"
	method="post">

 	<input type="hidden"
	name="<%=JudgingServlet.RequestParameter.JudgingCriterias.name()%>"
	value="<%=criteriaList.size()%>">			 

	<table style="border: 1px solid black;">
		<tr>
			<td colspan="3">
			<jsp:include page="fillableFormField.jsp">
			  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.ModellerID.name() %>"/>
			  <jsp:param name="value" value='<%= judgedModel == null ? "" : judgedModel.getModellerID() %>'/>
			  <jsp:param name="disabled" value='<%= judgedModel == null ? ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE : "disabled" %>'/>
			  <jsp:param name="size" value='3'/>
			  <jsp:param name="caption" value='<%= language.getString("userID") %>'/>
			</jsp:include>

<%-- 			  <jsp:param name="disabled" value='<%= judgedModel == null ? ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE : "disabled" %>'/> --%>
			<jsp:include page="fillableFormField.jsp">
			  <jsp:param name="name" value="<%= JudgingServlet.RequestParameter.ModelID.name() %>"/>
			  <jsp:param name="value" value='<%= judgedModel == null ? "" : judgedModel.getModelID() %>'/>
			  <jsp:param name="size" value='3'/>
			  <jsp:param name="onChange" value='setModelInSession(this.value);'/>
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
			  <jsp:param name="disabled" value='<%= judge == null ? ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE : judge %>'/>
			  <jsp:param name="caption" value='<%= language.getString("judge") %>'/>
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
				<tr style="border: 1px solid; <%= hasScore ? "" : unjudgedCriteriaStyle%>">
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
						onchange="parentNode.parentNode.parentNode.style = 'border: 1px solid; ';"
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
					><%= judgedModel != null ? getComment(judgedModel, scores) : "" %></textarea></td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<input type="submit" value='<%= language.getString("save") %>'>
				<input name='finishRegistration' type='submit' value='<%= language.getString("judging.finish") %>'>
				
<a href="../../JudgingServlet"><%= language.getString("proceed.to.main") %></a>
			</td>
		</tr>
	</table>
</form>

<%!

String getComment(JudgedModel judgedModel, Map<Integer, List<JudgingScore>> scores)
{
	try
	{
		return scores.values().iterator().next().get(0).getComment();
	}
	catch(Exception ex)
	{
		return "";
	}
}

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