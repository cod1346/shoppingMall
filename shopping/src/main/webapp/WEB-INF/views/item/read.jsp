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
</head>
<body>
	<div>상품 상세 페이지</div>
	<a href="/">홈으로</a>
	<div>${dto.itemName }</div>
	<div>価格: <fmt:formatNumber value="${dto.price}" pattern="###,###円"/> </div>
	 <c:forEach items="${list}" var="dto">
		<div><img style="width: 150px; height: 150px;" src="/item/display?fileName=${dto.uploadPath}"></div>
	 </c:forEach>
		<div></div>
		<table border="1" style="color:#444;">
			<tbody>
				<tr>
					<td colspan="2" style="background-color:#f1f1f1;">商品詳細</td>
				</tr>
				<tr>
					<td width="130">品番</td>
					<td width="360">${dto.ino }</td>
				</tr>
				<tr>
					<td width="130">品名</td>
					<td width="360">${dto.itemName}</td>
				</tr>
				<tr>
					<td width="130">価格</td>
					<td width="360"><fmt:formatNumber value="${dto.price+(dto.price * dto.tax/100)}" pattern="###,###円 (税込)"/>(${dto.tax}%)</td>
				</tr>
				<tr>
					<td width="130">産地</td>
					<td width="360">${dto.origin }</td>
				</tr>
				<tr>
					<td width="130">素材</td>
					<td width="360">${dto.ingredient}</td>
				</tr>
				<tr>
					<td width="130">性別</td>
					<td width="360">${dto.gender}</td>
				</tr>
				<tr>
					<td width="130">免税</td>
					<td width="360">${dto.tax}%</td>
				</tr>
				<tr>
					<td width="130">配送</td>
					<td width="360">${dto.delivery}</td>
				</tr>
				<tr>
					<td width="130">問い合わせ番号</td>
					<td width="360">${dto.tel}</td>
				</tr>
			</tbody>
		</table>
		
		<table border="1" style="color:#444;">
			<tbody>
				<tr>
					<td colspan="2" style="background-color:#f1f1f1;">${dto.itemName }とは</td>
				</tr>
				<tr>
					<td width="465">${dto.point }</td>
					
				</tr>
			</tbody>
		</table>
	<security:authorize access="isAuthenticated()">
		<form action="/item/insertCart">
			<p>갯수<input name="amount" type="number" size="3" value="1" min="1" step="1">
			<input hidden="" name="ino" value=${dto.ino} >
			<input hidden="" name="itemName" value=${dto.itemName} >
			<input hidden="" name="price" value=${dto.price} >
			<input hidden="" name="imagePath" value=${dto.imagePath}>
			<input hidden="" name="tax" value=${dto.tax}>
			<input hidden="" name="username" value="<security:authentication property="principal.username"/>">
			<button type="submit">장바구니 추 가</button>
		</form>
	</security:authorize>
	<security:authorize access="!isAuthenticated()">
		<div>로그인필요</div>
	</security:authorize>
</body>
<script>

</script>
</html>