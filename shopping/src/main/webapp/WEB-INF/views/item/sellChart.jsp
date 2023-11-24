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
	<div>매출현황 페이지</div>
	<a href="/">홈으로</a>
	<input id="date" type="date">
	<input type="hidden" name="${_csrf.parameterName }" id="csrf"value="${_csrf.token }"/>
	<table>
			<thead>
				<tr>
					<th width="100px">상품명</th>
					<th>판매갯수</th>
				</tr>
		    </thead>
		    <tbody id="sellListTb">
		    </tbody>
	</table>
	<h2 id="totalPrice">매출액 : 0円</h2>
	<div>이날의 메 모 : <span id="diaryMemo"></span></div>
	<textarea hidden="" id="updateMemoIpt"></textarea>
	<button id="updateMemoBtn">수정</button>
	<button id="updateMemoSubmitBtn" hidden="">수정완료</button>
</body>
<script>
document.querySelector("#date").addEventListener("change",()=>{
	  const selectedDate = document.querySelector("#date").value; // 선택된 날짜 값
	  
	  document.querySelector("#updateMemoIpt").setAttribute("hidden","");
	  document.querySelector("#updateMemoSubmitBtn").setAttribute("hidden", "");
	  document.querySelector("#updateMemoBtn").removeAttribute("hidden");
	  

	  fetch("/item/sellChart", {
	      method: "POST",
	      headers: {
	        "Content-Type": "application/json", 
	    "X-CSRF-TOKEN": document.querySelector("#csrf").value,
	  },
	  body:  JSON.stringify(selectedDate),
	  })
	 .then((response) => {
	          if (response.ok) {
	              return response.json();
	          }
      })
	  .then((data) => {
		  	  
	          console.log( data);
	          document.querySelector("#diaryMemo").innerHTML = ""
	          document.querySelector("#sellListTb").innerHTML = ""
		  	  if(data.diary){
			  	  if(new Date(data.diary.regDate).toISOString().split('T')[0]==document.querySelector("#date").value){
			  		  console.log("같음")
			  	  }
		  		document.querySelector("#diaryMemo").innerHTML = data.diary.content
		  	  }

	          const groupedByIno = {};

	          data.list.forEach(obj => {
	        	  if (!groupedByIno[obj.ino]) {
	        	        groupedByIno[obj.ino] = {
	        	        	itemName : "",
	        	            count: 0,
	        	            totalAmount: 0
	        	        };
	        	    }
  	        	    groupedByIno[obj.ino].itemName=obj.itemName;
	        	    groupedByIno[obj.ino].count++;
	        	    groupedByIno[obj.ino].totalAmount += obj.amount;
	        	});
	            console.log(groupedByIno)
	            const sellListTb = document.getElementById('sellListTb');

				for (const [ino, values] of Object.entries(groupedByIno)) {
					
				    sellListTb.innerHTML+="<tr><td>"+values.itemName+"</td><td>"+values.totalAmount+"</td></tr>"
				}
				var totalPrice = 0;
				data.totalList.forEach(obj=>{
					totalPrice+=obj.totalPrice
					console.log("총액 : "+totalPrice)
				})
				document.querySelector("#totalPrice").innerHTML="매출액 : "+totalPrice+"円"
				
	   })
})
// 메모 수정
document.querySelector("#updateMemoBtn").addEventListener("click",()=>{
	  const diaryMemo =document.querySelector("#diaryMemo").innerHTML
	  
	  document.querySelector("#updateMemoIpt").value=diaryMemo
	  document.querySelector("#updateMemoIpt").removeAttribute("hidden");
	  document.querySelector("#updateMemoSubmitBtn").removeAttribute("hidden");
	  document.querySelector("#updateMemoBtn").setAttribute("hidden", "");

})
document.querySelector("#updateMemoSubmitBtn").addEventListener("click",()=>{
	  const selectedDate = document.querySelector("#date").value; // 선택된 날짜 값
	  document.querySelector("#updateMemoIpt").setAttribute("hidden","");
	  document.querySelector("#updateMemoSubmitBtn").setAttribute("hidden", "");
	  document.querySelector("#updateMemoBtn").removeAttribute("hidden");
	  
	  
	  console.log(selectedDate)
	  const data = {
	      regDate: selectedDate,
	      content : document.querySelector("#updateMemoIpt").value 
	  };
	  
	  fetch("/item/updateDiaryMemo", {
	      method: "POST",
	      headers: {
	        "Content-Type": "application/json", 
	    "X-CSRF-TOKEN": document.querySelector("#csrf").value,
	  },
	  body:  JSON.stringify(data),
	  })
	 .then((response) => {
	          if (response.ok) {
	              alert("수정 성공")
	              document.querySelector("#diaryMemo").innerHTML = document.querySelector("#updateMemoIpt").value
	          }else{
	              alert("수정 실패")
	          }
      })
	  
})
</script>
</html>