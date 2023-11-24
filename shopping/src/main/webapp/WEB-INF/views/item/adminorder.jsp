<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <style>
        table {
            border-collapse: collapse;
            width: 80%;
        }

        th, td {
            border: 1px solid #444;
            padding: 4px;
            text-align: left;
        }
    </style>
</head>
<body>
	<div>관리자 주문 페이지</div>
	<a href="/">홈으로</a>
	<!-- 엑셀 -->
	<div>
		<form method="post" action="/excel/uploadExcel" enctype="multipart/form-data">
		    <input type="file" name="uploadExcel" accept=".xls,.xlsx" />
		    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		    <button type="submit">업로드</button>
		</form>
	</div>
	<div>
		<form action="/excel/downloadExcel" method="get">
           <button type="submit">엑셀 주문양식 다운로드</button>
       </form>
    </div>
	
	<div>
		<table border="1" style="color:#444;">
		    <thead>
		        <tr>
		            <th>주문번호</th>
		            <th>상품</th>
		            <th>품명</th>
		            <th>가격</th>
		            <th>갯수</th>
		            <th>합계</th>
		            <th>주문일자</th>
		            <th>구매자</th>
		            <th>배송정보</th>
		        </tr>
		    </thead>
		    <tbody>
		        <c:forEach items="${groupedOrders}" var="groupEntry">
		            <c:forEach items="${groupEntry.value}" var="dto" varStatus="loop">
		                <tr>
		                    <c:if test="${loop.index eq 0}">
		                        <th rowspan="${groupEntry.value.size()}">${dto.orderNo}</th>
		                    </c:if>
		                    <td><img style="width: 125px; height: 125px;" src="/item/display?fileName=${dto.imagePath}"></td>
		                    <td>${dto.itemName}</td>
		                    <td><fmt:formatNumber value="${dto.price}" pattern="###,###円"/></td>
		                    <td>${dto.amount}<span>개</span></td>
		                    <td>
		                        <input hidden="" class="totalP" value="${(dto.price + (dto.price * dto.tax / 100)) * dto.amount}">
		                        <fmt:formatNumber value="${(dto.price + (dto.price * dto.tax / 100)) * dto.amount}" pattern="###,###円 (税込)"/>(${dto.tax}%)
		                    </td>
		                    <td><fmt:formatDate value="${dto.orderDate}" pattern="yyyy.MM.dd" /><br></td>
		                    <td>${dto.username }</td>
							<td>
							   <c:choose>
							    	<c:when test="${not empty dto.delivery}">
								        ${dto.delivery}
								    </c:when>
								    <c:when test="${loop.index eq 0}">
								        <div>
								            <form action="/item/deliveryUpdate" method="post" class="deliveryForm">
								                <select class="deliveryOpt" name="delivery">
								                    <option value="택배사 선택">택배사 선택</option>
								                    <option value="대한통운">대한통운</option>
								                    <option value="한진택배">한진택배</option>
								                </select>
								                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
								                <input type="hidden" name="orderNo" value="${dto.orderNo}" />
								                <button class="deliveryBtn">제출</button>
								            </form>
								        </div>
								       </c:when>
								       <c:otherwise>
								        <div>
								            <form action="/item/deliveryUpdate" method="post" class="deliveryForm" style="display: none;">
								                <select class="deliveryOpt">
								                    <option value="택배사 선택">택배사 선택</option>
								                    <option value="대한통운">대한통운</option>
								                    <option value="한진택배">한진택배</option>
								                </select>
								                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
								                <input type="hidden" name="orderNo" value="${dto.orderNo}" />
								                <button class="deliveryBtn">제 출</button>
								            </form>
								           </div>
								       </c:otherwise>
								</c:choose>
							</td>
		                </tr>
		            </c:forEach>
		        </c:forEach>
		    </tbody>
		</table>
    </div>
	
<script>
document.querySelectorAll(".div").forEach((div) => {
    var totalPrice = 0;
    var userKey = div.querySelector("h2").textContent.split(": ")[1];
    console.log(userKey)
    div.querySelectorAll(".price").forEach((sum, index) => {
        var price = parseFloat(sum.value);
        totalPrice += price * parseFloat(div.querySelectorAll(".amount")[index].value);
    });
    var formattedPrice = totalPrice.toLocaleString('ja-JP');
    document.querySelector(".totalPrice_" + userKey).textContent = formattedPrice + "円 (税込)";
}); 
//배송정보제출
document.querySelectorAll(".deliveryBtn").forEach((btn) => {
        btn.addEventListener("click",(e)=>{
            e.preventDefault();
            console.log(e.target.closest("div"))
            if(e.target.closest("div").querySelector(".deliveryOpt").value=="택배사 선택"){
                alert("택배사를 선택해주세요")
            }else{
                alert("설정완료")
            	e.target.closest("div").querySelector(".deliveryForm").submit();
            }
        })
    }); 
</script>
</html>