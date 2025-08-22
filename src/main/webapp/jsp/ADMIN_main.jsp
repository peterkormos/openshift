<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<html>

<head>
<link rel="stylesheet" href="base.css" media="screen" />
<script type="text/javascript" src="findUser.js"></script>
<script src="jquery.min.js"></script>
</head>
<body <%= request.getRequestURL().indexOf("localhost") > -1 ? "" : "style='background-color: #FFCCCC;'" %>>

<jsp:include page="CATEGORY_main.jsp" />

<p></p>
<jsp:include page="ADMIN_egyeb.jsp" />
<p></p>

	<p></p>

<form accept-charset="UTF-8" name="input" id="input5" action="../RegistrationServlet" method="post">
<input type="hidden" id="command5" name="command" value="">
	Mesteroklevelesek rögzítése. Makettez&#337; neve:  
	<input name="lastname" type="text" id="fullnameID"  onChange="sendRequest();">
    - 
    <select id="selectID" name="userID">
    </select>
	
	Szakoszt&aacute;ly: <select name="modelClass">
		<%
		  for (ModelClass mc : ModelClass.values())
		  {
		%>
		<option value='<%=mc.name()%>'><%=mc.name()%></option>
		<%
		  }
		%>
	</select> <a href="#"
		onClick="document.getElementById('command5').value='saveModelClass';this.parentNode.submit();">Szakoszt&aacute;ly
		ment&eacute;se</a>

</form>
</body>
</html>
