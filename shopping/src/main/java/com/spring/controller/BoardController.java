package com.spring.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.domain.BoardDTO;
import com.spring.domain.CriteriaDTO;
import com.spring.domain.ReReplyDTO;
import com.spring.domain.ReplyDTO;
import com.spring.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Controller @Slf4j @RequestMapping("/board")
public class BoardController {
	
	
	@Autowired
	private BoardService service;


	@PostMapping("/list")
	public void boardListPost(Model model) {
		log.info("board이동");
		
		List<BoardDTO> list = service.getList();
		int totalCnt = service.totalCnt();
		
		model.addAttribute("list",list);
		model.addAttribute("totalCnt",totalCnt);
	}
	
	@GetMapping("/list")
	public void boardListGet(Model model) {
		
		List<BoardDTO> list = service.getList();
		int totalCnt = service.totalCnt();
		
		model.addAttribute("list",list);
		model.addAttribute("totalCnt",totalCnt);
	}
	//검색
	@PostMapping("/search")
	public String boardSearch(CriteriaDTO dto,Model model) {
		List<BoardDTO> list = service.search(dto);
		int totalCnt = service.totalCnt();
		
		model.addAttribute("list",list);
		model.addAttribute("totalCnt",totalCnt);
		return "/board/list";
	}
	@GetMapping("/create")
	public void create(Principal principal) {
		log.info("createGet");
		
	}
	@PostMapping("/create")
	public String createPost(Principal principal,BoardDTO dto) {
		System.out.println(dto.getContent().contains("!")?"잇음":"없음");
		dto.setUsername(principal.getName().trim());
		service.create(dto);
		return "redirect:/board/list";
	}
	@GetMapping("/createChk")
	public ResponseEntity<String> createChk(String content){
		System.out.println("------createChk");
		System.out.println(content);
		if(content.contains("!")||content.contains("@")||content.contains("#")||content.contains("$")) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			return new ResponseEntity<>(HttpStatus.OK);
		}
	}
	
	@GetMapping("/read")
	public void read(int bno,Model model) {
		System.out.println("--리드-----리드-----리드-----리드-----리드-----리드---");
		BoardDTO dto=service.read(bno);
		List<ReplyDTO> replyList = service.replyList(bno);
		List<ReReplyDTO> reReplyList = service.reReplyList(bno);
		System.out.println(reReplyList);
		model.addAttribute("dto",dto);
		model.addAttribute("replyList",replyList);
		model.addAttribute("reReplyList",reReplyList);
	}
	
	@GetMapping("/update")
	public void updateGet(int bno,Model model) {
		System.out.println("--글수정get---"+bno);
		BoardDTO dto = service.read(bno);
		model.addAttribute("dto",dto);
	}
	@GetMapping("/updateIdChk")
	public ResponseEntity<String> updateIdChk(int bno,String username,Model model) {
		BoardDTO dto = service.read(bno);
		System.out.println("username='"+username.trim()+"'"+"getname : '"+dto.getUsername()+"'");
		if(dto.getUsername().equals(username.trim())) {
			System.out.println("같음");
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			System.out.println("틀림");
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	@PostMapping("/update")
	public String updatePost(BoardDTO dto) {
		System.out.println("--글수정post---dto : "+dto);
		
		service.update(dto);
		return "redirect:/board/list";
	}
	
	@GetMapping("/delete")
	public String delete(int bno) {
		System.out.println("--글삭제---");
		service.delete(bno);
		return "redirect:/board/list";	
	}
	
	// 게시글 삭제
	@GetMapping("/deleteIdChk")
	public ResponseEntity<String> deleteIdChk(int bno,String username,Model model) {
	
		BoardDTO dto = service.read(bno);
		System.out.println("username='"+username.trim()+"'"+"getname : '"+dto.getUsername()+"'");
		if(dto.getUsername().equals(username.trim())) {
			System.out.println("같음");
			service.delete(bno);
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			System.out.println("틀림");
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	@PostMapping("/createReply")
	public String createReply(ReplyDTO dto) {
		System.out.println("replydto는 : "+dto);
			dto.setUsername(dto.getUsername().trim());
			service.createReply(dto);
			return "redirect:/board/list";
	}
	
	@PostMapping("/replyUpdate")
	public String replyUpdate(ReplyDTO dto) {
		System.out.println(dto);
		service.replyUpdate(dto);
		return "redirect:/board/list";
	}
	@GetMapping("/replyDelete")
	public ResponseEntity<String> replyDelete(int reBno){
		System.out.println(reBno);
		
		if(service.replyDelete(reBno)) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_GATEWAY);
		}
	}
	
	@PostMapping("/createReReply")
	public String createReReply(ReReplyDTO dto) {
		System.out.println(dto);
		System.out.println("dto");
		service.createReReply(dto);
		return "redirect:/board/list";
	}
	@PostMapping("/reReplyUpdate")
	public String reReplyUpdate(ReReplyDTO dto) {
		System.out.println("-------------------------------------");
		System.out.println(dto);
		System.out.println("-------------------------------------");
		service.reReplyUpdate(dto);
		return "redirect:/board/list";
	}
	@GetMapping("/reReplyDelete")
	public ResponseEntity<String> reReplyDelete(int reReBno){
		System.out.println(reReBno);
		
		if(service.reReplyDelete(reReBno)==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_GATEWAY);
		}
	}
}
