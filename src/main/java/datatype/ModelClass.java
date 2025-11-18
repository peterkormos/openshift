package datatype;

import java.io.Serializable;

public enum ModelClass implements Serializable
{
  Aircraft("Repülő"), AFV("Harcjármű"), Figure("Figura"), Civilian("Civil"), SciFi("Sci-fi"), Ship("Hajó"), Other("Egyéb");

	private String title;

	public String toString() {
		return title;
	}
	
	ModelClass(String title) {
		this.title = title;
	}
	
	public String getTitle() {
		return title;
	}
	
	public static ModelClass of(String name) {
		return EnumGroup.of(ModelClass.class, name, (group, name2) -> group.getTitle().equals(name2));
	}
}
