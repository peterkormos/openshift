<%@page import="util.CommonSessionAttribute"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="servlet.RegistrationServlet.RequestParameter"%>

<%@page import="java.util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />
<%@include file="util.jsp"%>

<%
//input parameters	
boolean directRegister = Boolean.parseBoolean(ServletUtil.getOptionalRequestParameter(request, "directRegister"));

String action = request.getParameter("action");
if (action == null) {
	action = (String)session.getAttribute(RegistrationServlet.SessionAttribute.Action.name());
}

RegistrationServlet servlet = RegistrationServlet.getInstance(config);

String languageCode = null;
User user = null;
try {
	if (!directRegister) {
		user = RegistrationServlet.getUser(request);
	}
	languageCode = user.language;
} catch (Exception e) {
	languageCode = ServletUtil.getRequestParameter(request, RequestParameter.Language.getParameterName());
}

ResourceBundle language = languageUtil.getLanguage(languageCode);
session.setAttribute(CommonSessionAttribute.Language.name(), language);

String passwordCheck = RegistrationServlet.isAdminSession(session) ? "" :  "&& checkPassword(this) ";
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javascript" src="findUser.js"></script>
<script type="text/javascript" src="util.js"></script>
<script type="text/javascript">
function checkDeleteUserRequest()
{
	confirmed = confirm('<%=ServletUtil.getLabel(request, servlet, "delete.confirm")%>'); 
	
	if(confirmed)
	{
		document.getElementById('command').value='deleteUser';
		document.getElementById('input').action="../RegistrationServlet";
		document.getElementById('input').submit();
	}
}
	    function checkPassword(form) { 
	        password1 = form.password.value; 
	        password2 = form.password2.value; 
	
	        if (password1 == '' || password2 == '' || password1 != password2)
	        {  
	        	document.getElementById('noticeDiv').innerHTML = '<%=ServletUtil.getLabel(request, servlet, "passwords.not.same")%>';
				document.getElementById('noticeDiv').className ="flash ERROR";
				return false; 
	        } 
	        else
	        {  
				return checkOK(); 
	        } 
	    } 
	    function checkEmail(form) { 
	        email1 = form.email.value; 
	        email2 = form.email2.value; 
	
	        if (email1 == '' || email2 == '' || email1 != email2)
	        {  
	        	document.getElementById('noticeDiv').innerHTML = '<%=ServletUtil.getLabel(request, servlet, "emails.not.same")%>';
				document.getElementById('noticeDiv').className ="flash ERROR";
				return false; 
	        } 
	        else
	        {  
				return checkOK(); 
	        } 
	    }

	    function checkName(form) {
			if(form.fullname.value.split(' ').length == 1) {
				document.getElementById('noticeDiv').innerHTML = '<%=ServletUtil.getLabel(request, servlet, "name.too.short")%>';
			document.getElementById('noticeDiv').className = "flash ERROR";
			return false;
		} else {
			return checkOK();
		}
	}

	function checkOK() {
		document.getElementById('noticeDiv').innerHTML = '';
		document.getElementById('noticeDiv').className = "";
		return true;
	}
</script>
<link rel="stylesheet" href="base.css" media="screen" type="text/css" />
</head>


<body>

	<div class="header"></div>

	<form autocomplete="off" name="input" id="input"
		action="../RegistrationServlet/<%=action%>" method="put"
		accept-charset="UTF-8"
<%-- 		onSubmit='return checkEmail(this) <%= passwordCheck %> && checkName(this)'> --%>
		onSubmit='return checkEmail(this) <%= passwordCheck %> && checkName(this)'>
		<input type="hidden" id="command" name="command" value="">
		<p>
			<font color="#FF0000" size="+3">&#8226;</font>
			<%=ServletUtil.getLabel(request, servlet, "mandatory.fields")%></p>
		<table width="47%" border="0">
		
			<%
			if (action.equals("register")) {
			%>
				<jsp:include page="shows.jsp"></jsp:include>
				<jsp:include page="loginConsent.jsp"></jsp:include>
			<%
			}
			%>

			<%
			if (!directRegister) {
			%>
			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="email" />
						<jsp:param name="size" value="30" />
						<jsp:param name="value"
							value='<%=user == null ? "" : user.email%>' />
						<jsp:param name="label" value='<%=ServletUtil.getLabel(request, servlet, "email")%>' />
						<jsp:param name="mandatory" value="true" />
					</jsp:include></td>
			</tr>
			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="email2" />
						<jsp:param name="size" value="30" />
						<jsp:param name="value"
							value='<%=user == null ? "" : user.email%>' />
						<jsp:param name="label"
							value='<%=ServletUtil.getLabel(request, servlet, "email.again")%>' />
						<jsp:param name="mandatory" value="true" />
					</jsp:include></td>
			</tr>
			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="password" />
						<jsp:param name="size" value="30" />
						<jsp:param name="inputType" value="password" />
						<jsp:param name="label"
							value='<%=ServletUtil.getLabel(request, servlet, "password")%>' />
						<jsp:param name="mandatory" value='<%=!RegistrationServlet.isAdminSession(session) %>' />
					</jsp:include></td>
			</tr>
			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="password2" />
						<jsp:param name="size" value="30" />
						<jsp:param name="inputType" value="password" />
						<jsp:param name="label"
							value='<%=ServletUtil.getLabel(request, servlet, "password.again")%>' />
						<jsp:param name="mandatory" value='<%=!RegistrationServlet.isAdminSession(session) %>' />
					</jsp:include></td>
			</tr>
			<%
			}
			%>
			<tr>
				<td>
					<div id='fullnames'>
						<div class="input-caption-container">
							<input autocomplete="off" name="fullname" type="text"
								size="30" value="<%=user == null ? "" : user.lastName%>"
								id="fullnameID"
								required='required'
								onChange="<%=directRegister ? "sendRequest(); " : "" %> updateMandatoryFieldMark(this);"
								>
							<%
							if (directRegister) {
							%>
							- <select id="selectID" name="lastname_select"
								onChange="loginUser(options[selectedIndex].value);">
							</select>
							<%
							}
							%>
							<label for="fullname" class="input-caption"><%=ServletUtil.getLabel(request, servlet, "name")%></label>
							<font color="#FF0000" size="+3">&#8226;</font>
						</div>
					</div>
				</td>
			</tr>
			<tr
				<%
				if (user != null && user.getGender() == null) {
				%>
				bgcolor="<%= highlight(true)%>"
				<%
				}
				%>
			>
				<td>
					<div class="input-caption-container">
						<fieldset id="genderGroup" style="display: inline; padding: 15px;" >
							<%
							if (user != null && user.getGender() == null) {
							%>
							<img src="../icons/new.png">
							<%
							}
							%>
							<%
							for (final Gender gender : Gender.values()) {
							%>
							<label> <input type='radio' name='gender'
								onchange="updateMandatoryFieldMark(this.parentNode.parentNode.parentNode); checkSubmit(document.getElementById('inputForm'));"
								value='<%=gender.name()%>'
								<%=(user == null ? "" : gender.equals(user.getGender()) ? " checked='checked'" : "")%> 
								required='required'
								/>
								<%=ServletUtil.getLabel(request, servlet, gender.name())%>
							</label><br>
							<%
							}
							%>
						</fieldset>
						<label for="genderGroup" class="input-caption"><%=ServletUtil.getLabel(request, servlet, "gender")%></label>
						<font color='#FF0000' size='+3'>&#8226;</font>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<%
					String yearOfBirth = "";

					if (user == null) {
						if (directRegister)
							yearOfBirth = "2021";
					} else
						yearOfBirth = String.valueOf(user.yearOfBirth);
					%> <jsp:include page="year.jsp">
						<jsp:param name="label"
							value='<%=ServletUtil.getLabel(request, servlet, "year.of.birth")%>' />
						<jsp:param name="selectLabel" value="<%=yearOfBirth%>" />
						<jsp:param name="selectValue" value="<%=yearOfBirth%>" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<td>
					<%
					languageCode = "";

					if (user == null) {
						if (directRegister)
							languageCode = RegistrationServlet.DEFAULT_LANGUAGE;
					} else
						languageCode = user.language;
					%> <jsp:include page="language.jsp">
						<jsp:param name="mandatory" value="true" />
						<jsp:param name="label"
							value='<%=ServletUtil.getLabel(request, servlet, "language")%>' />
						<jsp:param name="selectLabel" value="<%=LanguageUtil.getLanguages().get(languageCode)%>" />
						<jsp:param name="selectValue" value="<%=languageCode%>" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<td>
					<%
					String country = "";

					if (user == null) {
						if (directRegister)
							country = "Hungary";
					} else
						country = user.country;
					%> <jsp:include page="countries.jsp">
						<jsp:param name="mandatory" value="true" />
						<jsp:param name="label" value='<%=ServletUtil.getLabel(request, servlet, "country")%>' />
						<jsp:param name="defaultSelectedLabel" value="<%=country%>" />
						<jsp:param name="defaultSelectedValue" value="<%=country%>" />
						<jsp:param name="selectName" value="country" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="city" />
						<jsp:param name="size" value="30" />
						<jsp:param name="label" value='<%=ServletUtil.getLabel(request, servlet, "city")%>' />
						<jsp:param name="value" value='<%=user == null ? "" : user.city%>' />
						<jsp:param name="mandatory" value="true" />
					</jsp:include></td>
			</tr>
			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="address" />
						<jsp:param name="size" value="30" />
						<jsp:param name="label" value='<%=ServletUtil.getLabel(request, servlet, "address")%>' />
						<jsp:param name="value"
							value='<%=user == null ? "" : user.address%>' />
					</jsp:include></td>
			</tr>
			<tr>
				<td><jsp:include page="textInput.jsp">
						<jsp:param name="name" value="telephone" />
						<jsp:param name="size" value="30" />
						<jsp:param name="label"
							value='<%=ServletUtil.getLabel(request, servlet, "telephone")%>' />
						<jsp:param name="value"
							value='<%=user == null ? "" : user.telephone%>' />
					</jsp:include></td>
			</tr>
			<tr>
				<td><input type="submit"
					value="<%=ServletUtil.getLabel(request, servlet, "save")%>">
					<p>
					<div id="noticeDiv"></div></td>
			</tr>
		</table>
		<%
		if (user != null) {
		%>
		<p>
			<a href="#" onClick="checkDeleteUserRequest();"
				style="color: rgb(255, 0, 0); font-weight: bold"> <img
				src="../icons/delete.png" height="30" align="center"> <%=ServletUtil.getLabel(request, servlet, "delete.user")%></a>
		</p>

		<%
		}
		%>

	</form>
</body>
</html>
