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


<style>
    table {
        width: 80%;
        border-collapse: collapse;
    }

    table, th, td {
        border: 0.5px ;
    }

    td {
        text-align: center;
    }
</style>
<body>
	<strong><security:authorize access="isAuthenticated()"><security:authentication property="principal.username"/></security:authorize></strong> 님
	<a href="/">홈으로</a>
	<ul>
		
		<c:if test="${pageContext.request.isUserInRole('ROLE_ADMIN')}">
    		<li><a href="/item/create">상품등록</a></li>
		</c:if>
		
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
	
	<strong>상품 목록</strong> 
	<form method="post" action="/item/search">
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<select name=type>
			<option  value="itemName">상품명</option>
		</select> 
		<input type="text" placeholder="검색어" name="keyword">
		<button type="submit">검색</button>
	</form>


	<table>
	    <c:forEach items="${list}" var="dto" varStatus="status">
	        <c:if test="${status.index % 3 == 0}">
	            <tr>
	        </c:if>
	        <td>
	          	<a href="/item/read?ino=${dto.ino}"><img style="width: 225px; height: 225px;" src="/item/display?fileName=${dto.imagePath}"></a><br>
	            <a href="/item/read?ino=${dto.ino} ">${dto.itemName}<br></a>
	            <fmt:formatNumber value="${dto.price}" pattern="###,###円"/><br>
	            ${dto.username}<br>
	            <fmt:formatDate value="${dto.regDate}" pattern="yyyy.MM.dd" /><br>
	            <button data-ino="${dto.ino}" type="button" class="likeBtn">♡</button>
	            갯수: <span class="likeCount" data-ino="${dto.ino}">20</span>
	           
	            <form action="/item/delete" method="post">
	                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	                <input type="hidden" name="ino" value="${dto.ino}">
	                <c:if test="${pageContext.request.isUserInRole('ROLE_ADMIN')}">
	                    <button type="submit" id="deleteItem">상품삭제</button>
	                </c:if>
	            </form>
	        </td>
	        <c:if test="${status.index % 3 == 2 || status.last}">
	            </tr>
	        </c:if>
	           
	    </c:forEach>
	</table>
	
		<c:forEach begin='${pageDTO.startPage }' end='${pageDTO.endPage }' var='idx'>
		<span ${cri.page==idx?'active':'' }">
			<a href="list?page=${idx }&amount=6">${idx }</a>
		</span>
		</c:forEach>
		
	
	<input hidden="" id="nowLogin" value="<security:authorize access="isAuthenticated()"><security:authentication property="principal.username"/></security:authorize>">
</body>

<script src="../resources/list.js"/></script>
</html>