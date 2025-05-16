package datatype;

public enum AgeGroup {
	ADULT("Felnőtt", 19, 999), JUNIOR("Junior", 16, 18), YOUNGSTER("Serdülő", 13, 15), CHILD("Gyerek", 0, 12),
	UpToAdult("Felnőttig", 0, 18), ALL("Minden", 0, 999);

	private int from;
	private int to;
	private String cimke;

	public String toString() {
		return cimke + " (" + from + "-" + to + ")";
	}

	AgeGroup(String cimke, int from, int to) {
		this.cimke = cimke;
		this.from = from;
		this.to = to;
	}

	private boolean isIn(int age) {
		return age >= from && age <= to;
	}

	public boolean contains(AgeGroup userAge) {
		return from <= userAge.from && to >= userAge.to;
	}

	public static AgeGroup get(int age) {
		for (AgeGroup group : AgeGroup.values()) {
			if (group.isIn(age)) {
				return group;
			}
		}

		throw new IllegalArgumentException("Wrong age: " + age);
	}
}