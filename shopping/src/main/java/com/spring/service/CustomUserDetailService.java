package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.spring.domain.CustomUser;
import com.spring.domain.MemberDTO;
import com.spring.mapper.MemberMapper;

import lombok.extern.slf4j.Slf4j;


@Service
@Slf4j
public class CustomUserDetailService implements UserDetailsService {

	@Autowired
	private MemberMapper mapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		
		
		log.info("회원정보 "+username);
		
		MemberDTO dto = mapper.read(username);
		
		log.info("로그인 후 "+dto);
		
		return new CustomUser(dto);
	}

}
