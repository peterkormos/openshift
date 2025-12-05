package datatype;

import static org.junit.Assert.*;

import java.util.List;

import org.apache.commons.text.StringEscapeUtils;
import org.junit.Assert;
import org.junit.Test;

public class TestUser {

	@Test
	public void testGetHTMLModelClass() {
		User u = new User();
		u.setModelClass(ModelClass.Aircraft);
		u.setModelClass(ModelClass.AFV);
		u.setModelClass(ModelClass.Civilian);

		Assert.assertEquals("[Rep&uuml;l&#337;, Harcj&aacute;rm&#369;, Civil]", u.getHTMLModelClass());
		
		List<ModelClass> fromHTML = ModelClass.fromHTMLModelClasses(u.getHTMLModelClass());
		
		assertEquals(3, fromHTML.size());
		assertTrue(fromHTML.contains(ModelClass.Aircraft));
		assertTrue(fromHTML.contains(ModelClass.AFV));
		assertTrue(fromHTML.contains(ModelClass.Civilian));
	}

}
		
