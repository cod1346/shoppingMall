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
	<div>주문 페이지</div>
	<a href="/">홈으로</a>
	<button id="exportExcel">엑셀로 내보내기</button>
	
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
	            <th>주문상태</th>
	            <th>총액</th>
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
	                    <td>${dto.amount}<span>개${dto.couponVal }</span></td>
	                    <td>
	                        <input hidden="" class="totalP" value="${(dto.price + (dto.price * dto.tax / 100)) * dto.amount}">
	                        <fmt:formatNumber value="${((dto.price + (dto.price * dto.tax / 100)) * dto.amount)}" pattern="###,###円 (税込)"/>)(${dto.tax}%)
	                    </td>
	                    <td><fmt:formatDate value="${dto.orderDate}" pattern="yyyy.MM.dd" /><br></td>
	                    <td>
						   <c:choose>
						    	<c:when test="${not empty dto.delivery}">
							        ${dto.delivery}
							    </c:when>
 						        <c:otherwise>
									계좌번호 : 00-000-000000 입금대기중	
 						        </c:otherwise>
						   </c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${loop.index eq 0}">
							        <fmt:formatNumber value="${dto.totalPrice-dto.couponVal}" pattern="###,###円 (税込)"/><br><c:choose><c:when test="${couponVal != 0}">(쿠폰 -${dto.couponVal}円적용)</c:when></c:choose>
							       </c:when>
							       <c:otherwise>
							       </c:otherwise>
							  </c:choose>
						</td>
	                </tr>
	            </c:forEach>
	        </c:forEach>
	    </tbody>
	</table>

	<table id="table" border="1" style="color: #444; display: none;">
	    <thead>
	        <tr>
	            <th>주문번호</th>
	            <th>품명</th>
	            <th>가격</th>
	            <th>갯수</th>
	            <th>합계</th>
	            <th>주문일자</th>
	            <th>주문상태</th>
	            <th>총액</th>
	        </tr>
	    </thead>
	    <tbody>
	        <c:forEach items="${groupedOrders}" var="groupEntry">
	            <c:forEach items="${groupEntry.value}" var="dto" varStatus="loop">
	                <tr>
	                    <c:if test="${loop.index eq 0}">
	                        <th rowspan="${groupEntry.value.size()}">${dto.orderNo}</th>
	                    </c:if>
	                    <td>${dto.itemName}</td>
	                    <td><fmt:formatNumber value="${dto.price}" pattern="###,###円"/></td>
	                    <td>${dto.amount}<span>개</span></td>
	                    <td>
	                        <input hidden="" class="totalP" value="${(dto.price + (dto.price * dto.tax / 100)) * dto.amount}">
	                        <fmt:formatNumber value="${(dto.price + (dto.price * dto.tax / 100)) * dto.amount}" pattern="###,###円 (税込)"/>)(${dto.tax}%)
	                    </td>
	                    <td><fmt:formatDate value="${dto.orderDate}" pattern="yyyy.MM.dd" /><br></td>
	                    <td>
						   <c:choose>
						    	<c:when test="${not empty dto.delivery}">
							        ${dto.delivery}
							    </c:when>
 						        <c:otherwise>
									계좌번호 : 00-000-000000 입금대기중	
 						        </c:otherwise>
						   </c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${loop.index eq 0}">
							        <fmt:formatNumber value="${dto.totalPrice-dto.couponVal}" pattern="###,###円 (税込)"/>(${dto.tax}%)
							       </c:when>
							       <c:otherwise>
							       </c:otherwise>
							  </c:choose>
						</td>
	                </tr>
	            </c:forEach>
	        </c:forEach>
	    </tbody>
	</table>

</body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.1/xlsx.full.min.js"></script>
<script src="https://cdn.rawgit.com/rainabba/jquery-table2excel/1.1.0/dist/jquery.table2excel.min.js"></script>
<script>
//엑셀
document.querySelector('#exportExcel').addEventListener('click',()=>{
    const table = document.querySelector('#table');
    if (table) {
        const wb = XLSX.utils.table_to_book(table, { sheet: "Sheet 1" });

        const ws = wb.Sheets["Sheet 1"];
        const dateFormat = XLSX.SSF.get_table()[14]; 
        const dateColumns = [5];

        dateColumns.forEach((colIndex) => {
            for (const cellAddress in ws) {
                if (cellAddress.includes(`!${XLSX.utils.encode_col(colIndex)}`)) {
                    ws[cellAddress].t = "d";
                    ws[cellAddress].z = dateFormat;
                }
            }
        });

        XLSX.writeFile(wb, "주문목록.xlsx");
    }
});

</script>
</html>