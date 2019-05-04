<select name="language" >
  <option value="<%= request.getParameter("selectValue") %>" selected><%= request.getParameter("selectLabel") %></option>
  <option value="" >-------</option>
  <option value="HU">Magyar</option>
  <option value="EN">English</option>
  <option value="SK">Slovensk&aacute;</option>
  <option value="CZ">Cesk&aacute;</option>
  <option value="DE">Deutsch</option>
  <option value="RU">&#1056;&#1091;&#1089;&#1089;&#1082;&#1080;&#1081;</option>
<!-- 
  <option value="PL">Deutsch</option>
  <option value="IT">Deutsch</option>
 -->
   <option value="" >-------</option>
</select>
