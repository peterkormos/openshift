<select name="yearofbirth" id="yearofbirth">
  <option value="<%= request.getParameter("selectValue") %>" selected><%= request.getParameter("selectLabel") %></option>
  <%
  int currentYear = java.time.LocalDate.now().getYear();
  for (int i = currentYear-4; i > currentYear-100 ; i--)
  {
%>
  <option value='<%=i%>'><%=i%></option>
<%
  }
  %>
</select>
