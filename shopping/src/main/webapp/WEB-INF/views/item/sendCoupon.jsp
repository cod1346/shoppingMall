<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>쿠폰 메일 발송 페이지</div>
	<a href="/">홈으로</a>
	<form method="post" action="/item/sendCoupon" id="form">
		<div><input type="email" id="to" name="to" placeholder="메일주소"/></div>
		<div><input type="text" hidden="" id="subject" name="subject" placeholder="제목" value="조민성쇼핑몰 쿠폰도착"/></div>
		<div><input hidden="" id="text" name="text"></div>
		<div>
			<select id="couponVal">
				<option>5,000</option>
				<option>10,000</option>
				<option>20,000</option>
			</select>
		</div>
		<input type="hidden" id="csrf" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<div>
			<button type="button" id="createCouponBtn">쿠폰생성</button>
			<input hidden="" id="couponNo" value="" readonly="readonly">
		</div>
		<button type="submit" id="sendBtn">메일발송</button>
	</form>
	
	<form method="post" action="/member/searchEmail">
		<input type="text" id="searchUsername" placeholder="유저 이메일 검색(id입력)">
		<input type="hidden" id="csrf" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<button type="submit" id="searchEmailBtn">검색</button>
	</form>
	<div id="userEmail"></div>
</body>
<script>
const couponNo = document.querySelector("#couponNo")
   
document.querySelector("#sendBtn").addEventListener("click", (e) => {
	  e.preventDefault()
	  
	  if(couponNo.value==""){
		  alert("쿠폰을 생성해주세요")
	  }else{
		  document.querySelector("#text").value=
				"11월 조민성쇼핑몰이벤트쿠폰을 드립니다.<br>2023년 11월 6일~11월 30일<br>쿠폰가 : "
			   +document.querySelector("#couponVal").value+"円<br>쿠폰번호 : "+couponNo.value+"<br><a href='/localhost:8080'>쇼핑몰로 이동</a>"
		  
		  let to = document.querySelector("#to").value;
		  let subject = document.querySelector("#subject").value;
		  let text = document.querySelector("#text").value;
		  
		  let data = {
				    to: to,
				    subject: subject,
				    text: text
				  };
		  console.log(data)
		  fetch("/item/sendCoupon", {
		    method: "post",
		    headers: {
		      "X-CSRF-TOKEN": document.querySelector("#csrf").value,
		      "Content-Type": "application/json",
		    },
		    body: JSON.stringify(data),
		  })
		    .then((response) => {
		      if (response.ok) {
		        alert("메일 전송 완료");
		        window.location.href = "/";
		      }else{
		        alert("메일 전송 실패")
		      }
		  })
	  }
});
   
document.querySelector("#searchEmailBtn").addEventListener("click", (e) => {
	  e.preventDefault()
	  let username = document.querySelector("#searchUsername")
	  fetch("/member/searchEmail?username="+username.value, {
	    method: "post",
	    headers: {
	      "X-CSRF-TOKEN": document.querySelector("#csrf").value,
	    },
	  })
	    .then((response) => {
	      if (response.ok) {
			return response.text()
	      }
	  }).then(data => {
	        document.querySelector("#userEmail").innerHTML = data;
	    });
});
//쿠폰생성

document.querySelector("#createCouponBtn").addEventListener("click", (e) => {
  if(couponNo.value==""){
   fetch("/item/createCoupon?couponVal="+document.querySelector("#couponVal").value, {
        method: "post",
        headers: {
          "X-CSRF-TOKEN": document.querySelector("#csrf").value,
        },
      })
      .then((response) => {
        if (response.ok) {
      return response.text()
        }
      })
      .then(data => {
    	 couponNo.value=data
	     couponNo.removeAttribute("hidden");
      }
   )
  }else{
    alert("이미 쿠폰이 생성되었습니다.")
  }
});
</script>
</html>