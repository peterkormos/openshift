package exception;

public class MissingServletConfigException extends Exception {

	private static final long serialVersionUID = -958059770669733876L;

	public MissingServletConfigException(String parameter) {
		super("parameter: " + parameter + " not found in servletConfig");
	}

}
