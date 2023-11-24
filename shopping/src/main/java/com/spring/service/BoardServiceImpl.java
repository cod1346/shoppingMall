package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import com.spring.domain.BoardDTO;
import com.spring.domain.CriteriaDTO;
import com.spring.domain.ReReplyDTO;
import com.spring.domain.ReplyDTO;
import com.spring.mapper.BoardMapper;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper mapper;

	@Override
	public List<BoardDTO> getList() {
		return mapper.list();
	}
	


	@Transactional
	@Override
	public boolean create(BoardDTO dto) {

		boolean insertFlag = mapper.create(dto)==1?true:false;
		
		return insertFlag;
	}
	
	@Transactional
	@Override
	public BoardDTO read(int bno) {	
		System.out.println("------serviceImpl read========");
		mapper.cntUp(bno);
		BoardDTO dto = mapper.read(bno);

		return dto;
	}
	
	@Override
	public boolean update(BoardDTO dto) {	
		
		boolean updateFlag = mapper.update(dto)==1?true:false;

		
		return updateFlag;
	}
	
	@Transactional
	@Override
	public boolean delete(int bno) {
		mapper.reReplyDeleteBno(bno);
		mapper.replyDeleteAll(bno);
		return mapper.delete(bno)==1?true:false;
	}

	@Override
	public int totalCnt() {		
		return mapper.totalCnt();
	}



	@Override
	public boolean createReply(ReplyDTO dto) {
			
		boolean insertFlag = mapper.createReply(dto)==1?true:false;
		
		return insertFlag;
	}



	@Override
	public List<ReplyDTO> replyList(int bno) {
		return mapper.replyList(bno);
	}



	@Override
	public boolean replyUpdate(ReplyDTO dto) {
		
		return mapper.replyUpdate(dto)==1?true:false;
	}



	@Override
	public boolean replyDelete(int reBno) {
		mapper.reReplyDeleteReBno(reBno);
		return mapper.replyDelete(reBno)==1?true:false;
	}



	@Override
	public List<BoardDTO> search(CriteriaDTO dto) {
		
		return mapper.search(dto);
	}



	@Override
	public int createReReply(ReReplyDTO dto) {
		dto.setUsername(dto.getUsername().trim());
		return mapper.createReReply(dto);
	}



	@Override
	public List<ReReplyDTO> reReplyList(int bno) {
		
		return mapper.reReplyList(bno);
	}



	@Override
	public int reReplyUpdate(ReReplyDTO dto) {
		return mapper.reReplyUpdate(dto);
	}



	@Override
	public int reReplyDelete(int reReBno) {
		
		return mapper.reReplyDelete(reReBno);
	}





}














