package com.spring.mapper;

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

public interface ItemMapper {
	public int create(ItemDTO dto);
	public List<ItemDTO> list(CriteriaDTO dto);
	public int likeCount(int ino);
	public int insertLike(ItemLikeDTO dto);
	public int chkLike(ItemLikeDTO dto);
	public int deleteLike(ItemLikeDTO dto);
	public int deleteItem(int ino);
	public int deleteItemImages(int ino);
	public int deleteLikeAll(int ino);
	public ItemDTO readItem(int ino);
	public List<ImageDTO> readItemImages(int ino);
	public int createImages(ImageDTO dto);
	public int getNextIno();
	public int totalCnt();
	public int insertCart(CartDTO dto);
	public List<CartDTO> readCart(String username);
	public int insertOrder(CartOrderDTO dto);
	public List<CartOrderDTO> chkOrder(String username);
	public List<CartOrderDTO> adminOrder();
	public int getNextOrderNo();
	public int deleteCart(int cno);
	public int updateDelivery(@Param("delivery") String delivery,@Param("orderNo") int orderNo);
	public int createCoupon(String couponVal);
	public String currCoupon();
	public CouponDTO readCoupon(String couponNo);
	public int updateCoupon(CouponDTO dto);
	public List<CouponDTO> readUsernameCoupon(String username);
	public int setTotalPrice(@Param("totalPrice") int totalPrice,@Param("orderNo")int orderNo);
	public int useCoupon(@Param("orderNo")int orderNo,@Param("couponNo")String couponNo);
	public List<CouponDTO> readOrderNoCoupon(int orderNo);
	public int updateCouponStatus(int orderNo);
	public List<CartOrderDTO> readDateOrder(@Param("sdfDate00") String sdfDate00,@Param("sdfDate24")String sdfDate24);
	public OrderDiaryDTO readDiary(@Param("sdfDate00") String sdfDate00,@Param("sdfDate24")String sdfDate24);
	public int updateDateMemo(@Param("content")String content,@Param("regDate")String regDate);
	public int insertDiary(@Param("content")String content,@Param("regDate")String regDate);
	public int insertTotalPrice(TotalPriceDTO dto);
	public TotalPriceDTO readTotalPriceOrderNo(int orderNo);
	public List<TotalPriceDTO> readTotalPriceOrderAll();
	public Integer readTotalPrice(int orderNo);
	public int updateTotalPrice(TotalPriceDTO dto);
}
