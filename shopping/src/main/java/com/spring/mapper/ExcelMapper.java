package com.spring.mapper;

import com.spring.domain.ExcelDTO;

public interface ExcelMapper {
	public int insertExcel(ExcelDTO dto);
	public int getNextOrderNo();
}
