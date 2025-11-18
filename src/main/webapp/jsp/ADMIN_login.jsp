<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="servlet.RegistrationServlet"%>

<form action="../RegistrationServlet" method="get">
<input name="command" value="login" type="hidden">
<input name="<%=RegistrationServlet.RequestParameter.Language.getParameterName()%>" value="<%=RegistrationServlet.DEFAULT_LANGUAGE %>>" type="hidden">
email: <input name="email">
<br>
password: <input name="password">
<br>
<input type="submit">
</form>