<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form method="post" action="/member/register">
		<label>아이디<input id="username" type="text" name="username" ></label>
		<button type="button" id="idChk">중복 아이디 체크</button>
		<label>패스워드 <input type="password" name="password"></label>
		<label>이름 <input type="text" name="name"></label>
		<label>주소 <input type="text" name="address"></label>
		<label>전화번호 <input type="tel" name="tel"></label>
		<label>이메일 <input type="email" name="email"></label>
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<div>${error }</div>
		<button type="submit">회원가입</button>
	</form>
	
	<script>
	document.querySelector("#idChk").addEventListener("click",()=>{
		  fetch("/member/idChk?username="+document.querySelector("#username").value).then((response)=>{
		    if(!response.ok||document.querySelector("#username").value==""){
		  	  alert("중복아이디")
		    }
		    else{
		      alert("사용가능 아이디")
		  }})
		})

	</script>
</body>
</html>