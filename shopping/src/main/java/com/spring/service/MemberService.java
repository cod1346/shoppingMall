package com.spring.service;



import com.spring.domain.DeleteDTO;
import com.spring.domain.DeleteMemberExp;
import com.spring.domain.MemberDTO;
import com.spring.domain.ChangePasswordDTO;

public interface MemberService {
	//회원가입
	public boolean register(MemberDTO dto);	
	//정보조회
	public MemberDTO read(String username);	
	//비번수정
	public boolean changePwd(ChangePasswordDTO dto);	
	//아이디중복체크
	public boolean idCheck(String username);
	//회원탈퇴
	public boolean leave(DeleteDTO deleteDTO);
	//회원탈퇴 계정 조회
	public int checkDelete(String username);
	public DeleteMemberExp readDelete(String username);
	//7일 유예기간 설정
	public boolean deleteConfirm(String username);
	//유에기간 테이블 삭제
	public boolean deleteDelete(String username);
	//회원탈퇴 취소
	public boolean cancelDelete(MemberDTO dto);
	public String searchEmail(String username);
	
}
