<%@page import="datatype.*"%>
<%@page import="servlet.*"%>
<%@page import="util.*"%>

<%@page import="java.util.*"%>

<%
	User user = RegistrationServlet.getUser(request);
	
	RegistrationServlet servlet = RegistrationServlet.getInstance(config);
  final ResourceBundle language = (ResourceBundle)session.getAttribute(SessionAttributes.Language.name());
%>


<input list="modelscale" name="modelscale" value='<%= request.getParameter("selectValue") %>' placeholder="<%=language.getString("model.scales.select")%>">

<datalist id="modelscale">
      <option></option>
      <option>1:1200</option>
      <option>1:720</option>
      <option>1:700</option>
      <option>1:570</option>
      <option>1:350</option>
      <option>1:225</option>
      <option>1:200</option>
      <option>1:144</option>
      <option>1:100</option>
      <option>1:87</option>
      <option>1:77</option>
      <option>1:76</option>
      <option>1:72</option>
      <option>1:50</option>
      <option>1:48</option>
      <option>1:35</option>
      <option>1:32</option>
      <option>1:25</option>
      <option>1:24</option>
      <option>1:16</option>
      <option>1:12</option>
      <option>1:10</option>
      <option>1:9</option>
      <option>1:8</option>
      <option>1:6</option>
      <option>28 mm</option>
      <option>54 mm</option>
      <option>70 mm</option>
      <option>75 mm</option>
      <option>90 mm</option>
</datalist>

<font color="#FF0000" size="+3">&#8226;</font> 
