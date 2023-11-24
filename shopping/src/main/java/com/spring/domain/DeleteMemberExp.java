package com.spring.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class DeleteMemberExp {
	private String username;
	//삭제신청일
	private Date deleteDate;
	//7일
	private Date deleteConfirmDate;
  
	
}


















