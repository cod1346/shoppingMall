package com.spring.mapper;

import java.util.List;


import com.spring.domain.BoardDTO;
import com.spring.domain.CriteriaDTO;
import com.spring.domain.ReReplyDTO;
import com.spring.domain.ReplyDTO;

public interface BoardMapper {
	public List<BoardDTO> list();
	public int create(BoardDTO dto);
	public BoardDTO read(int bno);
	public int update(BoardDTO dto);
	public int delete(int bno);
	public int totalCnt();
	public int cntUp(int bno);
	public int deleteAll(String username); 
	public int createReply(ReplyDTO dto);
	public List<ReplyDTO> replyList(int bno);
	public int replyUpdate(ReplyDTO dto);
	public int replyDelete(int reBno);
	public int replyDeleteAll(int bno);
	public int replyDeleteUsername(String username);
	public List<BoardDTO> search(CriteriaDTO dto);
	public int createReReply(ReReplyDTO dto);
	public List<ReReplyDTO> reReplyList(int bno);
	public int reReplyUpdate(ReReplyDTO dto);
	public int reReplyDelete(int reReBno);
	public int reReplyDeleteReBno(int reBno);
	public int reReplyDeleteBno(int bno);
	public int reReplyDeleteUsername(String username);
}
