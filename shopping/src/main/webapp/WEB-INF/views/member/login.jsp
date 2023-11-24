<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form id="loginForm" method="post" action="/login">
		<label>아이디<input type="text" name="username" id="username"></label>
		<label>패스워드 <input type="password" name="password"></label>
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<div>${error }</div>
		<button type="submit" id="loginBtn">로그인</button>
	</form>
	<div><a href="/member/register">회원가입</a></div>
	<div><a href="/member/cancelDelete">회원탈퇴 취소</a></div>
	<div><a href="/">홈으로</a></div>
	
<script>
document.querySelector("#loginBtn").addEventListener("click",(e)=>{
	  e.preventDefault()
	  fetch("/member/loginDeleteCheck?username="+document.querySelector("#username").value)
	  .then((response)=>{if(!response.ok){
	    alert("탈퇴처리된 회원")
	  }else{
		  document.querySelector("#loginForm").submit()
	  }
	})
	})
</script>
</body>
</html>
