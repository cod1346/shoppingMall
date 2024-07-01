package com.spring.domain;



import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class CartOrderDTO {
	private int ino;
	private String username;
	private int amount;
	private String imagePath;
	private String itemName;
	private String price;
	private int orderNo;
	private int tax;
	private Date orderDate;
	private String delivery;
	private int totalPrice;
	private String couponNo;
	private int couponVal;
	/////////////////////
	////
	////
}


















