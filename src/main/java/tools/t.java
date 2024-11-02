package tools;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Arrays;

import servlet.ServletDAO;
import servlet.ServletUtil;
import tools.ExcelUtil.Workbook;

public class t {

    public static void main(String[] args) throws IOException {
    	System.out.println(
    	URLEncoder.encode("ű")
    			);
    	System.out.println(
    	URLEncoder.encode("Kormos P&eacute;ter")
    			);
    	System.out.println(
    			ServletUtil.encodeString("ű")
    			);
    }

}
