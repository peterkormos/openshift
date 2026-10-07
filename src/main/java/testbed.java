import java.io.IOException;
import java.security.GeneralSecurityException;

import javax.mail.MessagingException;

import util.EmailUtil;

public class testbed {

	public static void main(String[] args) throws MessagingException, IOException, GeneralSecurityException {
        new EmailUtil(args[0], false, args[1], "").sendEmail(args[2], "subject", "message");
	}

}
