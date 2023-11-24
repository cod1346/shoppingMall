package com.spring.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @AllArgsConstructor @ToString
public class PageDTO {
	private int startPage;
	private int endPage;
	
	
	private int total;
	
	private CriteriaDTO cri;
	
	public PageDTO(CriteriaDTO cri,int total) {
		this.total = total;
		this.cri = cri;
		//cri.setAmount(9);
		
		this.endPage = (int)(Math.ceil(cri.getPage()/10.0))*10;
		this.startPage = this.endPage-9;
		
		
		int realEnd = (int)(Math.ceil(total / (double)cri.getAmount()));
		System.out.println(total);
		System.out.println("리얼엔드");
		System.out.println(realEnd);
	    if (realEnd < this.endPage) {
	        this.endPage = realEnd;
	    }
	}
	
}
