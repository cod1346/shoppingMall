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
public class BoardDTO {
	private int bno;
	private String username;
	private String title;
	private String content;
	private Date regDate;
	private Date updateDate;
	//조회수
	private int cnt;
	//전체개시물갯수
	private int totalCnt;
	
	
	//일단 푸쉬하기위해서 테스트용 수정
}


















