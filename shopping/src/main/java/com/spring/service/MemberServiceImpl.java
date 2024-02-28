package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.ChangePasswordDTO;
import com.spring.domain.DeleteDTO;
import com.spring.domain.DeleteMemberExp;
import com.spring.domain.MemberDTO;
import com.spring.mapper.BoardMapper;
import com.spring.mapper.MemberMapper;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	private MemberMapper mapper;
	
	@Autowired
	private BoardMapper boardMapper;
	@Autowired
	private BCryptPasswordEncoder encoder;	
	

	
	@Override
	@Transactional
	public boolean register(MemberDTO dto) {	
		
		// 비밀번호 암호화
		dto.setPassword(encoder.encode(dto.getPassword()));		
		
		// 회원가입
		boolean result = mapper.register(dto) == 1;
		

		return result;		
	}
	
	
	
	@Override
    public MemberDTO read(String username) {		
        return mapper.read(username);       
    }

	//중복아이디
	@Override
	public boolean idCheck(String username) {		
		return mapper.idCheck(username)==0? true:false;
	}

	//비밀번호변경
	@Override
	public boolean changePwd(ChangePasswordDTO passwordDTO) {
		// 해당 아이디 불러오기
		MemberDTO dto = mapper.read(passwordDTO.getUsername());
		
		// 비번 일치 확인 (사용자가 입력한 기존 비번, db에 암호화된 비번)				
		if(encoder.matches(passwordDTO.getPassword(), dto.getPassword())) {					
			// 일치시 변경할 비밀번호 암호화, 비번 업데이트
			passwordDTO.setNewPwd(encoder.encode(passwordDTO.getNewPwd()));					
			return mapper.changePwd(passwordDTO)==1; // 비번 업데이트시 true반환			
		} 
		return false;
	}

	// 7일유예기간 후 삭제
	@Override
	public boolean deleteConfirm(String username) {
		System.out.println(mapper.checkDelete(username));
		System.out.println("거의다왔다");
		if(mapper.checkDelete(username)==1) {
			boardMapper.reReplyDeleteUsername(username);
			boardMapper.replyDeleteUsername(username);
			boardMapper.deleteAll(username);
			System.out.println("거의다왔다true");
			mapper.deleteDelete(username);
			
			return mapper.leave(username)==1; // 회원 정보 삭제시 true 반환
		}
		System.out.println("거의다왔다false");
		return false;
	}
	@Override
	public int checkDelete(String username) {
		return mapper.checkDelete(username);
	}

	

	
	//7일유예기간 설정
	@Transactional
	@Override
	public boolean leave(DeleteDTO deleteDTO) {
		System.out.println(boardMapper.replyList(2));
		
		// 해당 아이디 불러오기	
		MemberDTO dto = mapper.read(deleteDTO.getUsername());
		
		
		System.out.println("멤버서비스임플1");
		// matches(암호화하기 전 코드, db에 암호화된 코드)
		if(encoder.matches(deleteDTO.getPassword(), dto.getPassword())) {
			
			System.out.println("멤버서비스임플2");
			//탈퇴시 작성 게시물 전부 삭제
			
//			// 회원 탈퇴 작업 수행
//			System.out.println("멤버서비스임플4");
			
			
			return mapper.deleteConfirm(dto.getUsername())==1;
			//boardMapper.deleteAll(deleteDTO.getUsername())==1;
			//mapper.deleteConfirm(dto.getUsername())==1;
		} 	
		return false;				
	}
	

	

	//탈퇴계정조회
	@Override
	public DeleteMemberExp readDelete(String username) {
		
		return mapper.readDelete(username);
	}


	//회원탈퇴 취소
	@Override
	public boolean deleteDelete(String username) {
		// TODO Auto-generated method stub
		return false;
	}



	@Override
	public boolean cancelDelete(MemberDTO dto) {
		// 해당 아이디 불러오기
		MemberDTO dto2 = mapper.read(dto.getUsername());
		System.out.println(dto);
		System.out.println(dto2);
		// 비번 일치 확인 (사용자가 입력한 기존 비번, db에 암호화된 비번)	
		if (dto2 != null) {
			if(encoder.matches(dto.getPassword(), dto2.getPassword())) {					
			// 일치시 member_delete테이블 삭제
				return mapper.deleteDelete(dto.getUsername())==1;			
			} 
		}
		return false;
	}



	@Override
	public String searchEmail(String username) {
		return mapper.searchEmail(username);
	}



	







	

	


	

	
	



}






