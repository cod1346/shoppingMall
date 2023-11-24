package com.spring.domain;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class ExcelDTO{
	private String itemName;
	private int price;
	private int amount;
	private String orderDate;
	private String username;
	private int orderNo;

}


















