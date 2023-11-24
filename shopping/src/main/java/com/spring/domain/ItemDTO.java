package com.spring.domain;

import java.sql.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class ItemDTO {
	private int ino;
	private String username;
	private String itemName;
	private String price;
	private Date regDate;
	private String imagePath; 
	private List<ImageDTO> imagesPathList;
	private String origin;
	private String ingredient;
	private String point; 
	private String gender;
	private String delivery;
	private String tel;
	private int tax;
}


















