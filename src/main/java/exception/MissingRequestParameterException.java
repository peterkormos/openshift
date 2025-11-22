package exception;

public class MissingRequestParameterException extends IllegalArgumentException {

	public MissingRequestParameterException(String parameter) {
		super(parameter + " is not set!");
	}

	private static final long serialVersionUID = 8957340183585055002L;

}
