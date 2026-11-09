package datatype;

import servlet.ServletUtil;

public enum AgeGroup {
	ADULT("Felnőtt", 19, 999), JUNIOR("Junior", 16, 18), YOUNGSTER("Serdülő", 13, 15), CHILD("Gyerek", 0, 12),
	UpToAdult("Felnőttig", 0, 18), ALL("Minden", 0, 999);

	private int from;
	private int to;
	private String title;

	public String toHTMLString() {
		return ServletUtil.encodeString(toString());
	}
	
	public String toString() {
		return title + " (" + from + "-" + to + ")";
	}
	
	AgeGroup(String title, int from, int to) {
		this.title = title;
		this.from = from;
		this.to = to;
	}

	public boolean isIn(int age) {
		return age <= from || (age >= from && age <= to);
	}

	public static AgeGroup of(String name) {
		return EnumGroup.of(AgeGroup.class, name, (group, name2) -> group.toString().equals(name2));
	}
	
	public String getTitle() {
		return title;
	}
}