package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.spring.domain.CartDTO;
import com.spring.domain.CartOrderDTO;
import com.spring.domain.CouponDTO;
import com.spring.domain.CriteriaDTO;
import com.spring.domain.EmailDTO;
import com.spring.domain.ImageDTO;
import com.spring.domain.ItemDTO;
import com.spring.domain.ItemLikeDTO;
import com.spring.domain.OrderDiaryDTO;
import com.spring.domain.PageDTO;
import com.spring.domain.TotalPriceDTO;
import com.spring.service.ItemService;

import lombok.extern.slf4j.Slf4j;

@Controller @Slf4j @RequestMapping("/item")
public class ItemController {
	
	@Autowired
	private ItemService service;
	@Autowired
	private JavaMailSender mailSender;
	@GetMapping("/list")
	public void listGet(@ModelAttribute("cri")CriteriaDTO dto, Model model) {
		log.info("list요청");
	//	List<ItemDTO> list=service.list();
//		model.addAttribute("list", list);

		List<ItemDTO> list = service.list(dto);

		int total = service.totalCnt();
		model.addAttribute("list", list);
		model.addAttribute("pageDTO", new PageDTO(dto, total));
	}
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/create")
	public void createGet() {
		log.info("create요청");
	}
	@GetMapping("/likeCount")
	public ResponseEntity<Integer> likeCount(int ino){
		int likeCount = service.likeCount(ino);
		return new ResponseEntity<>(likeCount,HttpStatus.OK);
	}
	@GetMapping("/like")
	public ResponseEntity<String> like(ItemLikeDTO dto) {
		if(service.insertLike(dto)==1) {
			return new ResponseEntity<String>(HttpStatus.OK);
		};
		return new ResponseEntity<String>(HttpStatus.BAD_GATEWAY); 
	}
	@GetMapping("chkLike")
	public ResponseEntity<String> chkLike(ItemLikeDTO dto){
		if(service.chkLike(dto)==1) {
			return new ResponseEntity<String>("1",HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("2",HttpStatus.OK);
		}
	}
	@GetMapping("/deleteLike")
	public ResponseEntity<String> deleteLike(ItemLikeDTO dto){
		if(service.deleteLike(dto)==1) {
			return new ResponseEntity<String>(HttpStatus.OK);
		}else {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/create")
	public String createPost(ItemDTO dto) {
		log.info("create요청");
		dto.setUsername(dto.getUsername().trim());
		service.create(dto);
		return "redirect:/";
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/delete")
	public String delete(int ino) {
		ItemDTO dto = service.readItem(ino);
		deleteFile(dto.getImagePath());
		service.deleteItem(ino);
		return "redirect:/";
		
	}
	@PostMapping("/uploadImage")
	public ResponseEntity<ImageDTO> uploadImagePost(MultipartFile uploadImage) {
		log.info("upload요청");

		String uploadPath = "c:\\imageUpload";
		String uploadFolderPath = getFolder()+"\\image";
		File uploadFullPath = new File(uploadPath, uploadFolderPath);
		if (!uploadFullPath.exists()) {
			uploadFullPath.mkdirs();
		}

		ImageDTO dto = new ImageDTO();
		UUID uuid = UUID.randomUUID();
		String fileName = uuid.toString() + "_" + uploadImage.getOriginalFilename();
		//2023%5C10%5C16%5C95451881-2068-44a4-8e7a-79b372a0b91d_KakaoTalk_20230808_160509493_1202.jpg
		File saveFile = new File(uploadFullPath, fileName);

		dto.setImageName(uploadImage.getOriginalFilename());
		dto.setUploadPath(uploadFolderPath);
		dto.setUuid(uuid.toString());

		try {
			uploadImage.transferTo(saveFile);
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<>(dto, HttpStatus.OK);
	}
	
	@PostMapping("/uploadImages")
	public ResponseEntity<List<ImageDTO>> uploadAjaxPost(MultipartFile[] uploadImages) {
		log.info("upload요청");

		List<ImageDTO> imageList = new ArrayList<ImageDTO>();

		String uploadPath = "c:\\imageUpload";
		String uploadFolderPath = getFolder()+"\\images";
		File uploadFullPath = new File(uploadPath, uploadFolderPath);
		if (!uploadFullPath.exists()) {
			uploadFullPath.mkdirs();
		}else if(uploadFullPath.exists()) {
			uploadFullPath.mkdirs();
		}

		for (MultipartFile multipartFile : uploadImages) {

			UUID uuid = UUID.randomUUID();
			String fileName = uuid.toString() + "_" + multipartFile.getOriginalFilename();
			File saveFile = new File(uploadFullPath, fileName);

			ImageDTO image = new ImageDTO();
			image.setImageName(multipartFile.getOriginalFilename());
			image.setUploadPath(uploadFolderPath);
			image.setUuid(uuid.toString());

			try {
				multipartFile.transferTo(saveFile);



			} catch (Exception e) {
				e.printStackTrace();
			}
			imageList.add(image);
		}
		return new ResponseEntity<>(imageList, HttpStatus.OK);
	}

	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();
		String str = sdf.format(date);

		return str.replace("-", File.separator);
	}
	
	@GetMapping("/display")
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info("파일 요청 " + fileName);

		File file = new File("c:\\imageUpload\\" + fileName);

		ResponseEntity<byte[]> result = null;
		try {
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), HttpStatus.OK);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/deleteImage")
	public ResponseEntity<String> deleteFile(String deleteFile) {
		log.info("파일 제거 요청 "+deleteFile);
		
		try {
			File file = new File("c:\\ImageUpload\\", URLDecoder.decode(deleteFile,"utf-8"));
			
			file.delete();

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<String>("success",HttpStatus.OK);
	}
	@GetMapping("/read")
	public void readGet(int ino,Model model) {
		log.info("readGet요청" + ino);
		ItemDTO dto=service.readItem(ino);
		List<ImageDTO> imageDto=service.readItemImages(ino);
		model.addAttribute("dto", dto);
		model.addAttribute("list", imageDto);
		
	}
	@GetMapping("/insertCart")
	public String insertCartGet(CartDTO dto) {
		log.info("장바구니추가get");
		int price = Integer.parseInt(dto.getPrice());
		int amount =dto.getAmount();
		int tax = dto.getTax();
		dto.setTotalPrice(price+(price*tax/100)*amount);
		service.insertCart(dto);
		return "redirect:/";
	}
	//장바구니페이지 요청
	@PostMapping("/cart")
	public String cartGet(String username,Model model) {

		List<CartDTO> dto = service.readCart(username);
		
		model.addAttribute("cartList", dto);
		
		List<CouponDTO> list = service.readUsernameCoupon(username.trim());
	    model.addAttribute("list", list);
	    
		return "/item/cart";
	}
	@Transactional
	@PostMapping("/order")
	public ResponseEntity<String> orderPost(@RequestBody List<CartOrderDTO> dto) {
		log.info("order요청");
		System.out.println(dto);
		int orderNo=service.getNextOrderNo();
		int totalPrice = 0;
		String couponNo = "";
		TotalPriceDTO totalDto = new TotalPriceDTO();
		for (CartOrderDTO cartOrderDTO : dto) {
			CartOrderDTO orderDto = new CartOrderDTO();
			orderDto.setOrderNo(orderNo);
		    orderDto.setIno(cartOrderDTO.getIno());
		    orderDto.setAmount(cartOrderDTO.getAmount());
		    orderDto.setUsername(cartOrderDTO.getUsername());
		    couponNo = cartOrderDTO.getCouponNo();
		    ItemDTO itemDto = service.readItem(cartOrderDTO.getIno());
		    orderDto.setTax(itemDto.getTax());
		    orderDto.setImagePath(itemDto.getImagePath());
		    orderDto.setPrice(itemDto.getPrice());
		    orderDto.setItemName(itemDto.getItemName());
		    System.out.println("총금액");
		    int price = Integer.parseInt(orderDto.getPrice());
		    int tax = orderDto.getTax();
		    int amount = orderDto.getAmount();
		    System.out.println((price+(price*tax/100))*amount);
		    totalPrice +=(price+(price*tax/100))*amount;
		    service.insertOrder(orderDto);
		    
		}
		totalDto.setOrderNo(orderNo);

		CouponDTO couponDto = service.readCoupon(couponNo);
		if(couponDto!=null) {
			totalDto.setTotalPrice(totalPrice-Integer.parseInt(couponDto.getCouponVal()));
		}else {
			totalDto.setTotalPrice(totalPrice);
		}
		
		System.out.println(totalDto+"토탈디티오");
		service.insertTotalPrice(totalDto);
		service.useCoupon(orderNo,couponNo);
		service.setTotalPrice(totalPrice, orderNo);
	    return new ResponseEntity<String>(HttpStatus.OK);
	}
	@GetMapping("/order")
	public void orderGet(Model model,String username) {
		List<CartOrderDTO> list=service.chkOrder(username);
		Map<Integer, List<CartOrderDTO>> groupedOrders = new HashMap<>();
		for (CartOrderDTO order : list) {
			String couponNo = "";
			String couponVal = "";
		    int orderNo = order.getOrderNo();
		    
		    List<CouponDTO> couponList = service.readOrderNoCoupon(orderNo);
		    if(!couponList.isEmpty()) {
		    	System.out.println(couponList);
		    	System.out.println("사용된쿠폰이 있음");
		    	for(CouponDTO dto : couponList) {
		    		couponVal = dto.getCouponVal();
		    		couponNo = dto.getCouponNo();
		    	}
		    	order.setCouponNo(couponNo);
		    	order.setCouponVal(Integer.parseInt(couponVal));
		    
		    	service.updateCouponStatus(orderNo);
		    }
		    
		    
		    
		    if (!groupedOrders.containsKey(orderNo)) {
		        groupedOrders.put(orderNo, new ArrayList<>());
		    }
		    System.out.println(order);
		    groupedOrders.get(orderNo).add(order);
		}
		
		model.addAttribute("groupedOrders", groupedOrders);
	}
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/adminorder")
	public void adminOrder(Model model) {
		log.info("관리자 주문페이지 요청");
		 List<CartOrderDTO> list = service.adminOrder();
		 Map<Integer, List<CartOrderDTO>> groupedOrders = new HashMap<>();
			for (CartOrderDTO order : list) {
			    int orderNo = order.getOrderNo();

			    if (!groupedOrders.containsKey(orderNo)) {
			        groupedOrders.put(orderNo, new ArrayList<>());
			    }

			    groupedOrders.get(orderNo).add(order);
			}
		model.addAttribute("groupedOrders", groupedOrders);
	}
	//장바구니삭제
	@PostMapping("/deleteCart")
	public ResponseEntity<String> deleteCart(int cno) {
		log.info("장바구니 삭제요청");
		service.deleteCart(cno);
		return new ResponseEntity<String>(HttpStatus.OK);
	}
	@PostMapping("/deliveryUpdate")
	public String deliveryUpdatePost(int orderNo,String delivery) {
		service.updateDelivery(delivery, orderNo);
		return "redirect:/item/adminorder";
	}
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/sendCoupon")
	public void sendCouponGet() {
		log.info("coupon페이지 요청");
	}
	@PostMapping("/sendCoupon")
    public ResponseEntity<String> sendEmail(@RequestBody EmailDTO dto) {
		try {
			MimeMessage mimeMessage = mailSender.createMimeMessage();
		    MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
 
		    messageHelper.setFrom("choshopping@gmail.com"); // 보내는사람사람 이메일 
		    messageHelper.setTo(dto.getTo()); // 받는사람 이메일
		    messageHelper.setSubject(dto.getSubject()); // 메일제목
		    messageHelper.setText(dto.getText(),true); // 메일 내용
 
		    mailSender.send(mimeMessage);
		    return new ResponseEntity<>(HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	@PostMapping("/createCoupon")
	public ResponseEntity<String> createCoupon(String couponVal){
		service.createCoupon(couponVal.replaceAll("\\s|,", ""));
		System.out.println(service.currCoupon());;
		return new ResponseEntity<String>(service.currCoupon(),HttpStatus.OK);
	}
	//쿠폰등록페이지
	@GetMapping("/registerCoupon")
	public void registerCouponGet(Model model) {
		log.info("coupon등록페이지요청");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

	    Object principal = authentication.getPrincipal();

	    UserDetails userDetails = (UserDetails) principal;
	    String username = userDetails.getUsername();
	    log.info("현재 로그인된 사용자의 ID: {}", username);
	    List<CouponDTO> dto = service.readUsernameCoupon(username.trim());
	    System.out.println(dto);
	    model.addAttribute("list", dto);
	}
	@PostMapping("/registerCoupon")
	public ResponseEntity<String> registerCouponPost(@RequestBody CouponDTO dto) {
		log.info("coupon등록요청");
		CouponDTO couponDto=service.readCoupon(dto.getCouponNo());
		System.out.println(couponDto);
		
		if (dto.getUsername() == null) {
			System.out.println("1번");
			return new ResponseEntity<String>("needLogin",HttpStatus.OK);
		}else if(couponDto==null) {
			System.out.println("2번");
			return new ResponseEntity<String>("fail",HttpStatus.OK);
		}else if(couponDto.getUsername()!=null){
			System.out.println("3번");
			return new ResponseEntity<String>("already",HttpStatus.OK);
		}else {
			System.out.println("4번");
			couponDto.setUsername(dto.getUsername());
			service.updateCoupon(couponDto);
			return new ResponseEntity<String>(couponDto.getCouponVal(),HttpStatus.OK);
		}
	}
	@GetMapping("/sellChart")
	public void sellChartGet() {
		log.info("매출현황페이지 요청");
	}
	@PostMapping("/sellChart")
	public ResponseEntity<Map<String, Object>> sellChartPost(@RequestBody Date date,Model model) {
		log.info("매출현황페이지 날짜별 요청");
		System.out.println(date);
		SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");

	    String sdfDate = sdf.format(date);
	    System.out.println("sdfDate="+sdfDate);

	    String sdfDate00 = sdfDate+"-00";
	    String sdfDate24 = sdfDate+"-23";
	    List<CartOrderDTO> list = service.readDateOrder(sdfDate00,sdfDate24);
	    List<TotalPriceDTO> totalList = new ArrayList<TotalPriceDTO>();
	    
	    for (CartOrderDTO order : list) {
		    int orderNo = order.getOrderNo();
		    System.out.println(totalList+"토탈리스트");
		    
		    totalList.add(service.readTotalPriceOrderNo(orderNo));
		}
	    OrderDiaryDTO dto = service.readDiary(sdfDate00,sdfDate24);
	    System.out.println(list);
	    System.out.println(dto);
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("totalList", totalList);
	    map.put("list", list);
	    map.put("diary", dto);
	    return new ResponseEntity<>(map,HttpStatus.OK);
	}
	@PostMapping("/updateDiaryMemo")
	public ResponseEntity<String> updateDiaryMemo(@RequestBody OrderDiaryDTO dto){
		System.out.println(dto);
		SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");

	    String regDate = sdf.format(dto.getRegDate());
	    String sdfDate00 = regDate+"-00";
	    String sdfDate24 = regDate+"-23";
	    String content = dto.getContent();
	    if(service.readDiary(sdfDate00,sdfDate24)!=null) {
	    	if(service.updateDateMemo(content,regDate)) {
	    		return new ResponseEntity<>(HttpStatus.OK);
	    	}
	    }else if(service.insertDiary(content,regDate)){
  			return new ResponseEntity<>(HttpStatus.OK);
	    }
	    return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	//엑셀 업로드
//	@PostMapping("/uploadExcelFile")
//	public String uploadFile(Model model, MultipartFile file) throws IOException {
//		String fileLocation = "";
//	    InputStream in = file.getInputStream();
//	    File currDir = new File(".");
//	    String path = currDir.getAbsolutePath();
//	    fileLocation = path.substring(0, path.length() - 1) + file.getOriginalFilename();
//	    FileOutputStream f = new FileOutputStream(fileLocation);
//	    int ch = 0;
//	    while ((ch = in.read()) != -1) {
//	        f.write(ch);
//	    }
//	    f.flush();
//	    f.close();
//	    model.addAttribute("message", "File: " + file.getOriginalFilename() 
//	      + " has been uploaded successfully!");
//	    return "excel";
//	}
}
