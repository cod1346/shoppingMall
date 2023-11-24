package com.spring.controller;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.domain.ChangePasswordDTO;
import com.spring.domain.MemberDTO;
import com.spring.domain.DeleteDTO;
import com.spring.service.MemberService;

import lombok.extern.slf4j.Slf4j;

@Controller @RequestMapping("/member") @Slf4j
public class LoginController {

	
	@Autowired
	private MemberService service;
	
	// 로그인시 탈퇴회원 확인
	@GetMapping("/loginDeleteCheck")
	public ResponseEntity<String> loginDeleteCheck(String username) {
		System.out.println(username);
		System.out.println("username!!!");
		if(service.checkDelete(username)==1) {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
		return new ResponseEntity<String>(HttpStatus.OK);
	}
	//회원탈퇴 취소
	@GetMapping("/cancelDelete")
	public void cancelDeleteGet() {
		log.info("탈퇴취소페이지 요청");
	}
	@PostMapping("/cancelDelete")
	public String cancelDelete(MemberDTO dto,Model model){
		System.out.println(dto);
		System.out.println("dto");
		if(service.cancelDelete(dto)) {
			return "/member/login";	
		}else {
			model.addAttribute("error","아이디나 패스워드를 확인");
			return "/member/cancelDelete";
		}
	}
	@PostMapping("/login")
	public String loginPost() {
		log.info("로그인 성공");
		return "/board/list";
	}
	@GetMapping("/login")
	public void loginGet() {
		log.info("로그인페이지 요청");
	}
	
	@GetMapping("/login-error")
	public String loginError(Model model) {
		log.info("로그인 실패");
		model.addAttribute("error","아이디나 패스워드를 확인");
		return "/member/login";
	}
	@GetMapping("/register")
	public void registerGet() {
		log.info("회원가입 페이지 요청");
	}
	//회원가입
	@PostMapping("/register")
	public String registerPost(MemberDTO dto,Model model) {
		log.info("회원가입 요청");
		if(service.register(dto)) {
			model.addAttribute("register", "회원가입 성공");
			return "/member/login";
		} 	
		return "redirect:/member/register";	
	}
	
	// 중복 아이디 점검
	@GetMapping("/idChk")
	@ResponseBody //컨트롤러 작업이 완료될때 결과값으로 리턴시킴 (뷰 리졸버를 동작시키지 않음) 
	public ResponseEntity<String> memberIdChkPost(String username){	
		log.info("중복 아이디 체크");	
		System.out.println("---username--"+username);
		boolean result = service.idCheck(username);
		if(result) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
		
	@GetMapping("/update")
	public void updateGet() {
		
	}
	
	@GetMapping("/changePwd")
	public ResponseEntity<String> passwordChk(ChangePasswordDTO dto) {
		
		if(service.changePwd(dto)) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
				
		}
	}
	
	@GetMapping("/delete")
	public void delete() {
		
	}
	
	@GetMapping("/deleteConfirm")
	public ResponseEntity<String> deleteConfirm(DeleteDTO dto,HttpSession session){
		// 7일 유예기간
		ScheduledExecutorService scheduledExecutorService = Executors.newSingleThreadScheduledExecutor();

		Runnable scheduledTask = () -> {
			service.deleteConfirm(dto.getUsername());
		};
		
		System.out.println("여기까지!!!1");
		
		if(service.leave(dto)) {
			session.invalidate();
			System.out.println("여기까지!!!2");
			scheduledExecutorService.schedule(scheduledTask, 30, TimeUnit.SECONDS);
			return new ResponseEntity<String>(HttpStatus.OK);
		}else {
			System.out.println("여기까지!!!3");
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}
	@PostMapping("/searchEmail")
	public ResponseEntity<String> searchEmail(String username){
		System.out.println(username);
		String email=service.searchEmail(username);
		System.out.println(email);
		if(email==null) {
			return new ResponseEntity<String>("No results found",HttpStatus.OK);
		}else {
			return new ResponseEntity<String>(email,HttpStatus.OK);
		}
	}
}
