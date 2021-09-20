package tools;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
import java.util.List;
import java.util.stream.IntStream;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;

public class ExcelUtil {

    public static class Spreadsheet {
        private Sheet sheet;

        public Spreadsheet(String spreadSheetName, Workbook workbook) {
            sheet = workbook.workbook.createSheet(spreadSheetName);
        }

        private Spreadsheet(Sheet spreadsheet) {
            sheet = spreadsheet;
        }
    }

    public static class Workbook implements AutoCloseable {
        private HSSFWorkbook workbook;

        public Workbook() {
            workbook = new HSSFWorkbook();
        }

        @Override
        public void close() throws IOException {
            workbook.close();

        }

        public final void writeTo(OutputStream stream) throws IOException {
            workbook.write(stream);
        }

    }

    public static Spreadsheet createSpreadsheet(String spreadSheetName, List<String> columnHeaders, List<List<Object>> tableData,
            Workbook workbook, int startRow) {
        Spreadsheet spreadsheet = new Spreadsheet(createSpreadsheet(spreadSheetName, workbook.workbook));

        createTableInSpreadsheet(columnHeaders, tableData, workbook, spreadsheet, startRow);

        return spreadsheet;
    }

    public static void createTableInSpreadsheet(List<String> columnHeaders, List<List<Object>> tableData, Workbook workbook,
            Spreadsheet spreadsheet, int startRow) {
        int nextRow = createHeaderRow(columnHeaders, workbook.workbook, spreadsheet.sheet, startRow);

        createDataRows(columnHeaders.size(), tableData, workbook.workbook, spreadsheet.sheet, nextRow);

        IntStream.range(0, columnHeaders.size()).forEach(x -> spreadsheet.sheet.autoSizeColumn(x));
    }

    public static Workbook createWorkbook() {
        return new Workbook();
    }

    public static Workbook generateExcelTableWithHeaders(String spreadSheetName, List<String> columnHeaders, List<List<Object>> data) {
        Workbook workbook = createWorkbook();

        createSpreadsheet(spreadSheetName, columnHeaders, data, workbook, 0 /* startRow */);

        return workbook;
    }

    private static void createDataRows(int columnHeadersSize, List<List<Object>> tableData, HSSFWorkbook workbook, Sheet spreadsheet,
            int nextRow) {
        CellStyle bigDecimalCellStyle = workbook.createCellStyle();
        DataFormat format = workbook.createDataFormat();
        bigDecimalCellStyle.setDataFormat(format.getFormat("#0.0000000000"));

        HSSFCellStyle dataRowStyle = ExcelUtil.createDataRowStyle(workbook);
        
        for(List<Object> resultRow :tableData) 
        {
            if (resultRow.size() != columnHeadersSize)
                throw new IllegalArgumentException(
                        String.format("resultRow.size: %d columnHeadersSize: %d", resultRow.size(), columnHeadersSize));

            Row dataRow = spreadsheet.createRow(nextRow++);
            IntStream.range(0, columnHeadersSize).forEach(columnIndex -> {
                Cell cell = dataRow.createCell(columnIndex);
                cell.setCellStyle(dataRowStyle);
                Object cellValue = resultRow.get(columnIndex);
                if ((cellValue instanceof String) || (cellValue instanceof Character)) {
                    cell.setCellValue(String.valueOf(cellValue));
                } else if (cellValue instanceof Number) {
                    cell.setCellValue(((Number) cellValue).doubleValue());
                } else if (cellValue instanceof Date) {
                    cell.setCellValue((Date) cellValue);
                } else if (cellValue instanceof Boolean) {
                    cell.setCellValue((Boolean) cellValue);
                } else {
                    throw new IllegalArgumentException("Unexpected type: " + cellValue.getClass());
                }
            });
        };
    }

    private static HSSFCellStyle createDataRowStyle(HSSFWorkbook workbook) {
        // data row cell style
        HSSFFont dataRowFont = workbook.createFont();
        HSSFCellStyle dataRowStyle = workbook.createCellStyle();
        dataRowStyle.setFont(dataRowFont);
        return dataRowStyle;
    }

    private static int createHeaderRow(List<String> columnHeaders, HSSFWorkbook workbook, Sheet spreadsheet, int row) {
        Row headerRow = spreadsheet.createRow(row);
        HSSFCellStyle headerStyle = ExcelUtil.createHeaderRowStyle(workbook);
        IntStream.range(0, columnHeaders.size()).forEach(index -> {

            // add cells to header row
            String columnHeader = columnHeaders.get(index);
            Cell headerCell = headerRow.createCell(index);
            headerCell.setCellValue(columnHeader);
            headerCell.setCellStyle(headerStyle);
        });

        return ++row;
    }

    private static HSSFCellStyle createHeaderRowStyle(HSSFWorkbook workbook) {
        // header row cell style
        HSSFFont headerFont = workbook.createFont();
        headerFont.setColor(IndexedColors.BLACK.getIndex());
        headerFont.setBold(true);
        HSSFCellStyle headerRowStyle = workbook.createCellStyle();
        headerRowStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerRowStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerRowStyle.setAlignment(HorizontalAlignment.CENTER);
        headerRowStyle.setFont(headerFont);
        return headerRowStyle;
    }

    private static HSSFSheet createSpreadsheet(String spreadSheetName, HSSFWorkbook workbook) {
        return workbook.createSheet(spreadSheetName);
    }
}