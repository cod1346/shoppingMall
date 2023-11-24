package com.spring.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.CartDTO;
import com.spring.domain.CartOrderDTO;
import com.spring.domain.CouponDTO;
import com.spring.domain.CriteriaDTO;
import com.spring.domain.ImageDTO;
import com.spring.domain.ItemDTO;
import com.spring.domain.ItemLikeDTO;
import com.spring.domain.OrderDiaryDTO;
import com.spring.domain.TotalPriceDTO;
import com.spring.mapper.ItemMapper;

@Service
public class ItemServiceImpl implements ItemService {

	@Autowired
	private ItemMapper mapper;

	
	@Override
	public boolean create(ItemDTO dto) {
		int ino = mapper.getNextIno();
		dto.setIno(ino);
		boolean insertFlag = mapper.create(dto)==1?true:false;
		System.out.println("---------------");
		System.out.println(dto.getImagesPathList());
		dto.getImagesPathList().forEach(images->{
			System.out.println(dto.getIno());
			images.setIno(dto.getIno());
			mapper.createImages(images);
		});
		return insertFlag;
	}


	@Override
	public List<ItemDTO> list(CriteriaDTO dto) {
		return mapper.list(dto);
	}


	@Override
	public int likeCount(int ino) {
		return mapper.likeCount(ino);
	}


	@Override
	public int insertLike(ItemLikeDTO dto) {
		return mapper.insertLike(dto);
	}


	@Override
	public int chkLike(ItemLikeDTO dto) {
		return mapper.chkLike(dto);
	}


	@Override
	public int deleteLike(ItemLikeDTO dto) {
		return mapper.deleteLike(dto);
	}

	@Override
	@Transactional
	public int deleteItem(int ino) {
		mapper.deleteLikeAll(ino);
		mapper.deleteItemImages(ino);
		return mapper.deleteItem(ino);
	}


	@Override
	public int deleteLikeAll(int ino) {
		return mapper.deleteItem(ino);
	}


	@Override
	public ItemDTO readItem(int ino) {
		return mapper.readItem(ino);
	}


	@Override
	public int totalCnt() {
		System.out.println("-----------------------------------------------");
		System.out.println("토탈카운트 : "+mapper.totalCnt());
		return mapper.totalCnt();
	}


	@Override
	public int deleteItemImages(int ino) {
		return mapper.deleteItemImages(ino);
	}


	@Override
	public List<ImageDTO> readItemImages(int ino) {
		return mapper.readItemImages(ino);
	}


	@Override
	public boolean insertCart(CartDTO dto) {

		return mapper.insertCart(dto)==1?true:false;
	}


	@Override
	public List<CartDTO> readCart(String username) {
		
		return mapper.readCart(username);
	}


	@Override
	public int insertOrder(CartOrderDTO dto) {
		return mapper.insertOrder(dto);
	}


	@Override
	public List<CartOrderDTO> chkOrder(String username) {
		return mapper.chkOrder(username);
	}


	@Override
	public List<CartOrderDTO> adminOrder() {
		return mapper.adminOrder();
	}


	@Override
	public int getNextOrderNo() {
		return mapper.getNextOrderNo();
	}


	@Override
	public boolean deleteCart(int cno) {
		return mapper.deleteCart(cno)==1?true:false;
	}


	@Override
	public boolean updateDelivery(String delivery, int orderNo) {
		System.out.println(delivery+orderNo);
		return mapper.updateDelivery(delivery, orderNo)==1?true:false;
	}


	@Override
	public boolean createCoupon(String couponVal) {
		return mapper.createCoupon(couponVal)==1?true:false;
	}


	@Override
	public String currCoupon() {
		return mapper.currCoupon();
	}


	@Override
	public CouponDTO readCoupon(String couponNo) {
		return mapper.readCoupon(couponNo);
	}


	@Override
	public boolean updateCoupon(CouponDTO dto) {
		return mapper.updateCoupon(dto)==1?true:false;
	}


	@Override
	public List<CouponDTO> readUsernameCoupon(String username) {
		return mapper.readUsernameCoupon(username);
	}


	@Override
	public boolean setTotalPrice(int totalPrice, int orderNo) {
		return mapper.setTotalPrice(totalPrice, orderNo)==1?true:false;
	}


	@Override
	public boolean useCoupon(int orderNo,String couponNo) {
		return mapper.useCoupon(orderNo,couponNo)==1?true:false;
	}


	@Override
	public List<CouponDTO> readOrderNoCoupon(int orderNo) {
		return mapper.readOrderNoCoupon(orderNo);
	}


	@Override
	public boolean updateCouponStatus(int orderNo) {
		return mapper.updateCouponStatus(orderNo)==1?true:false;
	}


	@Override
	public List<CartOrderDTO> readDateOrder(String sdfDate00,String sdfDate24) {
		return mapper.readDateOrder(sdfDate00,sdfDate24);
	}


	@Override
	public OrderDiaryDTO readDiary(String sdfDate00,String sdfDate24) {
		return mapper.readDiary(sdfDate00,sdfDate24);
	}


	@Override
	public boolean updateDateMemo(String content,String regDate) {
		return mapper.updateDateMemo(content,regDate)==1?true:false;
	}


	@Override
	public boolean insertDiary(String content,String regDate) {
		return mapper.insertDiary(content,regDate)==1?true:false;
	}


	@Override
	public boolean insertTotalPrice(TotalPriceDTO dto) {
		return mapper.insertTotalPrice(dto)==1?true:false;
	}


	@Override
	public TotalPriceDTO readTotalPriceOrderNo(int orderNo) {
		return mapper.readTotalPriceOrderNo(orderNo);
	}


	@Override
	public List<TotalPriceDTO> readTotalPriceOrderAll() {
		return mapper.readTotalPriceOrderAll();
	}


	@Override
	public Integer readTotalPrice(int orderNo) {
		return mapper.readTotalPrice(orderNo);
	}


	@Override
	public boolean updateTotalPrice(TotalPriceDTO dto) {
		return mapper.updateTotalPrice(dto)==1?true:false;
	}
	
	

}














