package datatype;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.text.StringEscapeUtils;

import servlet.ServletUtil;

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

	public static String getHTMLModelClasses(List<ModelClass> modelClasses) {
		return modelClasses.stream().map(mc -> ServletUtil.encodeString(mc.toString())).collect(Collectors.toList()).toString();
	}

	public static List<ModelClass> fromHTMLModelClasses(String modelClassesInHTML) {
		List<ModelClass> modelClasses = new LinkedList<ModelClass>();
		
		modelClassesInHTML = modelClassesInHTML.replaceAll("\\[", "").replaceAll("\\]", "");

		for (String mc : modelClassesInHTML.split(",")) {
			modelClasses.add(ModelClass.of(StringEscapeUtils.unescapeHtml4(mc.trim())));
		}
		
		return modelClasses;
	}
}
