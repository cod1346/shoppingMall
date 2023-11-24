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
	<form method="post" action="">
		<label>비밀번호 확인<input id="password" type="password" name="password" ></label>
		<input type="hidden" value=<security:authentication property="principal.username"/> id="username" name="username">
		
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<div>${error }</div>
		<button type="button" id="changePwd">회원 탈퇴</button>
	</form>
	
	<script>
	var password = document.querySelector("#password")
	console.log(document.querySelector("#username").value)
	document.querySelector("#changePwd").addEventListener("click",(e)=>{
	  e.preventDefault()
	    fetch(
	      "/member/deleteConfirm?username="+document.querySelector("#username").value
	    +"&password="+password.value
	    ).
	    then((response)=>{
	      if(!response.ok){
	        alert("패스워드 확인")
	      }
	      else{
	        alert("탈퇴완료")
	        location.href="/"
	    }})
	})
	</script>
</body>
</html>