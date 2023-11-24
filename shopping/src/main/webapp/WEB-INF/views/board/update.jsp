<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>상세조회 ${totalCnt}</div>
	<a href="http://localhost:8080/board/update">글 수정</a>
	<a href="http://localhost:8080/board/delete">글 삭제</a>
	<a href="http://localhost:8080/board/list" >게시글 목록</a>
	<div>${list} 리스트임</div> 
	
	<table >
	<thead>
		<tr>
			<th>번호</th>
			<th>작성자</th>
			<th>제목</th>
			<th>내용</th>
			<th>수정일</th>
		</tr>
	</thead>
	<tbody>
			<tr>
				<form id="form" method="post" action="/board/update?bno=${dto.bno }">
				    <input type="hidden" name="bno" value="${dto.bno}">
					<th name="bno">${dto.bno}</th>
					<td name="username">${dto.username }</td>
					<td ><input name="title" type="text" value="${dto.title }"></td>
					<td><textarea  name="content" id="content">${dto.content }</textarea></td>
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
					<td><button type="submit" id="update">수정</button></td>
				</form>
			</tr>
	</tbody>
</table>
</body>
<script>
document.querySelector('#update').addEventListener('click', function (e) {

	var content = document.querySelector('#content').value;

    
    if (content.includes('@')||content.includes('!')||content.includes('#')||content.includes('$')||content=="") {
        alert("내용이 공란이거나 특수문자가 포함되어있음");
        e.preventDefault();
    }
});
</script>
</html>