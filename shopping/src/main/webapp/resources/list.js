
window.addEventListener("load", function() {
    const likeCount = document.querySelectorAll(".likeCount");
    likeCount.forEach((likeCount)=> {
	    const ino = likeCount.getAttribute("data-ino");
	    let likeBtn=likeCount.closest("td").querySelector("button")
		// 현재 사용자 좋아요 유무
		fetch("/item/chkLike?ino="+ino+"&username="+document.querySelector("#nowLogin").value)
	          .then(response => response.text())
	          .then(data=>{
	        	  if(data==1){
		                likeBtn.textContent = "♥";
	                }else{
		                likeBtn.textContent = "♡" ;
	                }
	           })
	
	             
		// 좋아요 갯수        
	    fetch("/item/likeCount?ino=" + ino)
	            .then(response => response.text())
	          
				.then(data => {
	                // 좋아요 갯수 업데이트
	                likeCount.textContent = data;
	            })
	            .catch(error => {
	                console.error("좋아요 갯수 가져오기 실패: " + error);
	            });
	    });
});
document.querySelectorAll(".likeBtn").forEach((likeBtn)=> {
    likeBtn.addEventListener("click", (e) => {
    	if(e.target.textContent == "♥"){
    		console.log("좋아요삭제")
    		let ino = likeBtn.getAttribute("data-ino");
		    fetch("/item/deleteLike?ino=" + ino+"&username="+document.querySelector("#nowLogin").value)
		        .then(response=>{
			        if(response.ok){
			          e.target.textContent = "♡"
			          return fetch("/item/likeCount?ino=" + ino);
			        }else{
			          alert("실패")
			        }
			})
			.then(response => response.text())
            .then(data => {
                // 좋아요 갯수 업데이트
                console.log(data)
                e.target.closest("td").querySelector("span").textContent = data;
            })
    	}else if(document.querySelector("#nowLogin").value==""){
    		alert("로그인필요")
    	}else{
		    
		    let ino = likeBtn.getAttribute("data-ino");
		    fetch("/item/like?ino=" + ino+"&username="+document.querySelector("#nowLogin").value)
		        .then(response=>{
			        if(response.ok){

			        	e.target.textContent = "♥"
			          return fetch("/item/likeCount?ino=" + ino);
			        }else{
			          alert("실패")
			        }
			})
			.then(response => response.text())
            .then(data => {
                // 좋아요 갯수 업데이트
                console.log(data)
                e.target.closest("td").querySelector("span").textContent = data;
            })
	     }
    });
});
