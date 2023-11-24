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
public class CouponDTO {
	private String couponNo;
	private String couponVal;
	private String username;
	private int status;
}


















