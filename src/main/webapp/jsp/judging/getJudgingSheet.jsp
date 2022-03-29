<%@page import="servlet.*"%>
<%@page import="datatype.judging.*"%>
<%@page import="datatype.Model"%>
<%@page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@include file="../util.jsp"%>

<%
	int maxlength = JudgingScore.MAX_COMMENT_LENGTH;
	String unjudgedCriteriaStyle = "background-color: lightgrey;";
	highlightStart = 0xEAEAEA;
	ResourceBundle language = JudgingServlet.getLanguage(session, response);

	JudgingResult judgingResult = (JudgingResult) session
			.getAttribute(JudgingServlet.SessionAttribute.Judgings.name());

	String judge = Optional.ofNullable(judgingResult.getJudge()).orElse("");
	List<JudgingCriteria> criteriaList = judgingResult.getCriterias();
	String category = judgingResult.getCategory();
	Map<Integer, JudgingScore> scores = judgingResult.getScores();
	JudgedModel judgedModel = judgingResult.isModelPresent() ? judgingResult : null;
%>


<%!String getComment(JudgedModel judgedModel, Map<Integer, JudgingScore> scores) {
		try {
			return scores.values().iterator().next().getComment();
		} catch (Exception ex) {
			return "";
		}
	}%>
<link href="../base.css" rel="stylesheet" type="text/css">
<table style="border: 1px solid black;">
	<tr>
		<td colspan="3"><jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.ModellerID.name()%>" />
				<jsp:param name="value"
					value='<%=judgedModel == null ? "" : judgedModel.getModellerID()%>' />
				<jsp:param name="disabled"
					value='<%=judgedModel == null ? ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE : "disabled"%>' />
				<jsp:param name="size" value='3' />
				<jsp:param name="caption" value='<%=language.getString("userID")%>' />
			</jsp:include> <%-- 			  <jsp:param name="disabled" value='<%= judgedModel == null ? ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE : "disabled" %>'/> --%>
			<jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.ModelID.name()%>" />
				<jsp:param name="value"
					value='<%=judgedModel == null ? "" : judgedModel.getModelID()%>' />
				<jsp:param name="size" value='3' />
				<jsp:param name="onChange" value='setModelInSession(this.value);' />
				<jsp:param name="caption" value='<%=language.getString("modelID")%>' />
			</jsp:include> <input type="button" value=">"></td>
	</tr>
	<tr>
		<td colspan="3"><jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.ModelsName.name()%>" />
				<jsp:param name="value"
					value='<%=judgedModel == null ? "" : judgedModel.getModelsName()%>' />
				<jsp:param name="caption"
					value='<%=language.getString("models.name")%>' />
			</jsp:include></td>
	</tr>

	<tr>
		<td colspan="3"><jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.Category.name()%>" />
				<jsp:param name="value"
					value='<%=category == null ? "" : category%>' />
				<jsp:param name="caption"
					value='<%=language.getString("category.code")%>' />
			</jsp:include> <jsp:include page="fillableFormField.jsp">
				<jsp:param name="name"
					value="<%=JudgingServlet.RequestParameter.Judge.name()%>" />
				<jsp:param name="value" value='<%=judge%>' />
				<jsp:param name="disabled"
					value='<%=judge == null ? ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE : judge%>' />
				<jsp:param name="caption" value='<%=language.getString("judge")%>' />
			</jsp:include></td>
	</tr>

	<tr height="20px">
	</tr>

	<tr bgcolor="#ddddff">
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
		<td><%=criteria.getCriteriaId()%></td>
		<td><%=criteria.getDescription()%></td>
		<td><label> <input type="radio"
				name="<%=JudgingServlet.RequestParameter.JudgingCriteria.name()%><%=criteria.getCriteriaId()%>"
				value="<%=ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE%>"
				onchange="parentNode.parentNode.parentNode.style = '<%=unjudgedCriteriaStyle%>';"><%=ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE%>
		</label> <%
 	for (int i = 0; i < criteria.getMaxScore() + 1; i++) {

 			// 								judgingScores.get(i)
 %> <label> <input type="radio"
				name="<%=JudgingServlet.RequestParameter.JudgingCriteria.name()%><%=criteria.getCriteriaId()%>"
				value="<%=i%>"
				<%=hasScore && scores.get(criteria.getCriteriaId()).getScore() == i ? "checked='checked'"
							: ""%>
				onchange="parentNode.parentNode.parentNode.style = 'border: 1px solid; ';"><%=i%>
		</label> <%
 	}
 %></td>
	</tr>
	<%
		}
	%>

	<tr>
		<td colspan="3" style="vertical-align: top;"><%=language.getString("comment")%>:
			<textarea name='<%=JudgingServlet.RequestParameter.Comment.name()%>'
				maxlength='<%=maxlength%>' cols='50' rows='3'
				placeholder="<%=String.format(language.getString("input.text.maxlength"), maxlength)%>"><%=judgedModel != null ? getComment(judgedModel, scores) : ""%></textarea></td>
	</tr>
</table>