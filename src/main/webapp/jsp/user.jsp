<%@page import="util.CommonSessionAttribute"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="servlet.RegistrationServlet.RequestParameter"%>

<%@page import="java.util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil"
	scope="application" />

<%
//input parameters	
boolean directRegister = Boolean.parseBoolean(ServletUtil.getOptionalRequestAttribute(request, "directRegister"));
if (directRegister)
	session.removeAttribute(CommonSessionAttribute.UserID.name());

String action = request.getParameter("action");

RegistrationServlet servlet = RegistrationServlet.getInstance(config);

String languageCode = null;
User user = null;
try {
	user = RegistrationServlet.getUser(request);
	languageCode = user.language;
} catch (Exception e) {
	languageCode = ServletUtil.getRequestAttribute(request, RequestParameter.Language.getParameterName());
}

ResourceBundle language = languageUtil.getLanguage(languageCode);
session.setAttribute(CommonSessionAttribute.Language.name(), language);
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
	confirmed = confirm('<%=language.getString("delete.confirm")%>'); 
	
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
	        	document.getElementById('noticeDiv').innerHTML = '<%= language.getString("passwords.not.same") %>';
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
	        	document.getElementById('noticeDiv').innerHTML = '<%= language.getString("emails.not.same") %>';
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
				document.getElementById('noticeDiv').innerHTML = '<%= language.getString("name.too.short") %>';
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
<link rel="stylesheet" href="base.css" media="screen" type="text/css"/>
</head>


<body>

	<div class="header"></div>

	<form autocomplete="fuckoffchrome" name="input" id="input"
		action="../RegistrationServlet/<%=action%>" method="put"
		accept-charset="UTF-8"
		onSubmit="return checkEmail(this) && checkPassword(this) && checkName(this)">
		<input type="hidden" id="command" name="command" value="">
		<p>
			<font color="#FF0000" size="+3">&#8226;</font>
			<%=language.getString("mandatory.fields")%></p>
		<table width="47%" border="0">

			<%
			if (!directRegister) {
			%>
			<tr bgcolor='F6F4F0'>
				<td><%=language.getString("email")%>:</td>
				<td><input autocomplete="fuckoffchrome" name="email"
					type="text" value="<%=user == null ? "" : user.email%>"
					onchange="updateMandatoryFieldMark(this);"> <font
					color="#FF0000" size="+3">&#8226;</font></td>
			</tr>
			<tr>
				<td><%=language.getString("email.again")%>:</td>
				<td><input autocomplete="fuckoffchrome" name="email2"
					type="text" value="<%=user == null ? "" : user.email%>"
					onchange="updateMandatoryFieldMark(this);"> <font
					color="#FF0000" size="+3">&#8226;</font></td>
			</tr>
			<tr bgcolor='F6F4F0'>
				<td width="32%"><strong><%=language.getString("password")%>:
				</strong></td>
				<td width="68%"><input autocomplete="fuckoffchrome"
					name="password" type="password"
					onchange="updateMandatoryFieldMark(this);"> <font
					color="#FF0000" size="+3">&#8226;</font></td>
			</tr>
			<tr>
				<td><strong><%=language.getString("password.again")%>:
				</strong></td>
				<td><input autocomplete="fuckoffchrome" name="password2"
					type="password" onchange="updateMandatoryFieldMark(this);">
					<font color="#FF0000" size="+3">&#8226;</font></td>
			</tr>
			<%
			}
			%>
			<tr bgcolor='F6F4F0'>
				<td><%=language.getString("name")%>:</td>
				<td>
					<div id='fullnames'>
						<input autocomplete="fuckoffchrome" name="fullname" type="text"
							value="<%=user == null ? "" : user.lastName%>" id="fullnameID"
							onChange="sendRequest(); updateMandatoryFieldMark(this);">
						<font color="#FF0000" size="+3">&#8226;</font>
						<%
						if (directRegister) {
						%>
						- <select id="selectID" name="lastname_select"
							onChange="loginUser(options[selectedIndex].value);">
						</select>
						<%
						}
						%>
					</div>
				</td>
			</tr>
			<tr>
				<td><%=language.getString("year.of.birth")%>:</td>
				<td>
					<%
					String yearOfBirth = "";

					if (user == null) {
						if (directRegister)
							yearOfBirth = "2021";
					} else
						yearOfBirth = String.valueOf(user.yearOfBirth);
					%> <jsp:include page="year.jsp">
						<jsp:param name="selectLabel" value="<%=yearOfBirth%>" />
						<jsp:param name="selectValue" value="<%=yearOfBirth%>" />
					</jsp:include> <font color="#FF0000" size="+3">&#8226;</font>
				</td>
			</tr>
			<tr bgcolor='F6F4F0'>
				<td><%=language.getString("language")%>:</td>
				<td>
					<%
					languageCode = "";

					if (user == null) {
						if (directRegister)
							languageCode = "HU";
					} else
						languageCode = user.language;
					%> <jsp:include page="language.jsp">
						<jsp:param name="selectLabel" value="<%=languageCode%>" />
						<jsp:param name="selectValue" value="<%=languageCode%>" />
					</jsp:include> <font color="#FF0000" size="+3">&#8226;</font>
				</td>
			</tr>
			<tr>
				<td><%=language.getString("country")%></td>
				<td>
					<%
					String country = "";

					if (user == null) {
						if (directRegister)
							country = "HU";
					} else
						country = user.country;
					%> <jsp:include page="countries.jsp">
						<jsp:param name="defaultSelectedLabel" value="<%=country%>" />
						<jsp:param name="defaultSelectedValue" value="<%=country%>" />
						<jsp:param name="selectName" value="country" />
					</jsp:include> <font color="#FF0000" size="+3">&#8226;</font>
				</td>
			</tr>
			<tr bgcolor='F6F4F0'>
				<td><%=language.getString("city")%>:</td>
				<td><input autocomplete="fuckoffchrome" name="city" type="text"
					value="<%=user == null ? "" : user.city%>"
					onchange="updateMandatoryFieldMark(this);"> <font
					color="#FF0000" size="+3">&#8226;</font></td>
			</tr>
			<tr>
				<td><%=language.getString("address")%>:</td>
				<td><input autocomplete="fuckoffchrome" name="address"
					type="text" value="<%=user == null ? "" : user.address%>"></td>
			</tr>
			<tr bgcolor='F6F4F0'>
				<td><%=language.getString("telephone")%>:</td>
				<td><input autocomplete="fuckoffchrome" name="telephone"
					type="text" value="<%=user == null ? "" : user.telephone%>"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input autocomplete="fuckoffchrome" type="submit"
					value="<%=language.getString("save")%>">
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
				src="../icons/delete.png" height="30" align="center"> <%=language.getString("delete.user")%></a>
		</p>

		<%
		}
		%>

	</form>
</body>
</html>
