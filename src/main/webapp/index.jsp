<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<%
	String showId = request.getParameter("showId");
 %>
 
<body style="font-family: sans-serif;">
	<div class="header"></div>
	<table border="0" height="100%" width="100%">
		<tr>
			<td align="center" valign="middle">Welcome to the online model
				registration system....
				<p></p>
				<table border="0" cellspacing="5">
					<tbody>
						<tr>
							<td><img src="icons/hu.gif"></td>
<!-- 							<td>Magyar verzi&oacute;:</td> -->
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=HU">Bejelentkez&eacute;s</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=HU">Regisztr&aacute;ci&oacute;</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=HU">Elfelejtette jelszav&aacute;t</a></td>
						</tr>
						<tr>
							<td><img src="icons/gb.gif"></td>
<!-- 							<td>English version:</td> -->
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=EN">Login</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=EN">Registration
									for new users</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=EN">Forgot Password</a></td>
						</tr>
						<tr>
							<td><img src="icons/sk.gif"></td>
<!-- 							<td>Slovensk&aacute; verzia:</td> -->
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=SK">Prihl&aacute;senie
									sa</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=SK">Nov&aacute;
									registr&aacute;cia</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=SK">Zabudli ste
									heslo?</a></td>
						</tr>
						<tr>
							<td><img src="icons/cz.gif"></td>
<!-- 							<td>Cesk&aacute; verze:</td> -->
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=CZ">Prihl&aacute;&#353;en&iacute;</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=CZ">Nov&aacute;
									registrace</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=CZ">Zapomneli
									jste heslo?</a></td>
						</tr>
						<tr>
							<td><img src="icons/pl.png"></td>
<!-- 							<td>Polski wersja:</td> -->
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=PL">Zaloguj si&#281;</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=PL">Zarejestruj si&#281;</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=PL">Nie pami&#281;tam has&#322;a</a></td>
						</tr>
						<tr>
							<td>
							<img src="icons/it.png">
							<img src="icons/new.png"> 
							</td>
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=IT">Accedere</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=IT">Registrazione</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=IT">Password dimenticato</a></td>
						</tr>
						<tr>
							<td><img src="icons/de.gif"></td>
<!-- 							<td>Deutsch Version:</td> -->
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=DE">Anmelden</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=DE">Registration</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=DE">Passwort vergessen</a></td>
						</tr>
						<tr>
							<td><img src="icons/ru.png"></td>
<!-- 							<td>&#1056;&#1091;&#1089;&#1089;&#1082;&#1072;&#1103; &#1074;&#1077;&#1088;&#1089;&#1080;&#1103;:</td> -->
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=RU">&#1051;&#1086;&#1075;&#1080;&#1085;</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=RU">&#1056;&#1077;&#1075;&#1080;&#1089;&#1090;&#1088;&#1072;&#1094;&#1080;&#1103;
&#1085;&#1086;&#1074;&#1086;&#1075;&#1086; &#1087;&#1086;&#1083;&#1100;&#1079;&#1086;&#1074;&#1072;&#1090;&#1077;&#1083;&#1103;</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=RU">&#1047;&#1072;&#1073;&#1099;&#1083;&#1080; &#1087;&#1072;&#1088;&#1086;&#1083;&#1100;</a></td>
						</tr>
<!-- 
						<tr>
							<td><img src="icons/it.png"></td>
							<td>Deutsch Version:</td>
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=IT">Anmelden</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=IT">Registration</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=IT">Passwort vergessen</a></td>
						</tr>
						<tr>
							<td><img src="icons/pl.png"></td>
							<td>Deutsch Version:</td>
							<td><a href="jsp/login.jsp?<%=showId == null ? "" : "showId="+showId+"&" %>language=PL">Anmelden</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a
								href="jsp/user.jsp?directRegister=false&amp;action=register&amp;language=PL">Registration</a></td>
							<td>
								<div align="center">-</div>
							</td>
							<td><a href="jsp/reminder.jsp?language=PL">Passwort vergessen</a></td>
						</tr>
 -->
					</tbody>
				</table>
				<p>Can't find your language here? Please help us with your
					translation and offer your help to the show organizers... Thank
					you!</p> This site was developed and is maintained for free.
				<p>
				<form action="https://www.paypal.com/cgi-bin/webscr" method="post"
					target="_top">
					<input type="hidden" name="cmd" value="_s-xclick"> <input
						type="hidden" name="hosted_button_id" value="ZYUMYVHTYC75A">
					<input type="image"
						src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif"
						border="0" name="submit"
						alt="PayPal - The safer, easier way to pay online!"> <img
						alt="" border="0"
						src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif"
						width="1" height="1">
				</form>
			</td>
		</tr>
	</table>
</body>
</html>