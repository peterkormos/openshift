package datatype;

public enum AgeGroup {
	ADULT("Felnőtt", 19, 999), JUNIOR("Junior", 16, 18), YOUNGSTER("Serdülő", 13, 15), CHILD("Gyerek", 0, 12),
	UpToAdult("Felnőttig", 0, 18), ALL("Minden", 0, 999);

	private int from;
	private int to;
	private String title;

	public String toString() {
		return title + " (" + from + "-" + to + ")";
	}
	
	AgeGroup(String title, int from, int to) {
		this.title = title;
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
	
	public static AgeGroup of(String name) {
		return EnumGroup.of(AgeGroup.class, name, (group, name2) -> group.toString().equals(name2));
	}
	
	public String getTitle() {
		return title;
	}
}