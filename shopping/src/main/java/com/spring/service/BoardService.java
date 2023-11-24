package com.spring.service;

import java.util.List;

import com.spring.domain.BoardDTO;
import com.spring.domain.CriteriaDTO;
import com.spring.domain.ReReplyDTO;
import com.spring.domain.ReplyDTO;

public interface BoardService {
	public List<BoardDTO> getList();
	public List<ReplyDTO> replyList(int bno);
	
	public boolean create(BoardDTO dto);

	public BoardDTO read(int bno);

	public boolean update(BoardDTO dto);

	public boolean delete(int bno);

	public int totalCnt();
	
	public boolean createReply(ReplyDTO dto);
	
	public boolean replyUpdate(ReplyDTO dto);
	
	public boolean replyDelete(int reBno);
	
	public List<BoardDTO> search(CriteriaDTO dto);
	
	public int createReReply(ReReplyDTO dto);
	
	public List<ReReplyDTO> reReplyList(int bno);
	
	public int reReplyUpdate(ReReplyDTO dto);
	
	public int reReplyDelete(int reReBno);
	
}
