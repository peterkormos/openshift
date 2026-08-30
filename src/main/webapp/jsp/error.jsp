<%@page import="exception.UserNotLoggedInException"%>
<%@page import="java.io.StringWriter"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<html>
<head>
<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="base.css" media="screen" />
</head>

<body>
	<div class='flash error'>
	<b><%= new Date() %>:</b>
	<br>Dear Diary,
	<br>Something fishy happened today! 
	<p>By the way: please send this message to the show organizers...</div>

<%
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
	
	Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
	
	// Retrieve other details
	Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
	String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
	
	final StringBuilder messageBody = new StringBuilder();

	messageBody.append("<h2>Error Details</h2>");
	
	messageBody.append("<p><b>Date:</b> " + new Date() + "</p>");
	messageBody.append("<p><b>Status Code:</b> " + statusCode + "</p>");
	messageBody.append("<br><b>Failed URI:</b> " + requestUri + "</br>");
	
	final Enumeration<String> e = request.getParameterNames();
	while (e.hasMoreElements()) {
		final String param = e.nextElement();
		messageBody.append("<br><b>HTTP parameter:</b> " + param + " <b>value:</b> " + request.getParameter(param) + "</br>");
	}

	
	if (throwable != null) {
	    messageBody.append("<p><b>Exception Type:</b> " + throwable.getClass().getName() + "</p>");
	    messageBody.append("<br><b>Exception Message:</b> " + throwable.getMessage() + "</br>");
	    
	    // Getting the deepest root cause
	    Throwable rootCause = throwable;
	    while (rootCause.getCause() != null) {
	        rootCause = rootCause.getCause();
	    }
	    if(UserNotLoggedInException.class.isInstance(rootCause)) {
	    	return;
	    }
	    messageBody.append("<p><b>Root Cause:</b> " + rootCause.getClass().getName() + ": " + rootCause.getMessage() + "</p>");

	    for(StackTraceElement st : rootCause.getStackTrace()) {
		    messageBody.append(st);
		    messageBody.append("<br>");
	    }
	}
	
	servlet.sendEmail(servlet.getServerConfigParamter("email.from"), "Error", messageBody);
%>
</body>
</html>
