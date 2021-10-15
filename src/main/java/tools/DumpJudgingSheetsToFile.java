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
		sheet1Criterias.add(new JudgingCriteria(1, "Szempont #1", 5));
		sheet1Criterias.add(new JudgingCriteria(2, "Szempont #2", 3));
		sheet1Criterias.add(new JudgingCriteria(3, "Szempont #3", 5));
		JudgingSheet sheet1 = new JudgingSheet("Zsűri lap #1", sheet1Criterias);
		data.add(sheet1);

		List<JudgingCriteria> sheet2Criterias = new LinkedList<>();
		sheet2Criterias.add(new JudgingCriteria(1, "Szempont #1", 5));
		sheet2Criterias.add(new JudgingCriteria(2, "Szempont #2", 4));
		sheet2Criterias.add(new JudgingCriteria(3, "Szempont #3", 3));
		sheet2Criterias.add(new JudgingCriteria(4, "Szempont #4", 4));
		sheet2Criterias.add(new JudgingCriteria(5, "Szempont #5", 4));
		sheet2Criterias.add(new JudgingCriteria(6, "Szempont #6", 5));
		JudgingSheet sheet2 = new JudgingSheet("Zsűri lap #2", sheet2Criterias);
		data.add(sheet2);
		
		List<JudgingCriteria> sheet3Criterias = new LinkedList<>();
		sheet3Criterias.add(new JudgingCriteria(1, "nehézségi fok kategórián belül", 5));
		sheet3Criterias.add(new JudgingCriteria(2, "összbenyomás, tálalás", 4));
		sheet3Criterias.add(new JudgingCriteria(3, "fő elemek beállitása", 5));
		sheet3Criterias.add(new JudgingCriteria(4, "ragasztás, tömítés, csiszolás kivitelezése", 5));
		sheet3Criterias.add(new JudgingCriteria(5, "futóművek, futóműaknák kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(6, "légcsavarok, rotorok kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(7, "megnyitott motor és hajtóműterek kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(8, "kabintető", 5));
		sheet3Criterias.add(new JudgingCriteria(9, "kabin kivitelezése és festése", 5));
		sheet3Criterias.add(new JudgingCriteria(10, "fegyverzetek, külső függesztmények kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(11, "nyitott fegyverterek kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(12, "megnyitott szerelőterek kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(13, "fényszórók, helyzetfények kivitelezése", 5));
		sheet3Criterias.add(new JudgingCriteria(14, "antennák és huzalozás kivitelezése", 5));
		sheet3Criterias.add(new JudgingCriteria(15, "festés, matricázás nehézsége", 5));
		sheet3Criterias.add(new JudgingCriteria(16, "festés, matricázás kivitelezése", 5));
		sheet3Criterias.add(new JudgingCriteria(17, "üzemeltetési nyomok, antikolás", 5));
		sheet3Criterias.add(new JudgingCriteria(18, "kor- és élethūség", 5));
		sheet3Criterias.add(new JudgingCriteria(19, "természetes környezet kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(20, "épitett környezet kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(21, "élőlények, figurák kivitelezése, festése", 5));
		sheet3Criterias.add(new JudgingCriteria(22, "járművek, kiszolgáló berendezések, szerszámok", 5));
		JudgingSheet sheet3 = new JudgingSheet("Bolyai repülő", sheet3Criterias);
		data.add(sheet3);

		OutputStream outputStream = new FileOutputStream("JudgingSheets.gzip");
		final GZIPOutputStream e = new GZIPOutputStream(outputStream);
		e.write(Serialization.serialize(data));
		e.close();

	}

}
