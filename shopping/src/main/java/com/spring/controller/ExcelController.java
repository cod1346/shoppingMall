package com.spring.controller;


import java.io.IOException;
import java.util.Iterator;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.spring.domain.ExcelDTO;
import com.spring.service.ExcelService;

import lombok.extern.slf4j.Slf4j;


@Controller @Slf4j @RequestMapping("/excel")
public class ExcelController {
	

	@Autowired
	private ExcelService service;
	
	@PostMapping("/uploadExcel")
	public String downloadExcel(@RequestParam("uploadExcel") MultipartFile uploadExcel) throws IOException{
		log.info("엑셀업로드 요청");
		System.out.println("------------------------");
		System.out.println(uploadExcel);
		XSSFWorkbook workbook = new XSSFWorkbook(uploadExcel.getInputStream());
		XSSFSheet worksheet = workbook.getSheetAt(0);
		
		Sheet sheet = workbook.getSheetAt(0);
		Iterator<Row> rows = sheet.iterator();
		
		
		 for(int i=1;i<worksheet.getPhysicalNumberOfRows() ;i++) {
		        ExcelDTO dto = new ExcelDTO();
		        
		        DataFormatter formatter = new DataFormatter();		        
		        XSSFRow row = worksheet.getRow(i);
		        	    	
		        String itemName = formatter.formatCellValue(row.getCell(0));
		        String price = formatter.formatCellValue(row.getCell(1));
		        String amount = formatter.formatCellValue(row.getCell(2));
		        String orderDate = formatter.formatCellValue(row.getCell(3));
		        String username = formatter.formatCellValue(row.getCell(4));
		        
		        dto.setItemName(itemName);
		        dto.setPrice(Integer.parseInt(price));
		        dto.setAmount(Integer.parseInt(amount));
		        dto.setOrderDate(orderDate);
		        dto.setUsername(username);
		        
		        service.insertExcel(dto);
		 } 

		 return "redirect://";
			
	}
	
	@GetMapping("/downloadExcel")
    public void excelDownload(HttpServletResponse response) throws IOException {
//        Workbook wb = new HSSFWorkbook();
        Workbook wb = new XSSFWorkbook();
        Sheet sheet = wb.createSheet("주문양식 작성시트");
        Row row = null;
        Cell cell = null;
        int rowNum = 0;

        // Header
        row = sheet.createRow(rowNum++);
        cell = row.createCell(0);
        cell.setCellValue("품명");
        cell = row.createCell(1);
        cell.setCellValue("가격");
        cell = row.createCell(2);
        cell.setCellValue("갯수");
        cell = row.createCell(3);
        cell.setCellValue("주문일자");
        cell = row.createCell(4);
        cell.setCellValue("주문자");
        

        row = sheet.createRow(rowNum++);
        cell = row.createCell(0);
        cell.setCellValue("품명입력");
        cell = row.createCell(1);
        cell.setCellValue("가격입력");
        cell = row.createCell(2);
        cell.setCellValue("수량입력");
        cell = row.createCell(3);
        cell.setCellValue("yy-mm-dd");
        cell = row.createCell(4);
        cell.setCellValue("유저아이디");
        // 컨텐츠 타입과 파일명 지정
        response.setContentType("ms-vnd/excel");
        //response.setHeader("Content-Disposition", "attachment;filename=example.xls");
        response.setHeader("Content-Disposition", "attachment;filename=order_form.xlsx");

        // Excel File Output
        wb.write(response.getOutputStream());
        wb.close();
    }
	
}
