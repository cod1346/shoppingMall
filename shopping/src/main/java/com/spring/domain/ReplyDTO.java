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
public class ReplyDTO {
	//원본글번호
	private int bno;
	//댓글번호
	private int reBno;
	private String username;
	private String content;
	private Date regDate;
}


















