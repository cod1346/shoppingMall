package com.spring.service;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.domain.CartDTO;
import com.spring.domain.CartOrderDTO;
import com.spring.domain.CouponDTO;
import com.spring.domain.CriteriaDTO;
import com.spring.domain.ImageDTO;
import com.spring.domain.ItemDTO;
import com.spring.domain.ItemLikeDTO;
import com.spring.domain.OrderDiaryDTO;
import com.spring.domain.TotalPriceDTO;

public interface ItemService {
	
	public boolean create(ItemDTO dto);
	public List<ItemDTO> list(CriteriaDTO dto);
	public int likeCount(int ino);
	public int insertLike(ItemLikeDTO dto);
	public int chkLike(ItemLikeDTO dto);
	public int deleteLike(ItemLikeDTO dto);
	public int deleteItem(int ino);
	public int deleteLikeAll(int ino);
	public ItemDTO readItem(int ino);
	public List<ImageDTO> readItemImages(int ino);
	public int totalCnt();
	public int deleteItemImages(int ino);
	public boolean insertCart(CartDTO dto);
	public List<CartDTO> readCart(String username);
	public int insertOrder(CartOrderDTO dto);
	public List<CartOrderDTO> chkOrder(String username);
	public List<CartOrderDTO> adminOrder();
	public int getNextOrderNo();
	public boolean deleteCart(int cno);
	public boolean updateDelivery(String delivery,int orderNo);
	public boolean createCoupon(String couponVal);
	public String currCoupon();
	public CouponDTO readCoupon(String couponNo);
	public boolean updateCoupon(CouponDTO dto);
	public List<CouponDTO> readUsernameCoupon(String username);
	public boolean setTotalPrice(int totalPrice,int orderNo);
	public boolean useCoupon(int orderNo,String couponNo);
	public List<CouponDTO> readOrderNoCoupon(int orderNo);
	public boolean updateCouponStatus(int orderNo);
	public List<CartOrderDTO> readDateOrder(String sdfDate00,String sdfDate24);
	public OrderDiaryDTO readDiary(String sdfDate00,String sdfDate24);
	public boolean updateDateMemo(String content,String regDate);
	public boolean insertDiary(String content,String regDate);
	public boolean insertTotalPrice(TotalPriceDTO dto);
	public TotalPriceDTO readTotalPriceOrderNo(int orderNo);
	public List<TotalPriceDTO> readTotalPriceOrderAll();
	public Integer readTotalPrice(int orderNo);
	public boolean updateTotalPrice(TotalPriceDTO dto);
}
