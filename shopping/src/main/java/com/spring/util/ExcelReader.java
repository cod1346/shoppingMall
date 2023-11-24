package com.spring.util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Iterator;

public class ExcelReader{
	public void createExcel() {

		try(FileInputStream fileInputStream = new FileInputStream("excel_file.xlsx")) {
			Workbook workbook = new XSSFWorkbook(fileInputStream);
			
			Sheet sheet = workbook.getSheet("주문추가하기");
			
			for(Row row : sheet) {
				Cell itemNameCell = row.getCell(0);
				Cell priceNameCell = row.getCell(1);
				Cell amountCell = row.getCell(2);
				Cell regDateCell = row.getCell(3);
				
				String itemName = itemNameCell.getStringCellValue();
				String price = itemNameCell.getStringCellValue();
				String amount = itemNameCell.getStringCellValue();
				String regDate = itemNameCell.getStringCellValue();
				
				System.out.println("품명"+itemName);
				System.out.println("가격"+price);
				System.out.println("갯수"+amount);
				System.out.println("판매일"+regDate);
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
	
	
}