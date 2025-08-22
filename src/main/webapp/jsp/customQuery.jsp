<%@page import="datatype.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
    final ResourceBundle language = (ResourceBundle)session.getAttribute(CommonSessionAttribute.Language.name());
%>

<html>
<head>
<link rel="stylesheet" href="base.css" media="screen" />
</head>
<body>
	<form name='input' action='listSelectedModels.jsp' method='put'>
		<table border='0'>

			<tr>
				<td><%=language.getString("category.code")%> :</td>

				<td>
					<%
					  String categoryLabel = language.getString("select");
					  String categoryLabelValue = "";
					%> <jsp:include page="categories.jsp">
						<jsp:param name="selectedLabel" value="<%=categoryLabel%>" />
						<jsp:param name="selectedValue" value="<%=categoryLabelValue%>" />
						<jsp:param name="mandatory" value="false" />
					</jsp:include>

				</td>
			</tr>

			<tr>
				<td><%=language.getString("userID")%> :</td>
				<td><input type='text' name='userID'></td>
			</tr>

			<tr>
				<td><%=language.getString("modelID")%> :</td>
				<td><input type='text' name='modelID'></td>
			</tr>

			<tr>
				<td><%=language.getString("models.name")%> (kis- nagybetu
					szamit):</td>
				<td><input type='text' name='modelname'></td>
			</tr>

			<td><%=language.getString("models.markings")%> :</td>
			<td>
				<%
				  String markingsLabel = language.getString("select");
				  String markingsLabelValue = "";
				%> <jsp:include page="countries.jsp">
					<jsp:param name="defaultSelectedLabel" value="<%=markingsLabel%>" />
					<jsp:param name="defaultSelectedValue"
						value="<%=markingsLabelValue%>" />
					<jsp:param name="selectName" value="markings" />
				</jsp:include>
			</td>
			</tr>

			<tr>
				<td><%=language.getString("models.producer")%> :</td>
				<td><jsp:include page="modelProducers.jsp">
						<jsp:param name="selectValue" value="" />
						<jsp:param name="frequentlyUsed"
							value='<%=language.getString("frequently.used")%>' />
					</jsp:include></td>
			</tr>
			<tr>
				<td>Oversized :</td>
				<td><label><input
						name='filterToOversized' type='checkbox' value='on'> <%=language.getString("yes")%></label></td>
			</tr>

			<tr>
				<td></td>
				<td><input name='selectModel' type='submit'
					value='<%=language.getString("select.models")%>'></td>
			</tr>
		</table>
	</form>
</body>
</html>
