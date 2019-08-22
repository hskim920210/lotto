<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로또 번호 생성</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
	function getResult() {
		$("#result").text('');
		var minNum = $("#minNum").val();
		var maxNum = $("#maxNum").val();
		var numOfNum = $("#numOfNum").val();
		var numOfLotto = $("#numOfLotto").val();
		
		if(minNum > maxNum){
			alert("당첨 번호의 최솟값은 최댓값보다 클 수 없습니다.\n입력하신 최솟값은 '"+minNum+"'이고, \n입력하신 최댓값은 '"+maxNum+"'입니다.");
			return;
		} else {
			if(checkNull(minNum, maxNum, numOfNum, numOfLotto) == 'F') {
				alert("입력 사항은 모두 필수입니다.");
				return;
			};
			var lottoObject = new Object();
			lottoObject.minNum = minNum;
			lottoObject.maxNum = maxNum;
			lottoObject.numOfNum = numOfNum;
			lottoObject.numOfLotto = numOfLotto;
			var lottoJsonObj = JSON.stringify(lottoObject);
			$.ajax({
				url : "<%= request.getContextPath() %>/result",
				type : "post",
				data : lottoJsonObj,
				dataType : "json",
				contentType : "application/json",
				success : function (data) {
					alert("아래 화면에서 결과를 확인하세요.");
					var resultTag = '<table class="table table-bordered" style="text-align: center; width: 50%;">';
					for(var i = 0 ; i < data.length ; i++) {
						var resNum = (data[i].toString()).split(',');
						resultTag += "<tr><td>"+(i+1)+"번째</td>"
						for(var j = 0 ; j < resNum.length ; j++){
							resultTag += "<td>"+resNum[j]+"</td>";
						}
						resultTag += "</tr>";
					}
					resultTag += "</table>";
					$("#result").append(resultTag);
				},
				error : function(data) {
					alert("실패");
				}
			});
		}
	};
	
	function checkNull(a, b, c, d) {
		if(a == ''){
			return "F";
		} else if (b == ''){
			return "F";
		} else if (c == ''){
			return "F";
		} else if (d == ''){
			return "F";
		}
		return "S";
	};
</script>
</head>
<body>

<h3 align="center">아래 형식을 작성하세요.</h3>
<p align="center">(로또 생성을 기본값 (5개 구입)으로 셋팅되어있습니다.)</p>
<%-- <p><a href="<%= request.getContextPath() %>/chat" target="_blank">채팅하기</a> --%>
<p><a href="<%= request.getContextPath() %>/chat">채팅하기</a>
<div align="center">
<table class="table table-bordered" style="text-align: center; width: 50%">
	<tr>
		<td>당첨 번호의 최소값</td>
		<td><input style="text-align: center;" type="number" id="minNum" name="minNum" placeholder="최소 번호" value="1" required="required"/></td>
	</tr>
	<tr>
		<td>당첨 번호의 최댓값</td>
		<td><input style="text-align: center;" type="number" id="maxNum" name="maxNum" placeholder="최대 번호" value="45" required="required"/></td>
	</tr>
	<tr>
		<td>생성할 번호의 갯수</td>
		<td><input style="text-align: center;" type="number" id="numOfNum" name="numOfNum" placeholder="몇개의 번호" value="6" required="required"/></td>
	</tr>
	<tr>
		<td>구매할 복권의 갯수</td>
		<td><input style="text-align: center;" type="number" id="numOfLotto" name="numOfNum" placeholder="몇개의  복권" value="5" required="required"/></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><button id="resultBtn" onclick="getResult();">생성하기</button></td>
	</tr>
</table>
</div>

<h3 align="center">번호 생성 결과</h3>
<div align="center" id="result" style="font-size: 20px;">

</div>

<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
</body>
</html>