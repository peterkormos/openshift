package tools;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.stream.IntStream;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelUtil {

    public static class Spreadsheet {
        private XSSFSheet xSSFSheet;

        public Spreadsheet(String spreadSheetName, Workbook workbook) {
            xSSFSheet = workbook.xSSFWorkbook.createSheet(spreadSheetName);
        }

        private Spreadsheet(XSSFSheet spreadsheet) {
            xSSFSheet = spreadsheet;
        }
    }

    public static class Workbook implements AutoCloseable {
        private XSSFWorkbook xSSFWorkbook;

        public Workbook() {
            xSSFWorkbook = new XSSFWorkbook();
        }

        @Override
        public void close() throws IOException {
            xSSFWorkbook.close();

        }

        public final void writeTo(OutputStream stream) throws IOException {
            xSSFWorkbook.write(stream);
        }

    }

    public static Spreadsheet createSpreadsheet(String spreadSheetName, List<String> columnHeaders, List<List<Object>> tableData,
            Workbook workbook, int startRow) {
        Spreadsheet spreadsheet = new Spreadsheet(createSpreadsheet(spreadSheetName, workbook.xSSFWorkbook));

        createTableInSpreadsheet(columnHeaders, tableData, workbook, spreadsheet, startRow);

        return spreadsheet;
    }

    public static void createTableInSpreadsheet(List<String> columnHeaders, List<List<Object>> tableData, Workbook workbook,
            Spreadsheet spreadsheet, int startRow) {
        int nextRow = createHeaderRow(columnHeaders, workbook.xSSFWorkbook, spreadsheet.xSSFSheet, startRow);

        createDataRows(columnHeaders.size(), tableData, workbook.xSSFWorkbook, spreadsheet.xSSFSheet, nextRow);

        IntStream.range(0, columnHeaders.size()).forEach(x -> spreadsheet.xSSFSheet.autoSizeColumn(x));
    }

    public static Workbook createWorkbook() {
        return new Workbook();
    }

    public static Workbook generateExcelTableWithHeaders(String spreadSheetName, List<String> columnHeaders, List<List<Object>> data) {
        Workbook workbook = createWorkbook();

        createSpreadsheet(spreadSheetName, columnHeaders, data, workbook, 0 /* startRow */);

        return workbook;
    }

    private static void createDataRows(int columnHeadersSize, List<List<Object>> tableData, XSSFWorkbook workbook, XSSFSheet spreadsheet,
            int nextRow) {
        CellStyle bigDecimalCellStyle = workbook.createCellStyle();
        DataFormat format = workbook.createDataFormat();
        bigDecimalCellStyle.setDataFormat(format.getFormat("#0.0000000000"));

        XSSFCellStyle dataRowStyle = ExcelUtil.createDataRowStyle(workbook);
        
        for(List<Object> resultRow :tableData) 
        {
            if (resultRow.size() != columnHeadersSize)
                throw new IllegalArgumentException(
                        String.format("resultRow.size: %d columnHeadersSize: %d", resultRow.size(), columnHeadersSize));

            XSSFRow dataRow = spreadsheet.createRow(nextRow++);
            IntStream.range(0, columnHeadersSize).forEach(columnIndex -> {
                XSSFCell cell = dataRow.createCell(columnIndex);
                cell.setCellStyle(dataRowStyle);
                Object cellValue = resultRow.get(columnIndex);
                if ((cellValue instanceof String) || (cellValue instanceof Character)) {
                    cell.setCellValue(String.valueOf(cellValue));
                } else if (cellValue instanceof Number) {
                    cell.setCellValue(((Number) cellValue).doubleValue());
                } else if (cellValue instanceof Date) {
                    cell.setCellValue((Date) cellValue);
                } else {
                    throw new IllegalArgumentException("Unexpected type: " + cellValue.getClass());
                }
            });
        };
    }

    private static XSSFCellStyle createDataRowStyle(XSSFWorkbook workbook) {
        // data row cell style
        XSSFFont dataRowFont = workbook.createFont();
        XSSFCellStyle dataRowStyle = workbook.createCellStyle();
        dataRowStyle.setFont(dataRowFont);
        return dataRowStyle;
    }

    private static int createHeaderRow(List<String> columnHeaders, XSSFWorkbook workbook, XSSFSheet spreadsheet, int row) {
        XSSFRow headerRow = spreadsheet.createRow(row);
        XSSFCellStyle headerStyle = ExcelUtil.createHeaderRowStyle(workbook);
        IntStream.range(0, columnHeaders.size()).forEach(index -> {

            // add cells to header row
            String columnHeader = columnHeaders.get(index);
            XSSFCell headerCell = headerRow.createCell(index);
            headerCell.setCellValue(columnHeader);
            headerCell.setCellStyle(headerStyle);
        });

        return ++row;
    }

    private static XSSFCellStyle createHeaderRowStyle(XSSFWorkbook workbook) {
        // header row cell style
        XSSFFont headerFont = workbook.createFont();
        headerFont.setColor(IndexedColors.BLACK.getIndex());
        headerFont.setBold(true);
        XSSFCellStyle headerRowStyle = workbook.createCellStyle();
        headerRowStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerRowStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerRowStyle.setAlignment(HorizontalAlignment.CENTER);
        headerRowStyle.setFont(headerFont);
        return headerRowStyle;
    }

    private static XSSFSheet createSpreadsheet(String spreadSheetName, XSSFWorkbook workbook) {
        return workbook.createSheet(spreadSheetName);
    }
}