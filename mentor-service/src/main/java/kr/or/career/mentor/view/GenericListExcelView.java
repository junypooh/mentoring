package kr.or.career.mentor.view;

import kr.or.career.mentor.annotation.ExcelFieldName;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Field;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;


public class GenericListExcelView extends AbstractExcelView {

    @Override
    @SuppressWarnings("unchecked")
    protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        String fileName = (String) model.get("fileName");

        fileName = new String(fileName.getBytes("euc-kr"), "8859_1");
        response.setHeader("Content-Disposition", "attachment; fileName=\"" + fileName + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary");

        List<Object> domains = (List<Object>) model.get("domains");

        HSSFSheet sheet = workbook.createSheet("Report");

        if (domains.size() > 0) {
            HSSFRow header = sheet.createRow(0);

            int rowNum = 1;
            if (domains.get(0) instanceof Map) {
                header.createCell(0).setCellValue("DATA");
                for (Object obj : domains) {
                    //create the row data
                    HSSFRow row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(obj.toString());
                }
            }
            else {
                ArrayList<Field> list = (ArrayList<Field>) model.get("listHeaderField");

                for (Object obj : domains) {
                    //create the row data
                    HSSFRow row = sheet.createRow(rowNum++);

                    //Excel로 만들 목록을 별도로 지정하지 않았으면
                    if(list == null){
                        Field[] fields = obj.getClass().getDeclaredFields();
                        list = new ArrayList<>(Arrays.asList(fields));
                        for(int idx = list.size()-1; idx >= 0 ; idx--){
                            if (!list.get(idx).isAnnotationPresent(ExcelFieldName.class)) {
                                list.remove(idx);
                            }
                        }

                        //fields 재정렬
                        Collections.sort(list, new FieldSort());
                    }

                    int cellNum = 0;
                    for (Field field : list) {
                        //각 column의 이름 설정
                        ExcelFieldName fn = field.getAnnotation(ExcelFieldName.class);
                        if (header.getCell(cellNum) == null) {
                            if(fn == null){
                                header.createCell(cellNum).setCellValue(field.getName());
                            }else{
                                if(!field.getType().equals(List.class)){
                                    header.createCell(cellNum).setCellValue(fn.name());
                                }
                            }
                        }

                        field.setAccessible(true);
                        if(field.get(obj) != null) {
                            if (field.getType().equals(Integer.class)) {
                                row.createCell(cellNum).setCellValue(String.valueOf((Integer) field.get(obj)));
                            }
                            else if (field.getType().equals(String.class)) {
                                row.createCell(cellNum).setCellValue((String) field.get(obj));
                            }
                            else if (field.getType().equals(Date.class)) {
                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd");
                                row.createCell(cellNum).setCellValue(dateFormat.format((Date) field.get(obj)));
                            }
                            else if (field.getType().equals(Long.TYPE)) {
                                row.createCell(cellNum).setCellValue((Long) field.get(obj));
                            }
                            else if (field.getType().equals(Double.class)) {
                                DecimalFormat decimalFormat = new DecimalFormat("#####.##");
                                String result = decimalFormat.format(((Double) field.get(obj)).doubleValue());
                                row.createCell(cellNum).setCellValue(result);
                            }
                            else if (field.getType().equals(List.class)) {
                                if(field.get(obj) !=null){
                                    List excelSchNm = (List) field.get(obj);
                                    for(int i=0;i<excelSchNm.size();i++){
                                        //헤더명 뒤에 카운트 추가
                                        header.createCell(cellNum+i).setCellValue(fn.name()+(i+1));
                                        row.createCell(cellNum+i).setCellValue((String) excelSchNm.get(i));
                                    }
                                    // List 형식 뒤에 또 List가 있을 수 있으므로 데이터 갯수 만큼 추가한다.
                                    cellNum += (excelSchNm.size()-1);
                                }
                            }
                        }
                        cellNum++;
                    }
                }
            }
        }
    }

    private class FieldSort implements Comparator<Field>{

        @Override
        public int compare(Field o1, Field o2) {
            ExcelFieldName fn1 = o1.getAnnotation(ExcelFieldName.class);
            ExcelFieldName fn2 = o2.getAnnotation(ExcelFieldName.class);
            return fn1.order()-fn2.order();
        }

    }

    public static Field getField(Class<?> clas , String name) throws NoSuchFieldException{
        try{
            return clas.getDeclaredField(name);
        }catch(NoSuchFieldException e){
            Class<?> supClass = clas.getSuperclass();
            if(supClass != null){
                return getField(supClass, name);
            }else{
                throw e;
            }
        }
    }
}