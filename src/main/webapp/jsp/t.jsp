<%@page import="util.*"%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="base.css" media="screen">

<script type="text/javascript">
// <!--
function setModelInSession(value)
{
	var url = "http://localhost/makett/RegistrationServlet?command=setModelInSession&modelID=" + value;
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
		if (req.readyState == 4)
		{
//			parseXML(req.responseText);
			document.getElementById('resp').innerHTML = '<%= session.getAttribute(CommonSessionAttribute.Model.name()) %>';
		}
	}

	req.send(null);
}

//-->
</script>

</head>

<body>
<p id="resp" />

	<input type="text" onChange="setModelInSession(this.value);">
</body>

</html>