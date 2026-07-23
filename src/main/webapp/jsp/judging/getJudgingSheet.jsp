<%@page import="servlet.*"%>
<%@page import="datatype.judging.*"%>
<%@page import="datatype.Model"%>
<%@page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@include file="../util.jsp"%>

<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ServletDAO servletDAO = RegistrationServlet.getServletDAO();
	
	int maxlength = JudgingScore.MAX_COMMENT_LENGTH;
	String unjudgedCriteriaStyle = "background-color: lightgrey;";
	ResourceBundle language = JudgingServlet.getLanguage(session, response);

	JudgingResult judgingResult = (JudgingResult) session
	.getAttribute(JudgingServlet.SessionAttribute.Judgings.name());

	String judge = Optional.ofNullable(judgingResult.getJudge()).orElse("");
	List<JudgingCriteria> criteriaList = judgingResult.getCriterias();
	int categoryId = judgingResult.getCategory();
    String category = servletDAO.getCategory(categoryId).getCategoryCode();
	Map<Integer, JudgingScore> scores = judgingResult.getScores();
	JudgedModel judgedModel = judgingResult.isModelPresent() ? judgingResult : null;
	
	boolean listMode = Boolean.parseBoolean(
	ServletUtil.getOptionalRequestParameter(request, "listMode").
	replaceAll(RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE, "false"));
    
    Boolean simpleJudging = (Boolean) session.getAttribute(JudgingServlet.SessionAttribute.SimpleJudging.name());
    if(simpleJudging == null) {
        simpleJudging = Boolean.valueOf(ServletUtil.getOptionalRequestParameter(request, JudgingServlet.RequestParameter.SimpleJudging.name()));
    }
%>


<%!String getComment(JudgedModel judgedModel, Map<Integer, JudgingScore> scores) {
		try {
			return scores.values().iterator().next().getComment();
		} catch (Exception ex) {
			return "";
		}
	}

String getJudgingCriteriaName(JudgingCriteria criteria, JudgingResult judgingResult, boolean listMode) {
	String returned = JudgingServlet.RequestParameter.JudgingCriteria.name() + criteria.getCriteriaId();
	
	if(listMode)
		returned += judgingResult.getCategory()+judgingResult.getJudge()+judgingResult.getModellerID()+"_"+judgingResult.getModelID();
	return returned;
}
		%>
<link href="../base.css" rel="stylesheet" type="text/css">

<input type="hidden"
    name="<%=JudgingServlet.RequestParameter.SimpleJudging.name()%>"
    value="<%=simpleJudging%>">

<input type="hidden"
	name="<%=JudgingServlet.RequestParameter.Category.name()%>" />
    value="<%=category == null ? "" : category%>">

<table style="border: 1px solid black;">
	<tr>
		<th>
			<%=language.getString("userID")%>
		</th>
		<th>
			<%=language.getString("modelID")%>
		</th>
		<th>
			<%=language.getString("category.code")%>
		</th>
		<th>
			<%=language.getString("judge")%>
		</th>
	</tr>
	
	<tr>
		<td align="center"> 
			<font style="border: 1px solid black; padding: 1mm;">
			<jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.ModellerID.name()%>" />
				<jsp:param name="value"
					value='<%=judgedModel == null ? "" : judgedModel.getModellerID()%>' />
				<jsp:param name="disabled" value='true' />
				<jsp:param name="size" value='3' />
			</jsp:include> 
			</font>
		</td>
		<td align="center"> 
			<jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.ModelID.name()%>" />
				<jsp:param name="value"
					value='<%=judgedModel == null ? "" : judgedModel.getModelID()%>' />
				<jsp:param name="size" value='3' />
				<jsp:param name="onChange" value='setModelInSession(this.value);' />
			</jsp:include> <input type="button" value=">">
		</td>
		<td align="center"> 
			<font style="border: 1px solid black; padding: 1mm;">
			<jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="categoryCode" />
				<jsp:param name="value"
					value='<%=category == null ? "" : category%>' />
				<jsp:param name="disabled" value='true' />
				<jsp:param name="size" value='5' />
			</jsp:include> 
			</font>
		</td>
		<td align="center">
			<jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.Judge.name()%>" />
				<jsp:param name="value" value='<%=judge%>' />
				<jsp:param name="disabled" value='true' />
			</jsp:include>
		</td>
	</tr>

	<tr>
		<td>
			<jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.ModelsName.name()%>" />
				<jsp:param name="value"
					value='<%=judgedModel == null ? "" : judgedModel.getModelsName()%>' />
				<jsp:param name="disabled" value='true' />
				<jsp:param name="caption"
					value='<%=language.getString("models.name")%>' />
			</jsp:include>
		</td>
	</tr>

	<tr height="20px">
	</tr>

	<tr bgcolor="#ddddff">
		<th></th>
		<th><%=language.getString("judging.criteria")%></th>
		<th><%=language.getString("judging.criteria.description")%></th>
		<th><%=language.getString("judging.criteria.score")%></th>
	</tr>
	<%
		for (JudgingCriteria criteria : criteriaList) {
			boolean hasScore = judgedModel != null && scores.get(criteria.getCriteriaId()) != null;
	%>
	<tr
		style="border: 1px solid; <%=hasScore ? "" : unjudgedCriteriaStyle%>">
		<td>
			<label style="color: brown;"> <input type="radio"
					name="<%=JudgingServlet.RequestParameter.JudgingCriteria.name()%><%=criteria.getCriteriaId()%>"
					value="<%=RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE%>"
					onchange="parentNode.parentNode.parentNode.className='strikeout'; parentNode.parentNode.parentNode.style='background-color: lightgrey;'">
					<img src="../../icons/delete.png" height="15" align="center" /> Nem &eacute;rt&eacute;kelem
			</label> 
		</td>
		<td align="center">
			<%=criteria.getCriteriaId()%>
		</td>
		<td align="center"><%=criteria.getDescription()%></td>
		<td>
		<%
		
		if(simpleJudging || criteria.getDescription().isEmpty()) {
			for(String customScore : JudgingCriteria.customScores) {
				 %> 
	<label> <input type="radio"
				name="<%=getJudgingCriteriaName(criteria, judgingResult, listMode)%>"
				value="<%=customScore%>"
				<%=hasScore && scores.get(criteria.getCriteriaId()).getScore().equals(String.valueOf(customScore)) ? "checked='checked'"
							: ""%>
				onchange="parentNode.parentNode.parentNode.className=''; parentNode.parentNode.parentNode.style='border: 1px solid; ';"><%=customScore%>
		</label>			 
				 	<%			
			}
		}
		
 	for (int i = 0; i < criteria.getMaxScore() + 1; i++) {

 			// 								judgingScores.get(i)
 %> <label> <input type="radio"
				name="<%=getJudgingCriteriaName(criteria, judgingResult, listMode)%>"
				value="<%=i%>"
				<%=hasScore && scores.get(criteria.getCriteriaId()).getScore().equals(String.valueOf(i)) ? "checked='checked'"
							: ""%>
				onchange="parentNode.parentNode.parentNode.className=''; parentNode.parentNode.parentNode.style='border: 1px solid; ';"><%=i%>
		</label> <%
 	}
 %></td>
	</tr>
	<%
		}
	%>

	<tr>
		<td colspan="4" style="vertical-align: top;">
			<textarea name='<%=JudgingServlet.RequestParameter.Comment.name()%>'
				style="width: 100%;"
				maxlength='<%=maxlength%>' rows='3'
				placeholder="<%=language.getString("comment")%>: <%=String.format(language.getString("input.text.maxlength"), maxlength)%>"><%=judgedModel != null ? getComment(judgedModel, scores) : ""%></textarea></td>
	</tr>
</table>