
public class testbed {

	public static void main(String[] args) {
		String pathInfo = "SetModelInSession&modelID=1";
        if(pathInfo.indexOf("&") > -1)
        pathInfo = pathInfo.substring(0, pathInfo.indexOf("&"));

        System.out.println(pathInfo);
	}

}
