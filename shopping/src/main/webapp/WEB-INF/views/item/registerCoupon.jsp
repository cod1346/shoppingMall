<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>쿠폰 등록 페이지</div>
	<a href="/">홈으로</a>
	<form method="post" action="/item/registerCoupon" id="form">
		<div><input placeholder="쿠폰번호" id="couponNo" name="couponNo"></div>
		<input type="hidden" id="csrf" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		
		<security:authorize access="isAuthenticated()">
			<input hidden="" name="username" id="username" value=<security:authentication property="principal.username"/>>
		</security:authorize>
		<button type="submit" id="sendBtn">쿠폰등록</button>
	</form>
	
	<h2>보유중인 쿠폰</h2>
	<c:forEach items="${list}" var="dto">
		<c:choose>
			<c:when test="${dto.status eq 0}">
				<div>쿠폰가 : ${dto.couponVal}円</div>
		    </c:when>
		    <c:otherwise>
				<div>쿠폰가 : ${dto.couponVal}円(이미 사용함)</div>
		    </c:otherwise>
		</c:choose>
	</c:forEach>
</body>
<script>
const couponNo = document.querySelector("#couponNo")
   
document.querySelector("#sendBtn").addEventListener("click", (e) => {
  e.preventDefault()
  
  if(couponNo.value==""){
    alert("쿠폰번호를 입력해주세요")
  }else{

	let username = document.querySelector("#username").value;
	let couponNo = document.querySelector("#couponNo").value;
	  
    let data = {
          username: username,
          couponNo: couponNo
        };
    console.log(data)
    fetch("/item/registerCoupon", {
      method: "post",
      headers: {
        "X-CSRF-TOKEN": document.querySelector("#csrf").value,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    })
      .then((response) =>  {return response.text()})
      .then(data=>{
    	  console.log(data)
        if(data=="fail"){
        	console.log(data)
        	alert("쿠폰번호를 확인해주세요.")
        }else if(data=="already"){
        	console.log(data)
        	alert("이미 등록이 완료된 쿠폰입니다.")
        }else if(data=="needLogin"){
        	console.log(data)
        	alert("로그인이 필요합니다.")
        }else{
        	alert(data+"円 쿠폰이 등록되었습니다.")
        	window.location.href = "/"
        }
      })
      
  }
});
   
</script>
</html>