<%@page import="servlet.RegistrationServlet.RequestParameter"%>
<%@page import="servlet.RegistrationServlet"%>

<form action="../RegistrationServlet" method="get">
<input name="command" value="login" type="hidden">
<input name="<%=RegistrationServlet.RequestParameter.Language.getParameterName()%>" value="<%=RegistrationServlet.DEFAULT_LANGUAGE %>>" type="hidden">
email: <input name="email">
<br>
password: <input name="password">
<br>
<input name="show" value="1" type="hidden">
<input type="submit">
</form>