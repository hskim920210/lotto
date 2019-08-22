<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅</title>
<%--<script type="text/javascript" src="<%= request.getContextPath() %>/resources/js/jquery-3.2.1.min.js"></script> --%>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
</head>
<script type="text/javascript">
	function enterkeyGroup() {
	    if (window.event.keyCode == 13) {
	    	// 엔터키가 눌렸을 때 실행할 내용
			sendGroupMessage();
	    }
	}

	// 웹 소켓 변수
	var wsocket_Group = null;
	
	$(document).ready(function() {
		$('#connGroupBtn').click(function() { sockGroupConnect(); });
		$('#sendGroupBtn').click(function() { sendGroupMessage(); });
		$('#closeGroupBtn').click(function() { sockGroupClose(); });
	});
	
	function sockGroupConnect() {
		var nickname_Group = $("#nicknameGroup").val().trim();
		if( wsocket_Group != null ){
			alert("웹소켓이 not null입니다. 이미 연결되었습니다.");
			return;
		};
		if( nickname_Group.length == 0 || nickname_Group.length > 10 ) {
			alert("닉네임은 1자 이상 10자 이하입니다.");	
			return;
		};
		wsocket_Group = 
			new WebSocket("ws://172.30.1.42:8080/lott/chat/chat_group");
		wsocket_Group.onmessage = onGroupMessage;
		wsocket_Group.onclose = onGroupClose;

		$("#nicknameGroup").attr('readonly', 'readonly');
		$("#sendGroupBtn").css('visibility', 'visible');
		$("#connGroupBtn").css('visibility', 'hidden');
		$("#closeGroupBtn").css('visibility', 'visible');
		var message_Group = $("#chatArea_Group").html("<p align='center' style='color: silver'>서버와 연결되었습니다.</p>");	
		$("#chatArea_Group").scrollTop($(document).height());
	}

	
	function sockGroupClose() {
		if( wsocket_Group == null )
			return;
		$("#sendGroupBtn").css('visibility', 'hidden');
		$("#connGroupBtn").css('visibility', 'visible');
		$("#closeGroupBtn").css('visibility', 'hidden');
		wsocket_Group.close();
		wsocket_Group = null;
		var message_Group = $("#chatArea_Group").html("<p align='center' style='color: silver'>서버와 연결이 해제되었습니다..</p>");	
		$("#chatArea_Group").scrollTop($(document).height());

	}
	
	function sendGroupMessage() {
		if( wsocket_Group == null ) {
			alert("웹 소켓이 연결되지 않았습니다.\n")
			return;
		}
		
		// var msg_Group = sender_Group + " : " + $("#messageGroup").val() + "\n";
		var msg_Group = "<p align='right' style='color: darkblue; font-size: 20px;'>" + $("#messageGroup").val() + "</p>";
		var viewMsg_Group = $("#chatArea_Group").html();
		wsocket_Group.send($("#messageGroup").val());
		viewMsg_Group += msg_Group;
		$("#chatArea_Group").html(viewMsg_Group);	
		$("#chatArea_Group").scrollTop($(document).height());
		$("#messageGroup").val('');
	}
	
	function onGroupMessage(evt) {
		var data_Group = evt.data;
		/*
		if(data_Group == '대화시작'){
			$("#sendGroupBtn").css('visibility', 'visible');
		}
		if(data_Group == '대화종료'){
			$("#sendGroupBtn").css('visibility', 'hidden');
		}
		*/
		var message_Group = $("#chatArea_Group").html()
		message_Group +="" + data_Group;
		$("#chatArea_Group").html(message_Group);	
		$("#chatArea_Group").scrollTop($(document).height());

	}
		
	function onGroupClose(evt) {
		var message_Group = $("#chatArea_Group").html()
		message_Group += "<p align='center' style='color: silver;'>--연결종료--</p>";
		$("#chatArea_Group").html(message_Group);	
		$("#chatArea_Group").scrollTop($(document).height());
		console.log(evt);
	}
</script>
<body>

<div align="center" style="width: 50%;">
<h3>채팅방</h3>

	<div class="text-center mt-2" style="overflow: auto; height: 500px; border: 1px solid; padding: 20px;" id="chatArea_Group" ></div>
	<div class="modal-footer">
		<div class="options text-center text-md-right mt-1"
			style="width: 90%;">
			닉네임 : <input type="text" id="nicknameGroup" name="nicknameGroup">
			<button type="button" id="connGroupBtn" name="connGroupBtn" style="visibility: visible;"
			class="btn btn-outline-info waves-effect ml-auto">연결</button>
			<button type="button" id="closeGroupBtn" name="closeGroupBtn" style="visibility: hidden;"
			class="btn btn-outline-info waves-effect ml-auto">연결해제</button>
			<textarea rows="4" id="messageGroup" name="messageGroup" onkeyup="enterkeyGroup();" style="resize: none; width: 100%;"></textarea>
		</div>
		<button type="button" id="sendGroupBtn" name="sendGroupBtn" style="visibility: hidden;"
			class="btn btn-outline-info waves-effect ml-auto">전송</button>
	</div>
</div>
</body>
</html>