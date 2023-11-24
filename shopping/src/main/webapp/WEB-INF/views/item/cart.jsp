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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
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
	<div>장바구니 페이지</div>
	<a href="/">홈으로</a>
	 <table border="1" style="color:#444;">
		<thead>
			<tr>
				<th></th>
				<th>품명</th>
				<th>가격</th>
				<th>갯수</th>
				<th>합계</th>
				<th>선택</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${cartList}" var="dto">
				<tr>
					<th><img style="width: 125px; height: 125px;" src="/item/display?fileName=${dto.imagePath}"></th>
					<td>${dto.itemName }</td>
					<td><fmt:formatNumber value="${dto.price}" pattern="###,###円"/></td>
					<td>
						<input hidden="" class="price" value="${dto.price}">
						<input hidden="" class="tax" value="${dto.tax}">
						<input class = "amount" value="${dto.amount }" type="number"></td>
					<td>
				        <span class="sumPrice">
				            <fmt:formatNumber value="${ (dto.price+(dto.price * dto.tax/100)) * dto.amount }" pattern="###,###円 (税込)"/>(${dto.tax}%)
				        </span>
				    </td>
					<td>
					  <input hidden="" class="totalPrice" value=${ (dto.price+(dto.price * dto.tax/100)) * dto.amount }>
					  <input type="checkbox" name="selectedItems" value="${dto.ino},${dto.amount}" data-ino="${dto.ino}">
					</td>
					<td><button data-cno="${dto.cno}" class="deleteCartBtn">삭제</button></td>
				</tr>
			 </c:forEach>
			 	<tr>
			 		<td>총 액</td>
			 		<td></td>
			 		<td></td>
			 		<td></td>
			 		<td></td>
			 		<td id="totalPrice"></td>
			 	</tr>
		</tbody>
	</table>
	
	<!-- 주문 모달창 -->
	<button type="button" class="btn btn-primary" id="modalBtn" data-bs-toggle="modal" data-bs-target="#exampleModal" style="display: none">
	  주문하기
	</button>
	
	<!-- Modal -->
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel">주문확인</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	      	<select id="couponSelect">
	      		<option value="none">쿠폰선택</option>
		      		 <c:forEach var="coupon" items="${list}">
			      		 <c:choose>
							<c:when test="${coupon.status eq 0}">
						        <option value="${coupon.couponNo}"  data-value="${coupon.couponVal}">${coupon.couponVal}円</option>
							</c:when>
							<c:otherwise>
							</c:otherwise>
					 </c:choose>
			    </c:forEach>
	      	</select>
	      	<div><a href="/item/registerCoupon">쿠폰등록하기</a></div>
			<div id="modalTotalPrice">주문총액 : <span></span></div>
			
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" id="cancelModal" data-bs-dismiss="modal">취소</button>
			<form action="/item/order" method="post" id="orderForm">
				<input hidden="" id="username" name="username" value="<security:authentication property="principal.username"/>">
			 	<input type="hidden" name="selectedItems" id="selectedItems">
			 	<input type="hidden" name="${_csrf.parameterName }" id="csrf"value="${_csrf.token }"/>
			 	<input hidden="" name="couponNo" id="couponNol">
	        	<button id="orderBtn" type="button" class="btn btn-primary">주문하기</button>
			</form>
	      </div>
	    </div>
	  </div>
	</div>
	
	
</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
<script src="../resources/cart.js"/></script>
</html>