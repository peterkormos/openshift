package tools;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.LinkedList;
import java.util.List;
import java.util.zip.GZIPOutputStream;

import datatype.Record;
import datatype.judging.JudgingCriteria;
import datatype.judging.JudgingSheet;
import servlet.Serialization;

public class DumpJudgingSheetsToFile {

	public static void main(String[] args) throws Exception {
		List<Record> data = new LinkedList<>();
		
		List<JudgingCriteria> sheet1Criterias = new LinkedList<>();
		sheet1Criterias.add(new JudgingCriteria(1, "sheet1-d1", 5));
		sheet1Criterias.add(new JudgingCriteria(2, "sheet1-d2", 5));
		sheet1Criterias.add(new JudgingCriteria(3, "sheet1-d3", 5));
		JudgingSheet sheet1 = new JudgingSheet("sheet1", sheet1Criterias);
		data.add(sheet1);

		List<JudgingCriteria> sheet2Criterias = new LinkedList<>();
		sheet2Criterias.add(new JudgingCriteria(1, "sheet2-d1", 5));
		sheet2Criterias.add(new JudgingCriteria(2, "sheet2-d2", 5));
		sheet2Criterias.add(new JudgingCriteria(3, "sheet2-d3", 5));
		JudgingSheet sheet2 = new JudgingSheet("sheet2", sheet2Criterias);
		data.add(sheet2);
		
		OutputStream outputStream = new FileOutputStream("JudgingSheets.gzip");
		final GZIPOutputStream e = new GZIPOutputStream(outputStream);
		e.write(Serialization.serialize(data));
		e.close();

	}

}
