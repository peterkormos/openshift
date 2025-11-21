<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%
RegistrationServlet servlet = RegistrationServlet.getInstance(config);
String show = RegistrationServlet.getShowFromSession(session);
if (show == null) {
	show = RegistrationServlet.ATTRIBUTE_NOT_FOUND_VALUE;
}
%>
<p>
	<a href="../RegistrationServlet/encodeCategorGroups">Kateg&oacute;riacsoport
		k&oacute;dol&aacute;sa</a> - <a
		href="../RegistrationServlet/encodeCategories">Kateg&oacute;ria
		k&oacute;dol&aacute;sa</a> - <a href="../RegistrationServlet/encodeModels">Makett
		k&oacute;dol&aacute;sa</a>
</p>
<em><strong>Hibakezel&eacute;s..</strong>.</em>
<p>
	<a href="../RegistrationServlet/exceptionHistory">Exception history</a>
	<a href="ADMIN_systemParameters.jsp">SystemParameters</a>
</p>
<p>
	<em><strong><font color="#FF0000">VIGY&Aacute;ZAT!!!!</font></strong></em>
</p>
<a href="../RegistrationServlet/inputForDeleteUsers"> 1
	felhaszn&aacute;l&oacute; t&ouml;rl&eacute;se az
	adatb&aacute;zisb&oacute;l </a>
<p>
	<a href="../RegistrationServlet/deleteDataForShow"
		style="background: red; font-weight: bold"> Aktu&aacute;lis
		verseny &ouml;sszes makettj&eacute;nek,
		kateg&oacute;ri&aacute;j&aacute;nak t&ouml;rl&eacute;se az
		adatb&aacute;zisb&oacute;l </a>
<p>
	<a href="../RegistrationServlet/deletedirectUsers"
		style="background: red; font-weight: bold"> &Ouml;sszes
		helysz&iacute;nen regisztr&aacute;lt felhaszn&aacute;l&oacute;
		t&ouml;rl&eacute;se </a>
<form accept-charset="UTF-8" name="input" id="input6"
	action="../RegistrationServlet" method="post">
	<input type="hidden" name="command" value="directRegister"> <input
		type="hidden" name="<%=RequestParameter.Language.getParameterName()%>"
		value="<%=User.AdminLanguages.CATEGORY.name()%>"> <input
		type="hidden" name="country" value="HU"> <input type="hidden"
		name="city" value="<%=show%>"> <input type="hidden"
		name="gender" value="<%=Gender.Male.name()%>"> <input
		type="hidden" name="yearofbirth" value="1977"> <input
		type="submit" name="" value="Helyi admin felv&eacute;tele">
	email: <input type="text" name="fullname" value="<%=show%>">
	password: <input type="text" name="password">
</form>
<form accept-charset="UTF-8" name="input"
	action="../RegistrationServlet" method="post">
	<p>SQL update:</p>
	<p>
		<input type="hidden" name="command" value="sql"> <input
			name="sql" type="text" value="" size="150">
	</p>
	<p>update MAK_SYSTEM set PARAM_VALUE='1'</p>
	<p>update MAK_USERS set USER_password='secret' where email='admin'</p>
	<p>update MAK_USERS set USER_LANGUAGE='CATEGORY' where
		EMAIL='category'</p>
	<p>alter table MAK_CATEGORY alter CATEGORY_DESCRIPTION SET DATA
		TYPE varchar(1000)
	<p>alter table MAK_MODEL alter MODEL_NAME set data type varchar
		(200)
	<p>update MAK_USERS set EMAIL='admin' where USER_NAME='admin'
	<p>alter table MAK_USERS drop column USER_NAME
	<p>alter table MAK_MODEL add crd date DEFAULT CURRENT_DATE
	<p>select crd, count(*) from mak_model group by crd
</form>

<form accept-charset="UTF-8" name="input"
	action="../RegistrationServlet/sendEmails" method="post">
	Mindenkinek email küldése. Szöveg:
	<textarea name='message' type="text" cols='100' rows='3'></textarea>
	<input type="submit" value="Küld">
</form>

<form accept-charset="UTF-8" name="input" id="input5"
	action="../RegistrationServlet" method="post">
	<input type="hidden" id="command5" name="command" value="">
	Mesteroklevelesek rögzítése. Makettez&#337; neve: <input
		name="lastname" type="text" id="fullnameID" onChange="sendRequest();">
	- <select id="selectID" name="userID">
	</select> Szakoszt&aacute;ly: <select name="modelClass">
		<%
		for (ModelClass mc : ModelClass.values()) {
		%>
		<option value='<%=mc.name()%>'><%=mc.name()%></option>
		<%
		}
		%>
	</select> <a href="#"
		onClick="document.getElementById('command5').value='saveModelClass';this.parentNode.submit();">Szakoszt&aacute;ly
		ment&eacute;se</a>
</form>
