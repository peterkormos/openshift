<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	User user = RegistrationServlet.getUser(request);

	if (user.language.length() != 2)
	{
	  response.sendRedirect(user.language + "_main.jsp");
	  return;
	}

	final ResourceBundle language = servlet.getLanguage(user.language);
	String show = RegistrationServlet.getShowFromSession(session);
	if (show == null)
	{
	  show = "-";
	}
%>
<html>
<head>
<link href="base.css" rel="stylesheet" type="text/css">
</head>
<body>

<div class="header"></div>

<p>
<FONT COLOR='#ff0000'><b><%=language.getString("show")%>: <%=show%>
<p>
<p>
<%=servlet.getSystemMessage()%>
</b></FONT>

<p></p>
<p></p>

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

function showModal(location)
{
	document.getElementById('iframeID').src = location;

	var modal = document.getElementById('modalDiv');
	modal.style.display = "block";

	// Get the <span> element that closes the modal
//	document.getElementsByClassName("close")[0]
	var span = 
	modal.getElementsByClassName("close")[0]
	.onclick = function() {
	  modal.style.display = "none";
	}

	// When the user clicks anywhere outside of the modal, close it
	window.onclick = function(event) {
	  if (event.target == modal) {
		modal.style.display = "none";
	  }
	}
}

function onIFrameLoad(iframe)
{
	if(iframe.contentWindow.location.href.includes("main.jsp"))
	{
		window.location.replace(iframe.contentWindow.location.href);
		return;
	}
}
//-->
</script>

<jsp:include page="notices.jsp" />

<p></p>

<div id="modalDiv" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
	<iframe id="iframeID" style="border:none;width: 100%;height: 100%;" onload="onIFrameLoad(this)"></iframe>
  </div>
</div>

<form name="input" id="input" onsubmit="myFunction()" action="../RegistrationServlet" method="put" accept-charset="UTF-8">
  <input type="hidden" id="command"  name="command" value="">

<%
  if (servlet.isRegistrationAllowed())
  {
%>
  <a href="#" onClick="document.getElementById('command').value='inputForAddModel';this.parentNode.submit();">
  <img src="../icons/add.png" height="30" align="center"> <%=language.getString("add")%></a>
<p></p>
<%
  }
%>
								    <!--
  <a href="#" onClick="document.getElementById('command').value='inputForPhotoUpload';this.parentNode.submit();">
  <img src="../icons/photo.png" height="30" align="center"> <%=language.getString("photo")%>
  </a>
 
<p></p>
   -->
<%
  if (servlet.isRegistrationAllowed())
  {
%>
  <a href="#" onClick="showModal('selectModel.jsp?<%= RegistrationServlet.SessionAttributes.Action.name() %>=inputForModifyModel&<%= RegistrationServlet.SessionAttributes.SubmitLabel.name() %>=modify');">
  <img src="../icons/modify.png" height="30" align="center"> <%=language.getString("modify.model")%></a>

<p></p>
   
  <a href="#" onClick="showModal('selectModel.jsp?<%= RegistrationServlet.SessionAttributes.Action.name() %>=deleteModel&<%= RegistrationServlet.SessionAttributes.SubmitLabel.name() %>=delete');">
  <img src="../icons/delete2.png" height="30" align="center"> <%=language.getString("delete")%></a>

<p></p>
<%
}
%>

<%-- 
  <a href="#" onClick="document.getElementById('command').value='listMyModels';this.parentNode.submit();">
  <img src="../icons/list.png" height="30" align="center"> <%=language.getString("list.models")%></a>

<p></p>
 --%>

  <a href="#" onClick="document.getElementById('command').value='sendEmail';this.parentNode.submit();">
  <img src="../icons/email.png" height="30" align="center"> <%=language.getString("send.email")%></a>

<p></p>
    
  <a href="#" onClick="document.getElementById('command').value='logout';this.parentNode.submit();">
  <img src="../icons/exit.png" height="30" align="center"> <%=language.getString("logout")%></a>

<p></p>
   
  <a href="#" onClick="document.getElementById('command').name='action';document.getElementById('command').value='modifyUser';document.getElementById('input').action='user.jsp';this.parentNode.submit();">
  <img src="../icons/modify2.png" height="30" align="center"> <%=language.getString("modify.user")%></a>

<p></p>

<hr>
	<a href="#" onClick="checkDeleteUserRequest();" style="{color: rgb(255,0,0);font-weight:bold}">
  <img src="../icons/delete.png" height="30" align="center"> <%=language.getString("delete.user")%></a>

</form>
<hr>
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

<%=language.getString("list.models")%>
<p>

<jsp:include page="listMyModels.jsp"/>

</body></html>
