package com.spring.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.spring.domain.ChatBotDTO;
import com.spring.mapper.HomeMapper;

@Service
public class HomeServiceImpl implements HomeService {

	@Autowired
	private HomeMapper mapper;

	@Override
	public ChatBotDTO questionChatBot(String question) {
		return mapper.questionChatBot(question);
	}

	


}














