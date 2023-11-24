<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>상세조회 ${totalCnt}</div>
	<strong><security:authorize access="isAuthenticated()"><security:authentication property="principal.username"/></security:authorize></strong> 님

	<ul>	

	<li> <button id="update">글 수정</button></li>
	<li> <button id="delete">글 삭제</button></li>
	
	<li><a href="http://localhost:8080/board/list" >목록으로</a></li>
	</ul>

	<table >
	<thead>
		<tr>
			<th>번호</th>
			<th>작성자</th>
			<th>제목</th>
			<th>작성일</th>
			<th>수정일</th>
		</tr>
	</thead>
	<tbody>
			<tr>
				<th id="bno">${dto.bno}</th>
				<td>${dto.username }</td>
				<td>${dto.title }</td>
				<td><fmt:formatDate value="${dto.regDate}" pattern="yyyy.MM.dd" /></td>
				<td><fmt:formatDate value="${dto.updateDate}" pattern="yyyy.MM.dd" /></td>
			</tr>
	</tbody>
</table>
<h2>
글 내용
</h2>
<textarea readonly>${dto.content }</textarea>


<h2>댓글</h2>
<table >
	<thead>
		<tr>
			<th>작성자</th>
			<th>내용</th>
			<th>작성일</th>
		</tr>
	</thead> 
		<c:forEach var="replyDto" items='${replyList }'>
	<tbody>
			<form action="/board/replyUpdate" method="post" class="reReplyForm">
				<tr data-rebno="${replyDto.reBno}">
					<td>${replyDto.username }</td>
					<td><textarea readonly="readonly" name='content' class='reConUpdate'>${replyDto.content}</textarea></td>
					<td><fmt:formatDate value="${replyDto.regDate}" pattern="yyyy.MM.dd" /></td>
					<td><button type="button" class="replyUpdate">댓글 수정</button></td>
					<td><button type="button" class="replyDelete">댓글삭제</button></td>
					 <td><button type="button" class="replyButton">답글</button></td>
					<td><button hidden="" type="submit" id="replyUpdateConfirm">댓글수정완료</button></td>
				</tr>
				<c:forEach var="reReplyDto" items="${reReplyList}">
			        <c:if test="${reReplyDto.reBno eq replyDto.reBno}">
			            <tr>
			                <td>${reReplyDto.username}</td>
							<td><textarea style="background-color: yellow;" readonly="readonly" class='reReConUpdate'>${reReplyDto.reContent}</textarea></td>
			                <td><fmt:formatDate value="${replyDto.regDate}" pattern="yyyy.MM.dd" /></td>
							<td><button type="button" class="reReplyUpdate">답글 수정</button></td>
							<td><button type="button" class="reReplyDelete">답글 삭제</button></td>
							<td><button type="button" hidden="" class="reReplyUpdateConfirm">답글수정완료</button></td>
							<td hidden="">${reReplyDto.reReBno}</td>
			            </tr>
			        </c:if>
			    </c:forEach>
				<tr data-rerebno="${replyDto.reBno}">
					<td></td>
					<td><textarea name="reContent" class='reContent' hidden></textarea></td>
					<td><button type="submit" class="reReplySubmit" hidden>답글작성</button></td>
				</tr>
				<input hidden id="nowlogin" name='username' value=
    			' <security:authorize access="isAuthenticated()"><security:authentication property="principal.username"/></security:authorize>'
	    		/>
				<input hidden name="bno" value='${dto.bno }'>
				<input type="hidden" class='reBno' name="reBno"  value='${replyDto.reBno }'>
				<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
			</form>
	</tbody>
		</c:forEach>
</table>

<!-- 댓글 -->
<form id="replyForm" method="post" action="/board/createReply">
	
	<textarea id="replyContent" name=content></textarea>
	
	<input hidden name="bno" value='${dto.bno }'>
	<input hidden id="nowlogin" name='username' value=
    ' <security:authorize access="isAuthenticated()"><security:authentication property="principal.username"/></security:authorize>'
    />
    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
    
	<button type="submit" id="replySubmit">댓글작성</button>
</form>

<form id="updateReReply" action="/board/reReplyUpdate" method="post">
	<input hidden name="reReBno" id="reReUpdateBno" >
	<input hidden name="reContent" id="reReUpdateContent" >
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
</form>


<script>
const username=document.querySelector("#nowlogin").value.trim()
const bno=document.querySelector("#bno").innerHTML
const replyForm = document.querySelector("#replyForm")
const reReplyForm = document.querySelector(".reReplyForm")
var replyContent = document.querySelector("#replyContent")
var reReplyContent = document.querySelector(".reContent")
//원본글 삭제
document.querySelector("#update").addEventListener("click",()=>{
  fetch("/board/updateIdChk?bno="+bno+"&username="+username).
  then((response)=>{if(!response.ok){
    alert("작성자만 수정 가능")
  }else{
    location.href="/board/update?bno="+bno
  }
  }).then().catch()
})
document.querySelector("#delete").addEventListener("click",()=>{
	fetch("/board/deleteIdChk?bno="+bno+"&username="+username).
  then((response)=>{if(!response.ok){
      alert("작성자만 삭제 가능")
    }else{
      alert("삭제 성공")
      location.href="/board/list"
    }
  }).then().catch()
})
//댓글 작성
document.querySelector("#replySubmit").addEventListener("click",(e)=>{
  e.preventDefault()
  if(username==" "){
    alert("로그인필요")
  }else if(replyContent.value==""){
    alert("댓글 내용 확인")
  }else{
    replyForm.submit();
  }
})
//댓글 수정,삭제
document.querySelectorAll(".replyUpdate").forEach((update) => {
  update.addEventListener("click", (e) => {
    var row = e.target.closest("tr");

	var reUsername = row.querySelector("td:nth-child(1)").textContent;
	
	console.log("아이디")
	console.log(reUsername)
	console.log(username)
    if (reUsername == username) {
      console.log("같음");
      row.querySelector(".reConUpdate").removeAttribute("readonly"); 
      row.querySelector("#replyUpdateConfirm").removeAttribute("hidden");
    } else {
      alert("본인의 댓글만 가능");
    }
  });
});
//댓글삭제
document.querySelectorAll(".replyDelete").forEach((reDelete) => {
	  reDelete.addEventListener("click", (e) => {
		    var row = e.target.closest("tr");
		    var reUsername = row.querySelector("td:nth-child(1)").textContent;
		    var reBno = row.getAttribute("data-rebno");
		    console.log(reBno)
		    if (reUsername == username) {
		      fetch("/board/replyDelete?reBno="+reBno).then(response=>{
		        if(response.ok){
		          alert("삭제성공")
		          location.href="/board/list"
		        }else{
		          alert("삭제실패")
		        }
		      }).then()
		    } else {
		      alert("본인의 댓글만 가능");
		    }
		  });
		});
	
//답글작성
document.querySelectorAll(".replyButton").forEach((button) => {
	  button.addEventListener("click", (e) => {
	    var row = e.target.closest("tbody");
		
	    row.querySelector(".reContent").removeAttribute("hidden");
	    row.querySelector(".reReplySubmit").removeAttribute("hidden");
	    })
	  });
document.querySelectorAll(".reReplySubmit").forEach((reReply) => {
    reReply.addEventListener("click", (e) => {
         e.preventDefault();
         var row = e.target.closest("tbody");
         var reContent = row.querySelector(".reContent");
         var rereForm = row.querySelector(".reReplyForm");

         if (username.trim() === "") {
             alert("로그인 필요");
         } else if (reContent.value.trim() === "") {
             alert("댓글 내용 확인");
         } else {
             rereForm.action = "/board/createReReply";
             rereForm.submit();
         }
    });
});
//답글수정

document.querySelectorAll(".reReplyUpdate").forEach((update) => {
	  update.addEventListener("click", (e) => {
	    var row = e.target.closest("tr");

		var reUsername = row.querySelector("td:nth-child(1)").textContent;
		var rereUsername = row.querySelector("td:nth-child(6)")
		
		var updateReReContent=row.querySelector(".reReConUpdate")
		var updateReReBno=row.querySelector("td:nth-child(7)").textContent;
		console.log(updateReReContent)
		console.log(updateReReBno)
		
	    if (reUsername.trim() == username) {
	      row.querySelector(".reReConUpdate").removeAttribute("readonly"); 
	      row.querySelector(".reReplyUpdateConfirm").removeAttribute("hidden");
	    } else {
	      alert("본인의 답글만 가능");
	    }
	    row.querySelector(".reReplyUpdateConfirm").addEventListener("click",()=>{
	       document.querySelector("#reReUpdateBno").value=updateReReBno
	       document.querySelector("#reReUpdateContent").value=updateReReContent.value
	       document.querySelector("#updateReReply").submit()
	    })
		
	  });
	});
 /* <td>${reReplyDto.username}</td>
							<td><textarea style="background-color: yellow;" readonly="readonly" class='reReConUpdate'>${reReplyDto.reContent}</textarea></td>
			                <td><fmt:formatDate value="${replyDto.regDate}" pattern="yyyy.MM.dd" /></td>
							<td><button type="button" class="reReplyUpdate">답글 수정</button></td>
							<td><button type="button" class="reReplyDelete">답글 삭제</button></td>
							<td hidden=""><button type="button" class="reReplyUpdateConfirm">댓글수정완료</button></td>
							<td hidden="">${reReplyDto.reReBno}</td> */
	//답글삭제
	document.querySelectorAll(".reReplyDelete").forEach((reDelete) => {
		  reDelete.addEventListener("click", (e) => {
			    var row = e.target.closest("tr");
			    var reUsername = row.querySelector("td:nth-child(1)").textContent;
			    var reBno = row.querySelector("td:nth-child(7)").textContent;
			    if (reUsername.trim() == username) {
			      fetch("/board/reReplyDelete?reReBno="+reBno).then(response=>{
			        if(response.ok){
			          alert("삭제성공")
			          location.href="/board/list"
			        }else{
			          alert("삭제실패")
			        }
			      }).then()
			    } else {
			      alert("본인의 답글만 가능");
			    }
			  });
			});
		
</script>
</body>
</html>