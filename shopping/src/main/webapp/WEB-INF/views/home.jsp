<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
        #chat-container {
		    position: fixed;
		    bottom: 70px;
		    right: 25px;
		    width: 315px;
		    height: 400px;
		    flex-direction: column;
		    border: 1px solid #ccc;
		    overflow: scroll;
		}
        .user-messages {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
            display: flex;
            flex-direction: column-reverse;
            border: thin;
        }
        .bot-message {
            border-top: 1px solid #ccc;
            padding: 10px;
            margin-top: 5px;
            background-color: #e6e6e6;
            text-align: right;
        }
        #user-input {
            position: fixed;
		    bottom: 20px;
		    right: 20px;
 
        }
        #user-input input {
        	width : 245px;
            flex: 1;
            padding: 10px;
            outline: none;
        }
        #user-input button {
            border: none;
            background-color: #1e88e5;
            color: white;
            padding: 10px 15px;
        }
</style>
</head>
<body>
<ul>
	<li><a href="http://localhost:8080/board/list">게시판으로</a></li>
	
	<c:if test="${pageContext.request.isUserInRole('ROLE_ADMIN')}">
    	<li><a href="/item/create">상품등록</a></li>
	</c:if>
	<li><a href="/item/list?page=1&amount=6">상품목록</a></li>
	<security:authorize access="isAuthenticated()">
		<li><a href="/item/order?username=<security:authentication property="principal.username"/>">주문목록</a></li>
	</security:authorize>
	<security:authorize access="isAuthenticated()">
		<li>
			<form action="/item/cart" id="cartForm" method="post">
				<input hidden="" name="username" value="<security:authentication property="principal.username"/>">
				<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
				<a href="/" id="cartBtn">내 장바구니</a>
			</form>
		</li>
		<li><a href="/item/registerCoupon">쿠폰등록</a></li>
		<c:if test="${pageContext.request.isUserInRole('ROLE_ADMIN')}">
			<div>----관리자 기능----</div>
	    	<li><a href="/item/adminorder">주문페이지(관리자)</a></li>
	    	<li><a href="/item/sendCoupon">쿠폰 이메일 발송</a></li>
			<li><a href="/item/sellChart">매출현황</a></li>
		</c:if>
	</security:authorize>
</ul>
		
	<security:authorize access="isAuthenticated()"><security:authentication property="principal.username"/></security:authorize>

	<security:authorize access="isAuthenticated()">
		<a href="/member/update?username=<security:authentication property="principal.username"/>">비밀번호변경</a>
		<a href="/member/delete?username=<security:authentication property="principal.username"/>">회원탈퇴</a>
		<form method="post" action="/logout">
			<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
			<button type="submit">로그아웃</button>
		</form>
	</security:authorize>
	<security:authorize access="!isAuthenticated()">
		<a href="/member/login">로그인</a>
	</security:authorize>
	
	<div id="chat-container">
		<div id="chat-message">
        </div>
        <div id="user-input">
            <input type="text" placeholder="메시지를 입력하세요..." id="question"/>
            <button id="chatBtn">전송</button>
        </div>
    </div>
	
</body>
<script>
	if(document.querySelector("#cartBtn")){
		const cartForm=document.querySelector("#cartForm")
		document.querySelector("#cartBtn").addEventListener("click",(e)=>{
		  e.preventDefault()
		  cartForm.submit()
		})
	}
//챗봇
var chatMessage = document.querySelector("#chat-message")
var question = document.querySelector("#question")

document.querySelector("#chatBtn").addEventListener("click",()=>{
	console.log(question)
  if(question.value==""){
    alert("질문을 작성해주세요.")
  }else{
    chatMessage.innerHTML=chatMessage.innerHTML+"<div class='user-messages'>"+question.value+"</div>"
    fetch("/chatBot?question="+question.value)
    .then((response) => {
    	if (!response.ok) {
            chatMessage.innerHTML = chatMessage.innerHTML + "<div class='user-messages' style='text-align: right;'>다시 질문해주세요.</div>";
        }
        return response.json();
    })
    .then((data) => {
        console.log(data);
        chatMessage.innerHTML = chatMessage.innerHTML + "<div class='user-messages' style='text-align: right;'>" + data.answer + "</div>";
    })
    question.value=""
  }
})
</script>
</html>