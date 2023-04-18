<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<jsp:useBean id="languageUtil" class="util.LanguageUtil" scope="application"/>

<%
	User user = null;
	try
	{	
		user = RegistrationServlet.getUser(request);
	}
	catch(Exception ex)
	{
		out.print(ex.getMessage());
		return;
	}
	
    RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ServletDAO servletDAO = RegistrationServlet.getServletDAO();
	
	ResourceBundle language = languageUtil.getLanguage(user.language);

	String show = RegistrationServlet.getShowFromSession(session);
	if (show == null)
	{
	  show = ServletUtil.ATTRIBUTE_NOT_FOUND_VALUE;
	}
%>
<html>
<head>

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="base.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
// <!--

function checkDeleteUserRequest()
{
	confirmed = confirm('<%=language.getString("delete.confirm")%>'); 
	
	if(confirmed)
	{
		document.getElementById('command').value='deleteUser';
		document.getElementById('input').submit();
	}
}

//-->
</script>

</head>
<body>

<div class="header"></div>

<form name="input" id="input" onsubmit="myFunction()" action="../RegistrationServlet" method="put" accept-charset="UTF-8">
  <input type='hidden' id='modelID' name='modelID' >
  <input type="hidden" id="command"  name="command" value="">
		<table style="border: 0px; width: 100%">
			<tr>
<%
    if (servlet.isRegistrationAllowed(show))
  {
%> 
				<td style="width: 40px; vertical-align:top;">
						<div class="tooltip">
	<a href="#"
					onClick="document.getElementById('command').value='inputForAddModel';document.getElementById('input').submit();">
							<img src="../icons/add.png" height="30" align="center" /> <span
								class="tooltiptext"> <%=language.getString("add")%></span>
				</a></div>
				</td>
<%
    }
%>

				<td style="width: 40px; vertical-align:top;">
  <div class="tooltip">
  <a href="#" onClick="document.getElementById('command').value='sendEmail';document.getElementById('input').submit();">
  <img src="../icons/email.png" height="30" align="center" /> <span
								class="tooltiptext"> <%=language.getString("send.email")%></span>
						</a></div>
				</td>

				<td style="width: 100%; white-space: nowrap">
<FONT COLOR='#ff0000'>
	<b>
		<%=show%>
		<p>
		<%=servlet.getSystemMessage()%>
	</b>
</FONT>
				</td>

				<td style="width: 40px; text-align: right; vertical-align:top;"
				>
  <div class="tooltip">
  <a href="#" onClick="document.getElementById('command').value='logout';document.getElementById('input').submit();">
  <img src="../icons/exit.png" height="30" align="center" /> <span
								class="tooltiptext tooltiptext-right"> <%=language.getString("logout")%></span>
						</a></div>
				</td>

				<td style="width: 40px; text-align: right; vertical-align:top;">
  <div class="tooltip">
  <a href="#" onClick="document.getElementById('command').name='action';document.getElementById('command').value='modifyUser';document.getElementById('input').action='user.jsp';document.getElementById('input').submit();">
  <img src="../icons/modify2.png" height="30" align="center" /><span
								class="tooltiptext tooltiptext-right"> <%=language.getString("modify.user")%></span>
						</a></div>
				</td>
			</tr>
		</table>
<p></p>

<%
	if (!servlet.isPreRegistrationAllowed(show))
	{
%> 
		<strong><font color='#FF0000'><%=language.getString("pre-registration.closed")%></font></strong> 
<%
	}
 %>


<jsp:include page="notices.jsp" />

<p></p>
								    <!--
  <a href="#" onClick="document.getElementById('command').value='inputForPhotoUpload';document.getElementById('input').submit();">
  <img src="../icons/photo.png" height="30" align="center">language.getString("photo")to")%>
  </a>
 
<p></p>
   -->

<%-- 
  <a href="#" onClick="document.getElementById('command').value='listMyModels';document.getElementById('input').submit();">
  <img src="../icons/list.png" height="30" align="center"> <%=language.getString("list.models")%></a>

<p></p>
 --%>


<%
if(servlet.isOnSiteUse())
{
%>
	<a href='../helyi.html'> helyi.html bet&ouml;lt&eacute;se...</a>
	<p>
	<form name='input' action='../RegistrationServlet' method='put' accept-charset="UTF-8">
	<input type='hidden' name='command' value='printMyModels'>
	&Ouml;sszes makett nevez&eacute;si lapj&aacute;nak nyomtat&aacute;sa: 
	<input name='printMyModels' type='submit' value='<%=language.getString("print.models")%>'>
	</form>
	<p><hr>
	Egy makett nevez&eacute;si lapj&aacute;nak nyomtat&aacute;sa: 
	<jsp:include page="modelSelect.jsp">
	  <jsp:param name="action" value="printMyModels"/>
	  <jsp:param name="submitLabel" value='<%=language.getString("print.models")%>'/>
	</jsp:include>

<%
}
%>
</form>

<jsp:include page="listMyModels.jsp"/>

</body></html>
