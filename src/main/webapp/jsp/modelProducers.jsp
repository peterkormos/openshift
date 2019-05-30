<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
    User user = RegistrationServlet.getUser(request);
	
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
  final ResourceBundle language = (ResourceBundle)session.getAttribute(CommonSessionAttribute.Language.name());

	int maxlength = 100;
	if(request.getParameter("maxlength") != null) 
		maxlength = Integer.parseInt(request.getParameter("maxlength"));
%>
<div>
<input list="modelproducer" name="modelproducer" value='<%= request.getParameter("selectValue") %>'  maxlength="<%= maxlength %>" placeholder="<%= String.format(language.getString("input.text.maxlength"), maxlength)%>"
required="required"
onchange="updateMandatoryFieldMark(this);"
>

<datalist id="modelproducer">
    <option></option>
    <option>Academy</option>
    <option>ACE</option>
    <option>Andrea Miniature</option>
    <option>Airfix</option>
    <option>AFV Club</option>
    <option>AMT</option>
    <option>Aoshima</option>
    <option>AZ Model</option>
    <option>Bronco</option>
    <option>Cromwell</option>
    <option>Dragon</option>
    <option>Eduard</option>
    <option>Emhar</option>
    <option>Fine Molds</option>
    <option>Fujimi</option>
    <option>Great Wall Hobby</option>
    <option>Hasegawa</option>
    <option>Heller</option>
    <option>Hobby Boss</option>
    <option>Italeri</option>
    <option>ICM</option>
    <option>Kitty Hawk</option>
    <option>Meng Model</option>
    <option>Miniart</option>
    <option>Mirage</option>
    <option>Monogram</option>
    <option>Pegaso Models</option>
    <option>Roden</option>
    <option>Revell</option>
    <option>Scratch</option>
    <option>S-Model</option>
    <option>Special Hobby</option>
    <option>Tamiya</option>
    <option>Tristar</option>
    <option>Trumpeter</option>
    <option>UM</option>
    <option>Verlinden</option>
    <option>Vulcan</option>
    <option>Young Miniatures</option>
    <option>Zvezda</option>
</datalist>
<font color="#FF0000" size="+3">&#8226;</font> 
</div>