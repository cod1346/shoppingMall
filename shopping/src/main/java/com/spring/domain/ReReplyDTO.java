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
public class ReReplyDTO {
	
	//댓글번호
	private int bno;
	private int reBno;
	private int reReBno;
	private String username;
	private String reContent;
	private Date regDate;
}


















