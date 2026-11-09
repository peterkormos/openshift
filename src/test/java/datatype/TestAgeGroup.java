package datatype;

import org.junit.Assert;
import org.junit.Test;

public class TestAgeGroup {
	@Test
	public void testisIn() {
		Assert.assertFalse(AgeGroup.JUNIOR.isIn(20));

		Assert.assertTrue(AgeGroup.ADULT.isIn(17));
		Assert.assertTrue(AgeGroup.ADULT.isIn(20));

		Assert.assertTrue(AgeGroup.ALL.isIn(20));
		Assert.assertTrue(AgeGroup.ALL.isIn(6));
		Assert.assertTrue(AgeGroup.ALL.isIn(14));
		Assert.assertTrue(AgeGroup.ALL.isIn(17));

	}
}
