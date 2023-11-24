package com.spring.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter @Getter @ToString
@AllArgsConstructor @NoArgsConstructor
public class ChangePasswordDTO {
	//changePwd.jsp와 일치시키기
	private String username;		//아이디
	private String password;	//현재비번
	private String newPwd;		//새비번

}
