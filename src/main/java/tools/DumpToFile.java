package tools;

import java.io.FileWriter;
import java.util.ResourceBundle;

import servlet.RegistrationServlet;
import util.LanguageUtil;
import datatype.User;

public class DumpToFile
{

  public DumpToFile(String baseDir, String DB_Driver, String DB_URL, String DB_Username, String DB_Password) throws Exception
  {
	RegistrationServlet servlet = new RegistrationServlet();
	//    servlet.init(baseDir, DB_Driver, DB_URL, DB_Username, DB_Password, null,
	//        false, null);

	ResourceBundle language = new LanguageUtil().getLanguage("HU");

	System.out.println("Writing users...");
	FileWriter fw = new FileWriter("users.html");
	User loggedInUser = new User();
	loggedInUser.setLanguage("ADMIN");
	fw.write(servlet.getUserTable(loggedInUser).toString());
	fw.close();
	System.out.println("Writing users done.....");

	System.out.println("Writing forms...");
	fw = new FileWriter("forms.html");
	for (User user : servlet.servletDAO.getUsers())
	{
//	  fw.write(servlet.printModels(language, user.userID, null).toString());
	}
	fw.close();
	System.out.println("Writing forms done.....");

	System.out.println("DONE.....");
  }

  public static void main(String[] args) throws Exception
  {
	new DumpToFile(args[0], args[1], args[2], args[3], args[4]);
  }

}
