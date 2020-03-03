package tools;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;

import tools.ExcelUtil.Workbook;

public class t {

    public static void main(String[] args) throws IOException {
        Workbook u = ExcelUtil.generateExcelTableWithHeaders("spreadSheetName", //
                Arrays.asList("a", "b", "c"), //
                Arrays.asList(//
                Arrays.asList(1, 2, 3), //
                Arrays.asList(11, 21, 31), //
                Arrays.asList(12, 22, 32)//
        ));

        FileOutputStream stream = new FileOutputStream("ExcelReportUtils.xlsx");
        u.writeTo(stream);

    }

}
