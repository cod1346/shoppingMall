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
public class CartDTO {
	private int cno;
	private int ino;
	private String username;
	private int amount;
	private String itemName;
	private String price;
	private String imagePath; 
	private int tax;
	private int totalPrice;
}


















