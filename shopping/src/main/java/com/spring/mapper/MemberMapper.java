package com.spring.mapper;


import com.spring.domain.MemberDTO;
import com.spring.domain.ChangePasswordDTO;
import com.spring.domain.DeleteMemberExp;

public interface MemberMapper {
	public int register(MemberDTO dto);
	
	public MemberDTO read(String username);
	
	public int idCheck(String username);
	public int changePwd(ChangePasswordDTO passwordDTO);	
	public int leave(String username);
	public int deleteConfirm(String username);
	public DeleteMemberExp readDelete(String username);
	public int checkDelete(String username);
	public int deleteDelete(String username);
	public String searchEmail(String username);
}
