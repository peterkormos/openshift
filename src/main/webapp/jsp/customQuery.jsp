<%@page import="datatype.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
final ResourceBundle language = (ResourceBundle) session.getAttribute(CommonSessionAttribute.Language.name());
%>

<html>
<head>
<link rel="stylesheet" href="base.css" media="screen" />
</head>
<body>
	<form name='input' action='listSelectedModels.jsp' method='put'>
		<table border='0'>

			<tr>
				<td>
					<%
					String categoryLabel = language.getString("select");
					String categoryLabelValue = "";
					%> <jsp:include page="categories.jsp">
						<jsp:param name="label"
							value='<%=language.getString("category.code")%>' />
						<jsp:param name="selectedLabel" value="<%=categoryLabel%>" />
						<jsp:param name="selectedValue" value="<%=categoryLabelValue%>" />
						<jsp:param name="mandatory" value="false" />
					</jsp:include>

				</td>
			</tr>

			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="userID" />
						<jsp:param name="label" value='<%=language.getString("userID")%>' />
					</jsp:include></td>
			</tr>

			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="modelID" />
						<jsp:param name="label" value='<%=language.getString("modelID")%>' />
					</jsp:include></td>
			</tr>

			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="modelname" />
						<jsp:param name="label"
							value='<%=language.getString("models.name")%>' />
					</jsp:include></td>
			</tr>
			<td>
				<%
				String markingsLabel = language.getString("select");
				String markingsLabelValue = "";
				%> <jsp:include page="countries.jsp">
					<jsp:param name="label"
						value='<%=language.getString("models.markings")%>' />
					<jsp:param name="defaultSelectedLabel" value="<%=markingsLabel%>" />
					<jsp:param name="defaultSelectedValue"
						value="<%=markingsLabelValue%>" />
					<jsp:param name="selectName" value="markings" />
				</jsp:include>
			</td>
			</tr>

			<tr>
				<td><jsp:include page="modelProducers.jsp">
						<jsp:param name="label"
							value='<%=language.getString("models.producer")%>' />
						<jsp:param name="selectValue" value="" />
						<jsp:param name="frequentlyUsed"
							value='<%=language.getString("frequently.used")%>' />
					</jsp:include></td>
			</tr>
			<tr>
				<td>Oversized: <label><input name='filterToOversized'
						type='checkbox' value='on'> <%=language.getString("yes")%></label></td>
			</tr>

			<tr>
				<td><input name='selectModel' type='submit'
					value='<%=language.getString("select.models")%>'></td>
			</tr>
		</table>
	</form>
</body>
</html>
