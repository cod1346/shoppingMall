document.querySelector("#orderBtn").addEventListener("click", (e) => {
    e.preventDefault();

    var selectedItems = [];

    // 선택된 상품의 ino 값을 수집
    var checkboxes = document.querySelectorAll("input[type=checkbox]:checked");
    for (var i = 0; i < checkboxes.length; i++) {
        var data = checkboxes[i].value.split(",");
        var ino = data[0];
        var amount = data[1];
        var username = document.querySelector("#username").value
        var couponNo = document.querySelector("#couponSelect").value
        selectedItems.push({ ino: ino, amount: amount,username:username,couponNo });
    }

    fetch("/item/order", {
        method: "POST",
        headers: {
        	 "Content-Type": "application/json", 
		  "X-CSRF-TOKEN": document.querySelector("#csrf").value,
		},
        body:  JSON.stringify(selectedItems),
    })
        .then((response) => {
            if (response.ok) {
                alert("주문성공")
                window.location.href = "/item/order?username="+document.querySelector("#username").value; 
            }
            throw new Error("Network response was not ok.");
        })
});
	
	// 페이지 로드 시 총액 초기화
var totalPrice = 0;

	// 체크박스 상태 변경 시 이벤트 리스너
var checkboxes = document.querySelectorAll('input[type="checkbox"]');
checkboxes.forEach((checkbox)=>{
	checkbox.addEventListener('change',(e)=> {
	    var isChecked = checkbox.checked;
	    var priceInput = e.target.closest("td").querySelector(".totalPrice");
	    var price = parseFloat(priceInput.value);
	    var roundedPrice = Math.floor(price);
	    // 체크 상태에 따라 총액 조절
        console.log(price)
        if (isChecked) {
            totalPrice += roundedPrice
            // 클릭된 체크박스가 속한 <tr> 요소 선택
            const amountValue = e.target.closest('tr').querySelector('.amount').value;
            const inoValue = checkbox.getAttribute("data-ino");
            checkbox.value = inoValue+","+amountValue;
            console.log(checkbox)
        } else {
            totalPrice -= roundedPrice
        }
        // 총액 업데이트
        document.getElementById('totalPrice').textContent = totalPrice.toLocaleString() + "円 (税込)";
	});
});
	//수량 번경시 총액 업데이트
document.querySelectorAll('.amount').forEach(input => {
    input.addEventListener("input", (e) => {
        const price = parseFloat(e.target.closest('td').querySelector('.price').value);
        const tax = parseFloat(e.target.closest('td').querySelector('.tax').value);
        console.log(tax)
        const amountValue = e.target.value;
        console.log(price)
        console.log(amountValue)
        console.log((price+(price * tax/100)) * amountValue)
        const sumPrice = e.target.closest('tr').querySelector('.sumPrice');
        const sum = Math.floor((price+(price * tax/100)) * amountValue);
        sumPrice.textContent = sum.toLocaleString()+ "円 (税込)";
        console.log(e.target.closest("tr").querySelector(".totalPrice"))
        console.log(sum)
        e.target.closest("tr").querySelector(".totalPrice").value=sum;
        document.getElementById('totalPrice').textContent = totalPrice.toLocaleString() + "円 (税込)";
    });
});
//(price+(price * tax/100)) * amountValue
document.querySelectorAll(".deleteCartBtn").forEach(btn=>{
    btn.addEventListener("click",(e)=>{
        var cno=e.target.getAttribute("data-cno")
        fetch("/item/deleteCart?cno="+cno, { 
            method: "POST",
            headers: {
                "X-CSRF-TOKEN": document.querySelector("#csrf").value,
            },
        })
        .then(
            alert("삭제성공"),
            location.reload()
            )
    })
})

document.querySelectorAll(".deliveryBtn").forEach((btn) => {
    btn.addEventListener("click",(e)=>{
        e.preventDefault();
        console.log(e.target.closest("td"))
        if(e.target.closest("td").querySelector(".deliveryOpt").value="택배사 선택"){
            alert("택배사를 선택해주세요")
        }else{
            alert("선택됨")
        }
        e.target.closest("td").querySelector(".deliveryForm").submit();
        
    })
}); 

var checkboxes = document.querySelectorAll('input[name="selectedItems"]');

checkboxes.forEach(function (checkbox) {
    checkbox.addEventListener('change', function () {
        var selectedItems = document.querySelectorAll('input[name="selectedItems"]:checked');
        var username = document.querySelector("#username").value;
        
        if (selectedItems.length > 0) {
            document.querySelector("#modalTotalPrice").innerHTML =
                "주문총액 : " + document.querySelector("#totalPrice").innerHTML;
            document.querySelector("#modalBtn").style.display = 'block';
        } else {
            document.querySelector("#modalBtn").style.display = 'none';
        }
    });
});

// 쿠폰 선택 상자를 가져옵니다.
var couponSelect = document.getElementById('couponSelect');

// 주문 총액을 표시하는 텍스트 엘리먼트를 가져옵니다.

// 쿠폰 선택 상자의 변경 이벤트에 대한 리스너를 등록합니다.
couponSelect.addEventListener('change', function (e) {
    // 선택된 옵션의 데이터 속성에서 쿠폰 가치를 가져옵니다.
    var selectedCouponValue = couponSelect.options[couponSelect.selectedIndex].dataset.value;
    if(e.target.value=="none"){
        document.querySelector("#modalTotalPrice").innerHTML =
                    "주문총액 : " + document.querySelector("#totalPrice").innerHTML;
    }else{
        console.log(parseFloat(document.querySelector("#totalPrice").innerHTML.replace(/,/g, '')))
        var finalPrice = parseFloat(document.querySelector("#totalPrice").innerHTML.replace(/,/g, ''))-parseFloat(selectedCouponValue)
        if(finalPrice<0){
            finalPrice=0
        }
        document.querySelector("#modalTotalPrice").innerHTML =
        "주문총액 : " + document.querySelector("#totalPrice").innerHTML.replace(/[^1\d,]/g, '')+"円-"+parseFloat(selectedCouponValue).toLocaleString()+"円 = "+finalPrice.toLocaleString()+"円 (税込)";
    }

});