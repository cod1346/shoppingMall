package com.spring.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.domain.ChatBotDTO;
import com.spring.service.HomeService;

import lombok.extern.slf4j.Slf4j;


@Controller @Slf4j @RequestMapping("/")
public class HomeController {
	
	@Autowired
	private HomeService service;
	
	@GetMapping("/")
	public String home() {
		
		log.info("home요청");
		return "home";
	}
	@GetMapping("/chatBot")
	public ResponseEntity<ChatBotDTO> chatBotGet(String question){
		System.out.println(question);
		ChatBotDTO dto = service.questionChatBot(question.trim());
		if(dto!=null) {
			return new ResponseEntity<ChatBotDTO>(dto,HttpStatus.OK);
		}else {
			return new ResponseEntity<ChatBotDTO>(HttpStatus.NOT_FOUND);
		}
	}
	
}
