package datatype;

import java.util.function.BiPredicate;

class EnumGroup {

	public static <T extends Enum> T of(Class<T> c, String name, BiPredicate<T, String> doesMatch) {
		try {
			return (T) Enum.valueOf(c, name);
		} catch (IllegalArgumentException e) {
			for (T group : c.getEnumConstants()) {
				if (doesMatch.test(group, name)) {
					return group;
				}
			}
			throw new IllegalArgumentException("Wrong age: " + name);
		}
	}
}
