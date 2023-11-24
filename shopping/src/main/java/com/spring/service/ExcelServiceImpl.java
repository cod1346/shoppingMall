package com.spring.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.ExcelDTO;
import com.spring.domain.TotalPriceDTO;
import com.spring.mapper.ExcelMapper;
import com.spring.mapper.ItemMapper;

@Service
public class ExcelServiceImpl implements ExcelService {

	@Autowired
	private ExcelMapper mapper;
	@Autowired
	private ItemMapper itemMapper;

	@Transactional
	@Override
	public boolean insertExcel(ExcelDTO dto) {
		int orderNo=mapper.getNextOrderNo();
		dto.setOrderNo(orderNo);
		System.out.println(dto);
		int totalPrice = dto.getAmount()*dto.getPrice();
		TotalPriceDTO totalPriceDTO = new TotalPriceDTO();
		totalPriceDTO.setOrderNo(orderNo);
		totalPriceDTO.setTotalPrice(totalPrice);
		itemMapper.insertTotalPrice(totalPriceDTO);
		return mapper.insertExcel(dto)==1?true:false;
	}

	


}














