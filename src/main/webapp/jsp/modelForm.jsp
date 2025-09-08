<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@page import="datatype.DetailingCriteria"%>
<%@page import="datatype.DetailingGroup"%>
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
		response.sendRedirect("main.jsp");
	}

	String logoURL = "../RegistrationServlet/"+RegistrationServlet.Command.LOADIMAGE.name()+"/"+servlet.getLogoIDForShow(servlet.getShowFromSession(request));
	List<Model> models = (List<Model>) session.getAttribute(RegistrationServlet.SessionAttribute.Models.name());
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

<%
if(!servlet.isOnSiteUse())
{
%>

	returned = checkMandatoryElement(form.modelWidth) && returned;
	returned = checkMandatoryElement(form.modelHeight) && returned;
<%
}
%>
	return returned;
	}

	function checkMandatoryElement(element) {
		if (element.value == ''
				|| (element.type == 'radio' && !element.checked)) {
			element.className = "flash ERROR";
			return false;
		}

		element.className = '';
		return true;
	}

	function updateGluedToBaseImg(element) {
		var gluedToBaseImgElement = document.getElementById('gluedToBaseImg');
		gluedToBaseImgElement.style = 'visibility: visible';
		gluedToBaseImgElement.src = element.value == 'on' ? '../icons/glued.jpg'
				: '../icons/notglued.jpg';
	}
//-->
</script>

</head>

<body>

	<jsp:include page="notices.jsp" />

	<form
		action="<%=(String) session.getAttribute(RegistrationServlet.SessionAttribute.MainPageFile.name())%>">
		<table style="border: 0px; box-shadow: none; width: 100%">
			<tr>
				<td style="white-space: nowrap;"><input class="main" type='submit'
					value='<%=language.getString("proceed.to.main")%>'>
					
					<div class="tooltip">
						<a href="../RegistrationServlet/sendEmail"> <img
							src="../icons/email.png" height="30" align="center" /> <span
							class="tooltiptext"> <%=language.getString("send.email")%></span>
							 <%=language.getString("send.email")%>
						</a>
					</div>
					
					</td>
				<td style="width: 100%; white-space: nowrap"><FONT
					COLOR='#ff0000'> <b> <%=servlet.getSystemMessage()%>
					</b>
				</FONT></td>

				<td style="width: 40px; text-align: right; vertical-align: top;">
					<div class="tooltip">
						<a href="../RegistrationServlet/logout"> <img
							src="../icons/exit.png" height="30" align="center" /> <span
							class="tooltiptext tooltiptext-right"> <%=language.getString("logout")%></span>
						</a>
					</div>
				</td>

				<td style="width: 40px; text-align: right; vertical-align: top;">
					<div class="tooltip">
						<a href="#"
							onClick="document.getElementById('command').name='action';document.getElementById('command').value='modifyUser';document.getElementById('input').action='user.jsp';document.getElementById('input').submit();">
							<img src="../icons/modify2.png" height="30" align="center" /><span
							class="tooltiptext tooltiptext-right"> <%=language.getString("modify.user")%></span>
						</a>
					</div>
				</td>
			</tr>
		</table>
	</form>

	<jsp:include page="ADMIN_helyi.jsp" />

	<form name='input' id='input' action='../RegistrationServlet'
		method='POST' accept-charset="UTF-8"
		onkeypress="return event.keyCode != 13;"
		onsubmit="return checkMandatory(this);">
		<input type='hidden' name='command' id='command' value='<%=action%>'>

		<!-- modelID for modify...-->
		<%
		if (model != null) {
		%>
		<input type='hidden' name='modelID' value='<%=model.getId()%>'>
		<%
		}
		%>
		<p>
			<font color='#FF0000' size='+3'>&#8226;</font>
			<%=language.getString("mandatory.fields")%></p>

		<table border='0'>

			<!--	scale-->
			<tr>

				<td>
					<%
					String scale = model == null ? "" : model.scale;
					%> <jsp:include page="scales.jsp">
						<jsp:param name="selectValue" value="<%=scale%>" />
						<jsp:param name="label" value='<%=language.getString("scale")%>' />
						<jsp:param name="frequentlyUsed"
							value='<%=language.getString("frequently.used")%>' />
					</jsp:include>
				</td>
				<td rowspan="3"><img style="height: 25mm" src='<%=logoURL%>'>
				</td>
			</tr>

			<!--	models.name-->
			<tr>

				<td>
					<%
					String modelname = model == null ? "" : model.name;
					%> <jsp:include page="textInput.jsp">
						<jsp:param name="name" value="modelname" />
						<jsp:param name="value" value="<%=modelname%>" />
						<jsp:param name="label"
							value='<%=language.getString("models.name")%>' />
						<jsp:param name="mandatory" value="true" />
						<jsp:param name="maxlength" value="60" />
						<jsp:param name="size" value="60" />
					</jsp:include>
				</td>
			</tr>

			<!--	models.producer-->
			<tr>

				<td>
					<%
					String modelproducer = model == null ? "" : model.producer;
					%> <jsp:include page="modelProducers.jsp">
						<jsp:param name="selectValue" value="<%=modelproducer%>" />
						<jsp:param name="label"
							value='<%=language.getString("models.producer")%>' />
						<jsp:param name="mandatory" value="true" />
						<jsp:param name="frequentlyUsed"
							value='<%=language.getString("frequently.used")%>' />
					</jsp:include>
				</td>
			</tr>

			<!--	glued.to.base-->
			<tr>


				<td>
					<div class="input-caption-container">
						<fieldset id="gluedToBaseGroup"
							style="display: inline; padding: 15px;">

							<label><%=language.getString("yes")%> <input
								style="zoom: 2;" name='gluedToBase' type='radio' value='on'
								<%=(model == null || !model.gluedToBase ? "" : "checked='checked'")%>
								onchange="updateMandatoryFieldMark(this.parentNode.parentNode.parentNode);updateGluedToBaseImg(this);"></label>
							<br> <label><%=language.getString("no")%> <input
								style="zoom: 2;" name='gluedToBase' type='radio' value='off'
								<%=(model == null || model.gluedToBase ? "" : "checked='checked'")%>
								onchange="updateMandatoryFieldMark(this.parentNode.parentNode.parentNode);updateGluedToBaseImg(this);"></label>
						</fieldset>
						<label for="gluedToBaseGroup" class="input-caption"><%=language.getString("glued.to.base")%></label>
						<font color='#FF0000' size='+3'>&#8226;</font> <img
							id='gluedToBaseImg'
							src='../icons/<%=(model != null && model.gluedToBase ? "glued.jpg" : "notglued.jpg")%>'
							style='float: float: middle; <%=model == null ? "visibility: hidden;" : ""%>'>
					</div>
				</td>
			</tr>

			<!--	category-->
			<tr>


				<td>
					<%
					final Category category = model == null ? null : servletDAO.getCategory(model.categoryID);

					String categoryLabel = model == null ? language.getString("select")
							: category.categoryCode + " - " + category.categoryDescription;

					String categoryLabelValue = model == null ? "" : String.valueOf(category.getId());
					%> <jsp:include page="categories.jsp">
						<jsp:param name="label"
							value='<%=language.getString("category")%>' />
						<jsp:param name="selectedLabel" value="<%=categoryLabel%>" />
						<jsp:param name="selectedValue" value="<%=categoryLabelValue%>" />
						<jsp:param name="mandatory" value="true" />
					</jsp:include>
				</td>
			</tr>

			<!--	comment-->
			<!-- <tr> -->
			<!-- <td> -->
			<%-- <%=language.getString("comment")%> --%>
			<!-- :  -->
			<!-- </td> -->
			<%-- <td><textarea name='modelcomment' cols='50' rows='10' maxlength="250" placeholder="Max. 250 char."><%=  (model != null) ? model.comment : "" %></textarea></td> --%>
			<!-- </tr> -->


			<!-- dimensions -->
			<tr>

				<td>
					<div class="input-caption-container">
						<fieldset id="spaceGroup" style="display: inline; padding: 15px;">
							<%
							String modelWidth = model == null ? "" : String.valueOf(model.getWidth());
							%>
							<jsp:include page="textInput.jsp">
								<jsp:param name="name" value="modelWidth" />
								<jsp:param name="value" value="<%=modelWidth%>" />
								<jsp:param name="label"
									value='<%=language.getString("models.width")%>' />
								<jsp:param name="mandatory" value="<%=!servlet.isOnSiteUse()%>" />
								<jsp:param name="maxlength" value="3" />
								<jsp:param name="size" value="15" />
							</jsp:include>

							<%
							String modelHeight = model == null ? "" : String.valueOf(model.getLength());
							%>
							<jsp:include page="textInput.jsp">
								<jsp:param name="name" value="modelHeight" />
								<jsp:param name="value" value="<%=modelHeight%>" />
								<jsp:param name="label"
									value='<%=language.getString("models.length")%>' />
								<jsp:param name="mandatory" value="<%=!servlet.isOnSiteUse()%>" />
								<jsp:param name="maxlength" value="3" />
								<jsp:param name="size" value="15" />
							</jsp:include>
						</fieldset>
						<label for="spaceGroup" class="input-caption"><%=language.getString("models.space")%></label>
					</div>
				</td>
			</tr>

			<!--	submit-->
			<tr>

				<td><input name='<%=action%>' type='submit'
					value='<%=language.getString(submitLabel)%>'> <%
 if (action == RegistrationServlet.Command.addModel.name()) {
 %> <input name='finishRegistration' type='submit'
					value='<%=language.getString("finish.model.registration")%>'>
					<%
					}
					%></td>
			</tr>

			<!--	models.markings-->
			<tr>

				<td>
					<%
					String markingsLabel = model == null ? language.getString("select") : model.markings;
					String markingsLabelValue = model == null ? "-" : model.markings;
					%> <jsp:include page="countries.jsp">
						<jsp:param name="defaultSelectedLabel" value="<%=markingsLabel%>" />
						<jsp:param name="label"
							value='<%=language.getString("models.markings")%>' />
						<jsp:param name="defaultSelectedValue"
							value="<%=markingsLabelValue%>" />
						<jsp:param name="selectName" value="markings" />
					</jsp:include>
				</td>
			</tr>

			<!--	models.identification-->
			<tr>

				<td>
					<%
					String modelidentification = model == null ? "" : model.identification;
					%> <jsp:include page="textInput.jsp">
						<jsp:param name="name" value="identification" />
						<jsp:param name="value" value="<%=modelidentification%>" />
						<jsp:param name="label"
							value='<%=language.getString("models.identification")%>' />
						<jsp:param name="mandatory" value="false" />
						<jsp:param name="size" value="60" />
					</jsp:include>
				</td>
			</tr>

			<!--	models.detailing-->
			<tr>


				<td><%=language.getString("models.detailing")%>: <br>
					<table cellpadding='5' style='border-collapse: collapse' border='1'>
						<tr>
							<td>&nbsp;</td>
							<%
							for (DetailingGroup group : DetailingGroup.values()) {
							%>
							<td><%=language.getString("detailing." + group.name())%></td>
							<%
							}
							%>
						</tr>
						<%
						for (DetailingCriteria criteria : DetailingCriteria.values()) {
							if (!criteria.isVisible())
								continue;
						%>
						<tr>
							<td><%=language.getString("detailing." + criteria.name())%>
							</td>
							<%
							for (DetailingGroup group : DetailingGroup.values()) {
							%>
							<td align="center"><label><input
									name='<%="detailing." + group.name() + "." + criteria.name()%>'
									style="zoom: 2;" type='checkbox' value='on'
									<%=(model == null || !model.isDetailed(group, criteria) ? "" : "checked='checked'")%>></label></td>
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

				<td><input name='<%=action%>' type='submit'
					value='<%=language.getString(submitLabel)%>'> <%
 if (action == RegistrationServlet.Command.addModel.name()) {
 %> <input name='finishRegistration' type='submit'
					value='<%=language.getString("finish.model.registration")%>'>
					<%
					}
					%></td>
			</tr>

		</table>

	</form>

	<%
	if (models != null && !models.isEmpty()) {
	%>
	<hr>
	<div id="bottom"></div>
	<div class="tooltip fixed-icon-container">
		<a href="#bottom" class='pulseBtn'
			> <img
			src="../icons/list.png" height="60"> <span class="tooltiptext">
				<%=language.getString("list.models")%></span></a>
	</div>
	<jsp:include page="listMyModels.jsp" />

	<%
	}
	%>
</body>
</html>


