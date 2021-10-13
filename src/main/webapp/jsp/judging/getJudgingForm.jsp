<%@page import="servlet.*" %>
<%@page import="datatype.judging.*"%>
<%@page import="datatype.Model"%>
<%@page import="java.util.*"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8;">
<link href="../base.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
// <!--
function setModelInSession(value)
{
	var url = "../../RegistrationServlet?command=setModelInSession&modelID=" + value;
	var req = false;

	if (window.XMLHttpRequest) 
	{ // Mozilla, Safari,...
   		req = new XMLHttpRequest();

	if (req.overrideMimeType)
    	req.overrideMimeType('text/xml');
  	} 
	else if (window.ActiveXObject) 
	{ // IE
   		try 
		{
		    req = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) 
		{
      		try 
			{
       			req = new ActiveXObject("Microsoft.XMLHTTP");
      		} catch (e) 
			{}
     	}
   }
   
	req.open("GET", url, true);
	req.onreadystatechange= function()
	{   
	 
		if (req.readyState == 4 && 'ok' == req.responseText)
		{
			location.reload(true);
		}
	}

	req.send(null);
}

//-->
</script>

</head>

<p>
<p id="resp" />

<%
	ResourceBundle language = JudgingServlet.getLanguage(session, response);

    List<JudgingCriteria> criteriaList = (List<JudgingCriteria>) session
            .getAttribute(JudgingServlet.SessionAttribute.JudgingCriteriasForCategory.name());

    boolean simpleJudging = Boolean.valueOf(ServletUtil.getOptionalRequestAttribute(request, JudgingServlet.RequestParameter.SimpleJudging.name()));
    
    if (criteriaList == null || simpleJudging) {
        criteriaList = Arrays.asList(JudgingCriteria.getDefault());
        JudgingServlet.setSessionAttribute(request, JudgingServlet.SessionAttribute.JudgingCriteriasForCategory, criteriaList);
    }
%>

<form accept-charset='UTF-8'
	action="../../JudgingServlet/<%=JudgingServlet.RequestType.SaveJudging.name()%>"
	method="post">

	<input type="hidden"
		name="<%=JudgingServlet.RequestParameter.JudgingCriterias.name()%>"
		value="<%=criteriaList.size()%>">


	<jsp:include page="getJudgingSheet.jsp" />
	<p>
	<input type="submit" value='<%= language.getString("save") %>'>
	<input name='finishRegistration' type='submit'
		value='<%= language.getString("judging.finish") %>'> <a
		href="../../JudgingServlet"><%= language.getString("proceed.to.main") %></a>
</form>