<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>게시글 작성 페이지</div>
	<a href="http://localhost:8080/board/list">목록으로</a>
	<form method="post" action="/board/create" id="form">
		<input type="text" name="title" placeholder="제목"/>
		<textarea id="content" name="content" placeholder="내용"></textarea>
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		
		
		<input type="hidden" value="${dto.username }" name="username"/>
		<button type="submit" id="create">작성</button>
	</form>
</body>
<script>
document.querySelector("#create").addEventListener("click",(e)=>{
    e.preventDefault();
    fetch("/board/createChk?content="+document.querySelector("#content").value)
    .then((response)=>{if(!response.ok){
      alert("공란이 있거나 특수문자가 들어있어 작성불가")
    }else{
     document.querySelector("#form").submit()
    }  
    })
  })
</script>
</html>