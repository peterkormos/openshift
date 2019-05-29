<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@page import="java.util.*" %>    
<%@page import="datatype.*" %>    
<%@page import="servlet.*" %>
<%@page import="util.*" %>
    
<%
		RegistrationServlet servlet = RegistrationServlet.getInstance(config);
		ServletDAO servletDAO = RegistrationServlet.getServletDAO();
		
		String show = RegistrationServlet.getShowFromSession(session);
		if (show == null)
		{
		  show = "-";
		}
		
		if (servlet.isRegistrationAllowed(show)) 
		{
			final User user = RegistrationServlet.getUser(request);
			  final ResourceBundle language = (ResourceBundle)session.getAttribute(SessionAttributes.Language.name());
	
			String action = ServletUtil.getRequestAttribute(request, SessionAttributes.Action.name()); 
			String submitLabel = ServletUtil.getRequestAttribute(request, SessionAttributes.SubmitLabel.name());
			
			final List<Model> models = servletDAO.getModels(user.userID);
	
			if (models.isEmpty()) {
				response.sendRedirect("jsp/main.jsp");
				return;
			}
/*
			else if(models.size() == 1)
			{
				response.sendRedirect("../RegistrationServlet/" + action + "?" + "modelID" + "=" + models.get(0).getModelID());			
			}
*/
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
		<link rel='stylesheet' href='base.css' media='screen' />

<script type="text/javascript">
// <!--
function checkMandatory(form)
{
	var returned = true;
	
	if(form.modelID.checked == true)
		return true;

	for(i = 0; i < form.modelID.length; i++)
	{
		if(form.modelID[i].checked == true)
			return true;
	}
	document.getElementById("errorDiv").className = "flash Error";
	document.getElementById('noticeDiv').innerHTML = '<%=language.getString("select")%>';
	return false; 
}


//-->
</script>
</head>
<body>

		<form accept-charset='UTF-8' name='input' action='../RegistrationServlet' method='put' target='_top' onsubmit="return checkMandatory(this);">
		<input type='hidden' name='command' value='<%= action %>'>
		
		<input name='<%= action %>' type='submit' value='<%= language.getString(submitLabel) %>'>
		<p>

<div id=errorDiv>
<div id="noticeDiv"></div>
<br>
<%
			for (final Model model : models) 
			{
 %>
 			<label>
			<input type='radio' name='modelID' value='<%= model.modelID %>' <%= (models.size() == 1 ? " checked='checked' " : "")  %>/>
			<%=model.scale + " - " + model.producer + " - " + model.name %>
			</label>
			<br>
<%
			}
		}
		else {
			response.sendRedirect("jsp/main.jsp");
		}
 %>
</div>

<script type="text/javascript">
var form = document.getElementsByName('input')[0];
if(form.modelID.checked == true)
	form.submit();
	
</script>

		</form>

</body>
</html>