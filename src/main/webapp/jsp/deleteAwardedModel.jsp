<%@page import="java.util.List"%>

<%@page import="datatype.*"%>
<%@page import="servlet.*"%>

    
        <form name='input' action='../RegistrationServlet' method='put'>
    <input type='hidden' name='command' value='deleteAwardedModel'>
<%
    for (AwardedModel model : RegistrationServlet.servletDAO.getAwardedModels())
    {
      %>
      <input type='radio' name='modelID' value='<%= model.getId()%>'/>
      <%= model.getId()%>  -  
      <%= model.scale%>  - 
      <%= model.name%>  -
      <%= RegistrationServlet.servletDAO.getUser(
          model.userID).getFullName()%>  -
      <br>
<%
}
%>
    <p><input type='submit' value='T&ouml;r&ouml;l'>
    </form>
</body>
</html>