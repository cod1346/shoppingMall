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
	<div>상품 등록 페이지</div>
	<a href="/">홈으로</a>
	<form method="post" action="/item/create" id="form">
		<div><input type="text" name="itemName" id="itemName" placeholder="상품명"/></div>
		<div><input type="text" name="price" id="price" placeholder="가격"/></div>
		<input type="hidden" id="csrf" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		
		<div>
			<label> 대표이미지
				<input type="file" id="uploadImage" name="uploadImage" accept="image/*" >
			</label>
		</div>
		<div class="uploadResult">
			<ul></ul>
		</div>

		<div>
			<label> 상세이미지
				<input type="file" multiple="multiple" id="uploadImages" name="uploadImages" accept="image/*">
			</label>
		</div>
		<div class="uploadResults">
			<ul></ul>
		</div>
		
		<div><input type="text" name="origin" placeholder="원산지"/></div>
		<div><input type="text" name="ingredient" placeholder="소재"/></div>
		<div><textarea name="point" placeholder="특징"></textarea></div>
		<div><input type="text" name="gender" placeholder="성별"/></div>
		<div>
			<input name="tax" style="width: 100px;" type="number" placeholder="세율"><span>%</span>
		</div>
		<select name="delivery">
			<option value="배송불가">배송불가
			<option value="1일소요">1일소요
			<option value="3일소요">3일소요
			<option value="5일소요">5일소요
		</select>
		<div><input type="text" name="tel" placeholder="문의번호"/></div>
		
		<input hidden name='username' value=
    			' <security:authorize access="isAuthenticated()"><security:authentication property="principal.username"/></security:authorize>'
	    		/>
		
		
		<button type="submit" id="create">상품등록</button>
	</form>
	
</body>
<script>
//대표이미지
document.querySelector("#uploadImage").addEventListener("change", () => {
	let targetFile=""
	const formData = new FormData();
	
	let inputFiles = document.querySelector("#uploadImage").files;
	console.log(inputFiles);
	
	let firstFile = inputFiles[0];
	formData.append("uploadImage", firstFile);
	
	console.log(formData);

	  fetch("/item/uploadImage", {
	    method: "post",
	    headers: {
	      "X-CSRF-TOKEN": document.querySelector("#csrf").value,
	    },
	    body: formData,
	  })
	    .then((response) => {
	      if (!response.ok) {
	        throw new Error("파일 업로드 실패");
	      }
	      return response.json();
	    })
	    .then((data) => {
	      console.log(data);
	      showUploadedFile(data);
	      document.querySelector(".uploadResult ul").insertAdjacentHTML("beforeend", showUploadedFile(data));
	    })
	    .catch((error) => console.log(error));
	  });
//상세이미지
document.querySelector("#uploadImages").addEventListener("change", () => {
	let targetFile=""
	const formData = new FormData();
	
	let inputFiles = document.querySelector("#uploadImages").files;
	console.log(inputFiles);
	
	for (let i = 0; i < inputFiles.length; i++) {
	    formData.append("uploadImages", inputFiles[i]);
	  }
	
	console.log(formData);

	  fetch("/item/uploadImages", {
	    method: "post",
	    headers: {
	      "X-CSRF-TOKEN": document.querySelector("#csrf").value,
	    },
	    body: formData,
	  })
	    .then((response) => {
	      if (!response.ok) {
	        throw new Error("파일 업로드 실패");
	      }
	      return response.json();
	    })
	    .then((data) => {
	      //showUploadedFile(data);
	      document.querySelector(".uploadResults ul").insertAdjacentHTML("beforeend", showUploadedFile(data));
	    })
	    .catch((error) => console.log(error));
	  });
function showUploadedFile(uploadResultArr) {
	let str = "";
	if (!Array.isArray(uploadResultArr)) {
	    uploadResultArr = [uploadResultArr];
	  }

	uploadResultArr.forEach((uploadResult) => {
		  
  let fileCallPath = encodeURIComponent(
    uploadResult.uploadPath + "\\" + uploadResult.uuid + "_" + uploadResult.imageName
	    );

  

  str += "<li data-path='" + uploadResult.uploadPath + "'data-uuid='" + uploadResult.uuid + "'";
  str += " data-filename='" + uploadResult.imageName + "'>";
  str +=
    "<div><img src='/item/display?fileName=" + fileCallPath + "'></div>";
  str += "<small>" + uploadResult.imageName + "</small> ";
	str +=
	  "<button type='button' data-file='" +
	  fileCallPath +
    "' class='deleteImage'> X </button>";
	str += "</li>";

	console.log("파일첨부 :  ", str);

	})
	return str;
	//document.querySelector(".uploadResult ul").insertAdjacentHTML("beforeend", str);
}
//파일삭제
document.querySelector(".uploadResult ul").addEventListener("click", (e) => {
  if (e.target.classList.contains("deleteImage")) {
    console.log("delete 클릭");
    targetFile = e.target.dataset.file;
    const formData1 = new FormData();
    formData1.append("deleteFile", targetFile);

    fetch("/item/deleteImage", {
      method: "post",
      headers: {
        "X-CSRF-TOKEN": document.querySelector("#csrf").value,
      },
      body: formData1,
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("파일 업로드 실패");
        }
        return response.text();
      })
      .then((data) => {
        console.log(data);
        const deletedLi = e.target.closest("li");
        if (deletedLi) {
          deletedLi.remove();
        }
        document.querySelector("#uploadImage").value = null; // 파일 입력 필드의 값을 null로 설정하여 초기화
      })
      .catch((error) => console.log(error));
  }
});
document.querySelector(".uploadResults ul").addEventListener("click", (e) => {
  if (e.target.classList.contains("deleteImage")) {
    console.log("delete 클릭");
    targetFile = e.target.dataset.file;
    const formData1 = new FormData();
    formData1.append("deleteFile", targetFile);

    fetch("/item/deleteImage", {
      method: "post",
      headers: {
        "X-CSRF-TOKEN": document.querySelector("#csrf").value,
      },
      body: formData1,
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("파일 업로드 실패");
        }
        return response.text();
      })
      .then((data) => {
        console.log(data);
        const deletedLi = e.target.closest("li");
        if (deletedLi) {
          deletedLi.remove();
        }
        document.querySelector("#uploadImage").value = null; // 파일 입력 필드의 값을 null로 설정하여 초기화
      })
      .catch((error) => console.log(error));
  }
});
	
const form = document.querySelector("#form");
form.addEventListener("submit", (e) => {
    e.preventDefault();
	if (isNaN(document.querySelector("#price").value)||document.querySelector("#price").value=="") {
	    alert("가격은 숫자만 입력가능");
	} else {
		const lis = document.querySelectorAll(".uploadResults ul li");
		
	    let str = "";
	    lis.forEach((element,idx) => {
	      let path = element.dataset.path;
	      let uuid = element.dataset.uuid;
	      let filename = element.dataset.filename;
	      //<input type = 'hidden' name='attachList[].' value=''/>
		  let fileCallPath = encodeURIComponent(
			element.dataset.path + "\\" + element.dataset.uuid + "_" + element.dataset.filename
	    	);
		  
//	      str+="<input type = 'hidden' name='imagesPathList["+idx+"].uploadPath'"+"value='"+path+"\\"+uuid+"_"+filename+"'/>";
	      str+="<input type = 'hidden' name='imagesPathList["+idx+"].uploadPath'"+"value='"+fileCallPath+"'/>";
	    });
		form.insertAdjacentHTML("beforeend",str);
		console.log(str)
		
		const li = document.querySelector(".uploadResult ul li");
	    let path1 = li.dataset.path;
	    let uuid1 = li.dataset.uuid;
	    let filename1 = li.dataset.filename;
	    let fileCallPath = encodeURIComponent(
	    		li.dataset.path + "\\" + li.dataset.uuid+ "_" + li.dataset.filename
		    	);
			  
      //<input type = 'hidden' name='attachList[].' value=''/>

	  //  form.insertAdjacentHTML("beforeend","<input type = 'hidden' name='imagePath'"+"value='"+path1+"\\"+uuid1+"_"+filename1+"'/>")
	    form.insertAdjacentHTML("beforeend","<input type = 'hidden' name='imagePath'"+"value='"+fileCallPath+"'/>")
	    console.log(form)
	    form.submit();
	}
})
</script>
</html>