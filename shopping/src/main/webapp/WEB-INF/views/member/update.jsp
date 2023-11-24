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
	<form method="post" action="/member/register">
		<label>현재 비밀번호<input id="password" type="password" name="password" ></label>
		<label>새로운 패스워드 <input id="newPwd1" type="password" name="newPassword"></label>
		<label>새로운 패스워드 확인<input id="newPwd2" type="password" name="newPassword1"></label>
		<input type="hidden" value=<security:authentication property="principal.username"/> id="username" name="username">
		
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<div>${error }</div>
		<button type="button" id="changePwd">비밀번호  변경</button>
	</form>
	
	<script>
	var password = document.querySelector("#password")
	var newPwd1 = document.querySelector("#newPwd1")
	var newPwd2 = document.querySelector("#newPwd2")
	console.log(document.querySelector("#username").value)
	document.querySelector("#changePwd").addEventListener("click",(e)=>{
	  e.preventDefault()
	  console.log(newPwd1.value)
	  console.log(newPwd2.value)
	  if(newPwd1.value!=newPwd2.value){
	    alert('새로운 패스워드 확인')
	  }else if(newPwd1.value===newPwd2.value){
	    fetch(
	      "/member/changePwd?username="+document.querySelector("#username").value
	    +"&password="+password.value
	    +"&newPwd="+newPwd1.value
	    ).
	    then((response)=>{
	      if(!response.ok){
	        alert("기존 패스워드 확인")
	      }
	      else{
	        alert("변경 완료")
	        location.href="/"
	    }})

	  }
	})
	</script>
</body>
</html>