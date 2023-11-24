<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form id="loginForm" method="post" action="/member/cancelDelete">
		<label>아이디<input type="text" name="username" id="username"></label>
		<label>패스워드 <input type="password" name="password"></label>
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<div>${error }</div>
		<button type="submit" >회원탈퇴 취소</button>
	</form>
	<div><a href="/">홈으로</a></div>
	
</body>
</html>
