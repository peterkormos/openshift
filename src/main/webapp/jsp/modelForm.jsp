<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@page import="datatype.Detailing.DetailingCriteria"%>
<%@page import="datatype.Detailing.DetailingGroup"%>
<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
    //input parameters	
	String submitLabel = (String)session.getAttribute(RegistrationServlet.SessionAttribute.SubmitLabel.name());
	String action = (String)session.getAttribute(RegistrationServlet.SessionAttribute.Action.name()); 
	Model model = (Model)session.getAttribute(RegistrationServlet.SessionAttribute.Model.name());
 		
	User user = RegistrationServlet.getUser(request);
	
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	ResourceBundle language = (ResourceBundle)session.getAttribute(CommonSessionAttribute.Language.name());
	ServletDAO servletDAO = servlet.getServletDAO();

	if(model == null && RegistrationServlet.Command.modifyModel.name().equals(action) ) {
		response.sendRedirect("main_v2.jsp");
	}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="base.css" media="screen">
<script type="text/javascript" src="util.js"></script>

<script type="text/javascript">
// <!--
function checkMandatory(form)
{
	var returned = true;
	
	returned = checkMandatoryElement(form.modelscale) && returned;
	returned = checkMandatoryElement(form.modelname) && returned;
	returned = checkMandatoryElement(form.modelproducer) && returned;
/*
	returned = checkMandatoryElement(form.gluedToBase[0]) && returned;
	returned = checkMandatoryElement(form.gluedToBase[1]) && returned;
*/
	returned = checkMandatoryElement(form.categoryID) && returned;

	returned = checkMandatoryElement(form.modelWidth) && returned;
	returned = checkMandatoryElement(form.modelHeight) && returned;

	return returned; 
}

function checkMandatoryElement(element)
{
	if (element.value == '' || (element.type == 'radio' && !element.checked))
	{  
		element.className = "flash ERROR";
		return false; 
	} 

	element.className = '';		
	return true; 
}

//-->
</script>

</head>

<body>

<jsp:include page="notices.jsp" />

<form action="<%= (String)session.getAttribute(RegistrationServlet.SessionAttribute.MainPageFile.name()) %>">
	<input class="main" type='submit' value='<%= language.getString("proceed.to.main") %>'>
</form>

<form name='input' id='input' action='../RegistrationServlet' method='POST' accept-charset="UTF-8" onkeypress="return event.keyCode != 13;"
onsubmit="return checkMandatory(this);"
>
<input type='hidden' name='command' value='<%= action %>'>

	<!-- modelID for modify...-->
<%
	if (model != null)
	{
%>
		<input type='hidden' name='modelID' value='<%=model.modelID%>'>
<%
	}
%>
<p><font color='#FF0000' size='+3'>&#8226;</font> <%=language.getString("mandatory.fields")%></p>

<table border='0'>

	<!--	scale-->
<tr>
<td>
<%=language.getString("scale")%>: 
</td>
<td>
<%
String scale = model == null ? "" : model.scale;
%>
<jsp:include page="scales.jsp">
  <jsp:param name="selectValue" value="<%=scale%>"/>
  <jsp:param name="frequentlyUsed" value='<%=language.getString("frequently.used")%>'/>
</jsp:include>
</td>
</tr>

	<!--	models.name-->
<tr bgcolor='F6F4F0'>
<td>
<%=language.getString("models.name")%>: 
</td>
<td>
<%
String modelname = model == null ? "" : model.name;
%>
	<jsp:include page="textInput.jsp">
	  <jsp:param name="name" value="modelname"/>
	  <jsp:param name="value" value="<%=modelname%>"/>
	  <jsp:param name="mandatory" value="true"/>
	  <jsp:param name="maxlength" value="60"/>
	  <jsp:param name="size" value="40"/>
	</jsp:include>
</td>
</tr>

	<!--	models.producer-->
<tr>
<td>
<%=language.getString("models.producer")%>: 
</td>
<td>
<%
String modelproducer = model == null ? "" : model.producer;
%>
<jsp:include page="modelProducers.jsp">
  <jsp:param name="selectValue" value="<%=modelproducer%>"/>
  <jsp:param name="mandatory" value="true"/>
  <jsp:param name="frequentlyUsed" value='<%=language.getString("frequently.used")%>'/>
</jsp:include>
</td>
</tr>

	<!--	glued.to.base-->
<tr bgcolor='F6F4F0'>
<td>
<%=language.getString("glued.to.base")%>: 
</td>

<td>
<label><%=language.getString("yes")%>
 <input style="zoom: 2;" name='gluedToBase' type='radio' value='on' <%=(model == null || !model.gluedToBase ? "" : "checked='checked'")%> 
onchange="updateMandatoryFieldMark(this.parentNode);"
 ></label>
<br>
<label><%=language.getString("no")%>
 <input style="zoom: 2;" name='gluedToBase' type='radio' value='off' <%=(model == null || model.gluedToBase ? "": "checked='checked'")%> 
onchange="updateMandatoryFieldMark(this.parentNode);"
 ></label>
 <font color='#FF0000' size='+3'>&#8226;</font> </td>
</tr>

	<!--	category-->
<tr>
<td>
<%= language.getString("category") %>:
</td>

<td>
<%
	final Category category = model == null ? null : servletDAO.getCategory(model.categoryID);

	String categoryLabel = model == null ? language.getString("select") : category.categoryCode + " - "
	    + category.categoryDescription;
	   
	String categoryLabelValue = model == null ? "" : String.valueOf(category.getId());
%>
<jsp:include page="categories.jsp">
  <jsp:param name="selectedLabel" value="<%= categoryLabel %>"/>
  <jsp:param name="selectedValue" value="<%= categoryLabelValue %>"/>
  <jsp:param name="mandatory" value="true"/>
</jsp:include>
</td>
</tr>

	<!--	comment-->
<!-- <tr bgcolor='F6F4F0'> -->
<!-- <td> -->
<%-- <%=language.getString("comment")%> --%>
<!-- :  -->
<!-- </td> -->
<%-- <td><textarea name='modelcomment' cols='50' rows='10' maxlength="250" placeholder="Max. 250 char."><%=  (model != null) ? model.comment : "" %></textarea></td> --%>
<!-- </tr> -->

<tr bgcolor='F6F4F0'>
	<td>
		<b><%=language.getString("models.space")%>:</b>
	</td>
	<td>
	<b>
	<%=language.getString("models.width")%>:
		<%
		String modelWidth = model == null ? "" : String.valueOf(ModelWithDimension.class.cast(model).getWidth());
		%> <jsp:include page="textInput.jsp">
			<jsp:param name="name" value="modelWidth" />
			<jsp:param name="value" value="<%=modelWidth%>" />
			<jsp:param name="mandatory" value="true" />
			<jsp:param name="maxlength" value="3" />
			<jsp:param name="size" value="10" />
		</jsp:include>

<%=language.getString("models.length")%>:
		<%
		String modelHeight = model == null ? "" : String.valueOf(ModelWithDimension.class.cast(model).getHeight());
		%> <jsp:include page="textInput.jsp">
			<jsp:param name="name" value="modelHeight" />
			<jsp:param name="value" value="<%=modelHeight%>" />
			<jsp:param name="mandatory" value="true" />
			<jsp:param name="maxlength" value="3" />
			<jsp:param name="size" value="10" />
		</jsp:include>
		</b>
	</td>
</tr>

<!--	submit-->
<tr>
<td></td>
<td>
<input name='<%= action %>' type='submit' value='<%= language.getString(submitLabel) %>'>

<%
	if (action == RegistrationServlet.Command.addModel.name() )
	{
%>
<input name='finishRegistration' type='submit' value='<%= language.getString("finish.model.registration") %>'>
<%
	}
%>
</td>
</tr>

	<!--	models.markings-->
<tr>
<td>
<%=language.getString("models.markings")%>: 
</td>
<td>
<%
String markingsLabel =  model == null ? language.getString("select") : model.markings;
String markingsLabelValue = model == null ? "-" : model.markings;
%>
<jsp:include page="countries.jsp">
  <jsp:param name="defaultSelectedLabel" value="<%= markingsLabel %>"/>
  <jsp:param name="defaultSelectedValue" value="<%= markingsLabelValue %>"/>
  <jsp:param name="selectName" value="markings"/>
</jsp:include>
</td>
</tr>

	<!--	models.identification-->
<tr bgcolor='F6F4F0'>
<td>
<%=language.getString("models.identification")%>: 
</td>
<td>
<%
String modelidentification = model == null ? "" : model.identification;
%>
	<jsp:include page="textInput.jsp">
	  <jsp:param name="name" value="identification"/>
	  <jsp:param name="value" value="<%= modelidentification %>"/>
	  <jsp:param name="mandatory" value="false"/>
	<jsp:param name="size" value="40"/>
	</jsp:include>
</td>
</tr>

	<!--	models.detailing-->
<tr>
<td>
<%=language.getString("models.detailing")%>: 
</td>

<td><table cellpadding='5' style='border-collapse: collapse' border='1'>
<tr>
<td>&nbsp;</td>
<%
for (DetailingGroup group : DetailingGroup.values())
	{
%>
<td>
	  <%=language.getString("detailing." + group.name())%>
</td>
<%
	}
%>
</tr>
<%
for (DetailingCriteria criteria : DetailingCriteria.values())
	{
		if(!criteria.isVisible())
			continue;
%>
<tr>
<td>
	  <%=language.getString("detailing." + criteria.name())%>
</td>
<%
for (DetailingGroup group : DetailingGroup.values())
	  {
%>
	<td align="center"><label><input name='<%= "detailing." + group.name() + "." + criteria.name() %>' 
	style="zoom: 2;"
	type='checkbox' value='on' <%= (model == null || !model.getDetailingGroup(group).getCriteria(criteria) ? "" : "checked='checked'")%> ></label></td>
<%	
	  }
%>
</tr>
<%
	}
%>
</table></td>
</tr>

	<!--	submit -->
<tr>
<td></td>
<td><input name='<%= action %>' type='submit' value='<%= language.getString(submitLabel) %>'>

<%
	if (action == RegistrationServlet.Command.addModel.name())
	{
%>
<input name='finishRegistration' type='submit' value='<%= language.getString("finish.model.registration") %>'>
<%
	}
%>
</td></tr>

</table>

</form></body></html>


