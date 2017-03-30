package kr.or.career.mentor.domain;

import lombok.Data;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
public class ExcelInfoDTO {

  private List<Object> listObject;

  private ArrayList<Field> fieldList;

  private String sheetNm;

}
