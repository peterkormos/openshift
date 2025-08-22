package tools;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import datatype.Detailing;
import datatype.Model;
import datatype.User;
//import net.sf.jasperreports.engine.JRException;
//import net.sf.jasperreports.engine.JasperCompileManager;
//import net.sf.jasperreports.engine.JasperExportManager;
//import net.sf.jasperreports.engine.JasperFillManager;
//import net.sf.jasperreports.engine.JasperPrint;
//import net.sf.jasperreports.engine.JasperReport;
//import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

public class ModelReporter {
//
//    public static void main(String[] args) throws JRException {
//
//        JasperReport jasperReport = JasperCompileManager.compileReport(ModelReporter.class.getResourceAsStream("/oldal.jrxml"));
////        JasperReport jasperReport = JasperCompileManager.compileReport(ModelReporter.class.getResourceAsStream("/nevlap.jrxml"));
////        JasperReport jasperReport = JasperCompileManager.compileReport(ModelReporter.class.getResourceAsStream("/nevlap2.jrxml"));
//        Map<String, Object> parameters = new HashMap<>();
//        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters,
//                new JRBeanCollectionDataSource(Arrays.asList( createBeanCollection())));
//        JasperExportManager.exportReportToPdfFile(jasperPrint, "nevlap.pdf");
//
//        System.out.println("kesz....");
//    }
//
//    public static java.util.Collection<Model> createBeanCollection() {
//        Collection<Model> collection = new LinkedList<>();
//
//        Map<DetailingGroup, Detailing> d1 = new HashMap<>();
//
//        for (DetailingGroup group : DetailingGroup.values())
//        {
//          final Map<DetailingCriteria, Boolean> criterias = new HashMap<>();
//
//          criterias.put(DetailingCriteria.externalSurface, false);
//          criterias.put(DetailingCriteria.cockpit,false);
//          criterias.put(DetailingCriteria.engine,false);
//          criterias.put(DetailingCriteria.undercarriage,false);
//          criterias.put(DetailingCriteria.gearBay,false);
//          criterias.put(DetailingCriteria.armament,false);
//          criterias.put(DetailingCriteria.conversion,false);
//          
//          d1.put(group, new Detailing(group, criterias));
//        }
//        
//        Map<DetailingCriteria, Boolean> dc1 = d1.get(DetailingGroup.photoEtched).getCriterias();
//        dc1.put(DetailingCriteria.armament, true);
//
//        Map<DetailingCriteria, Boolean> dc2  = d1.get(DetailingGroup.scratch).getCriterias();
//        dc2.put(DetailingCriteria.cockpit, true);
//
//        Map<DetailingCriteria, Boolean> dc3 = d1.get(DetailingGroup.resin).getCriterias();
//        dc3.put(DetailingCriteria.undercarriage, true);
//
////        Map<DetailingCriteria, Boolean> dc4 = new HashMap<>();
////        dc4.put(DetailingCriteria.undercarriage, true);
////        d1.put(DetailingGroup.resin, new Detailing(DetailingGroup.resin, dc4));
//
//        Map<DetailingCriteria, Boolean> dc5 = d1.get(DetailingGroup.documentation).getCriterias();
//        dc5.put(DetailingCriteria.engine, true);
//        
//        System.out.println(d1);
//        
//        Model m1 = new Model(1, 2, 3, "scale4", "name5", "6", "7", "8", "9", true, d1);
//        User user1 = new User();
//        user1.setLastName("last name");
//        user1.setCity("city");
//        user1.setCountry("country");
//        user1.setYearOfBirth(1977);
//        m1.setUser(user1);
//        collection.add(m1);
//        Map<DetailingGroup, Detailing> d2 = new HashMap<>();
//        Map<DetailingCriteria, Boolean> dc22 = new HashMap<>();
//        dc22.put(DetailingCriteria.armament, true);
//        d2.put(DetailingGroup.photoEtched, new Detailing(DetailingGroup.photoEtched, dc22));
//        Model m2 = new Model(11, 12, 13, "scale1", "name1", "16", "17", "18", "19", true, d2);
//
//        User user2 = new User();
//        user2.setYearOfBirth(1976);
//        m2.setUser(user2);
//        collection.add(m2);
//        Map<DetailingGroup, Detailing> d3 = new HashMap<>();
//        Map<DetailingCriteria, Boolean> dc33 = new HashMap<>();
//        dc33.put(DetailingCriteria.armament, true);
//        d3.put(DetailingGroup.photoEtched, new Detailing(DetailingGroup.photoEtched, dc33));
//        Model m3 = new Model(21, 22, 23, "scale2", "name2", "26", "27", "28", "29", true, d3);
//        User user3 = new User();
//        user3.setYearOfBirth(1975);
//        m3.setUser(user3);
//        collection.add(m3);
//        return collection;
//    }

}
