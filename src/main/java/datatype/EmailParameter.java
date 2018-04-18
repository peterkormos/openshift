package datatype;

public class EmailParameter {
	private final String name, value;

	public String getName() {
		return name;
	}

	public String getValue() {
		return value;
	}

	public EmailParameter(String name, String value) {
		this.name = name;
		this.value = value;
	}
	
	public static EmailParameter create(String name, String value) {
		return new EmailParameter(name, value);
	}

	@Override
	public String toString() {
		return "EmailParameter [name=" + name + ", value=" + value + "]";
	}

}
