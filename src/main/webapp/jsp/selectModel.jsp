<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@page import="java.util.*" %>    
<%@page import="datatype.*" %>    
<%@page import="servlet.*" %>
    
<%
		RegistrationServlet servlet = RegistrationServlet.getInstance(config);
		ServletDAO servletDAO = servlet.getServletDAO();
		
		if (servlet.isRegistrationAllowed()) 
		{
			final User user = RegistrationServlet.getUser(request);
			final ResourceBundle language = servlet.getLanguage(user.language);
	
			final List<Model> models = servletDAO.getModels(user.userID);
	
			if (models.isEmpty()) {
				response.sendRedirect("jsp/main.jsp");
				return;
			}
	
			String action = ServletUtil.getRequestAttribute(request, RegistrationServlet.SessionAttributes.Action.name()); 
			String submitLabel = ServletUtil.getRequestAttribute(request, RegistrationServlet.SessionAttributes.SubmitLabel.name());
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
			<input type='radio' name='modelID' value='<%= model.modelID %>' <%= (models.size() == 1 ? "checked" : "")  %>/>
			<%=model.scale + " - " + model.producer + " - " + model.name %>
			<br>
			</label>
<%
		}
		} else {
			response.sendRedirect("jsp/main.jsp");
		}
 %>
</div>
		</form>

</body>
</html>