package exception;

public class UserNotLoggedInException extends Exception {

	private static final long serialVersionUID = 9015168831062648237L;

	public UserNotLoggedInException(String message) {
		super(message);
	}

}
