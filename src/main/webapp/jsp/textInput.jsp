<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
if (Boolean.parseBoolean(request.getParameter("loginRequired"))) {
	User user = RegistrationServlet.getUser(request);
}

RegistrationServlet servlet = RegistrationServlet.getInstance(config);
final ResourceBundle language = (ResourceBundle) session.getAttribute(CommonSessionAttribute.Language.name());

int maxlength = 60;
if (request.getParameter("maxlength") != null)
	maxlength = Integer.parseInt(request.getParameter("maxlength"));

String inputType;
if (request.getParameter("inputType") != null)
	inputType = request.getParameter("inputType");
else
	inputType = "text";

String id;
if (request.getParameter("id") != null)
	id = request.getParameter("id");
else
	id = request.getParameter("name");

boolean mandatory = Boolean.parseBoolean(request.getParameter("mandatory"));
%>

<div class="input-caption-container">
<input type='text'
	size="<%=ServletUtil.getOptionalRequestAttribute(request, "size")%>"
	maxlength='<%=maxlength%>'
	name='<%=request.getParameter("name")%>'
	type='<%=request.getParameter("inputType")%>'
	id='<%=id%>'
	placeholder="<%=String.format(language.getString("input.text.maxlength"), maxlength)%>"
	<%String value = request.getParameter("value");

if (value != null) {%>
	value='<%=value%>' <%}%>
	<%=mandatory ? "required='required'" : ""%>
	onchange="updateMandatoryFieldMark(this);">
	<label for="<%=request.getParameter("name")%>" class="input-caption"><%=request.getParameter("label")%></label>
<%
if (mandatory) {
%>
<font color='#FF0000' size='+3'>&#8226;</font>
<%
}
%>
</div>

