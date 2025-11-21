<%@page import="java.util.*"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<html>

<head>
<link rel="stylesheet" href="base.css" media="screen" />
<script type="text/javascript" src="findUser.js"></script>
<script src="jquery.min.js"></script>
</head>
<body
	<%=request.getRequestURL().indexOf("localhost") > -1 ? "" : "style='background-color: #cff6c9;'"%>>

	<jsp:include page="CATEGORY_main.jsp" />
	<p>
		<jsp:include page="ADMIN_egyeb.jsp" />
	</p>
</body>
</html>
