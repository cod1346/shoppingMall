<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>전체 글 갯수 ${totalCnt}</div>
	<strong><security:authorize access="isAuthenticated()"><security:authentication property="principal.username"/></security:authorize></strong> 님
	<p>${dto.username }</p>
	<a href="/">홈으로</a>
	<ul>
		
	
		<security:authorize access="isAuthenticated()">
		<li><a href="/board/create" id="create">글 작성</a></li>
		</security:authorize>
		
		<security:authorize access="!isAuthenticated()">
		<li><a href="/member/login">로그인</a></li>
		</security:authorize>
		
	</ul>
	
	<security:authorize access="isAuthenticated()">
		<form method="post" action="/logout">
			<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
			<button type="submit">로그아웃</button>
		</form>
	</security:authorize>
	
	<strong>글 목록</strong> 
	<form method="post" action="/board/search">
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<select name=type>
			<option  value="title">제 목</option>
			<option  value="content">내용</option>
			<option  value="username">작성자</option>
		</select> 
		<input type="text" placeholder="검색어" name="keyword">
		<button type="submit">검색</button>
	</form>
	<table >
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>조회 수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="dto" items='${list }'>
				<tr>
					<th>${dto.bno}</th>
					<td><a href=/board/read?bno=${dto.bno}>${dto.title }</a></td>
					<td>${dto.username }</td>
					<td><fmt:formatDate value="${dto.regDate}" pattern="yyyy.MM.dd" /></td>
					<td>${dto.cnt }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>