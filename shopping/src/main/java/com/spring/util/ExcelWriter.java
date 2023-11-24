package com.spring.util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ExcelWriter{
	public void createExcel() {

		Workbook workbook = new XSSFWorkbook();
		
		Sheet sheet = workbook.createSheet("주문추가하기");
		Row headerRo = sheet.createRow(0);
		
		headerRo.createCell(0).setCellValue("품명");
		headerRo.createCell(1).setCellValue("가격");
		headerRo.createCell(2).setCellValue("갯수");
		headerRo.createCell(3).setCellValue("주문일자");
		
		try(FileOutputStream outputStream = new FileOutputStream("excel_file.xlsx")) {
			workbook.write(outputStream);
			System.out.println("엑셀파일 생성완료");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
	
	
}