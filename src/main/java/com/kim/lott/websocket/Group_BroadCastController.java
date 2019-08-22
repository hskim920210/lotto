package com.kim.lott.websocket;

import java.util.*;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class Group_BroadCastController extends TextWebSocketHandler {
	
	class WebSocketClientInfo {
		private WebSocketSession session;
		private ChatMember chatMember;
		public WebSocketClientInfo() {}
		public WebSocketClientInfo(WebSocketSession session, ChatMember chatMember) {
			this.session = session;
			this.chatMember = chatMember;
		}
		public WebSocketSession getSession() {
			return session;
		}
		public void setSession(WebSocketSession session) {
			this.session = session;
		}
		public ChatMember getChatMember() {
			return chatMember;
		}
		public void setChatMember(ChatMember chatMember) {
			this.chatMember = chatMember;
		}
	}
	
	class ChatMember {
		private String nickname;
		private boolean isConn;
		private String sessionId;
		public ChatMember() {}
		public ChatMember(String nickname, boolean isConn, String sessionId) {
			this.nickname = nickname;
			this.isConn = isConn;
			this.sessionId = sessionId;
		}
		public String getNickname() {
			return nickname;
		}
		public void setNickname(String nickname) {
			this.nickname = nickname;
		}
		public boolean isConn() {
			return isConn;
		}
		public void setConn(boolean isConn) {
			this.isConn = isConn;
		}
		public String getSessionId() {
			return sessionId;
		}
		public void setSessionId(String sessionId) {
			this.sessionId = sessionId;
		}
	}
	
	
	
	// 세션 아이디와 소켓정보를 저장하는 MAP 객체
	private LinkedHashMap<String, WebSocketClientInfo> sessionMap = new LinkedHashMap<>();
	// 채팅멤버를 저장하는 MAP 객체
	private ArrayList<WebSocketClientInfo> membersMap = new ArrayList<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("연결");
		//
		Map<String, Object> map = session.getAttributes();
		//
		String nickname = (session.getRemoteAddress()).toString(); // 잘 받아와짐
		System.out.printf("Group에 %s 접속\n", nickname);
		
		// ChatMember이 접속할 시 clientMap에서 isConn이 true인 상태로 membersMap 에 저장한다.
		ChatMember chatMember = new ChatMember(nickname, true, session.getId());
		WebSocketClientInfo wscInfo = new WebSocketClientInfo(session, chatMember);
		membersMap.add(wscInfo);
		sessionMap.put(chatMember.getSessionId(), wscInfo);
		
		if(membersMap.size() == 1) {
			session.sendMessage(new TextMessage("<p align='center' style='color: silver;'>현재 대화 상대가 없습니다.</p>"));
			map.put("totalMemberCount", membersMap.size());
		}
		for( WebSocketClientInfo wsci : membersMap ) {
			if((wsci.getChatMember().getNickname()).equals(nickname)) {
				continue;
			}
			wsci.getSession().sendMessage(new TextMessage(String.format("<p align='center' style='color: silver;'>%s 님이 접속했습니다.</p>", nickname)));
			wsci.getSession().sendMessage(new TextMessage(String.format("<p align='center' style='color: silver;'>현재 참여자 수 : %d</p>", membersMap.size())));
		}
		
	}
	
	// 웹 소켓 클라이언트가 서버측으로 데이터를 전송할 때 실행되는 메소드
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		String sender = sessionMap.get(session.getId()).getChatMember().getNickname();
		String msg = message.getPayload();
		System.out.println(msg);
		if( msg.equals("/몇명\n")) {
			System.out.println("if문 진입");
			session.sendMessage(new TextMessage(String.format("<p align='center' style='color: silver;'>현재 참여자 수 : %d</p>", membersMap.size())));
			return;
		}
		
		String fullMsg = String.format("<p align='left' style='color: black; font-size: 20px;'>%s : %s</p>", sender, msg);
		
		for( WebSocketClientInfo wsci : membersMap ) {
			if((wsci.getSession().getId()).equals(session.getId())) {
				continue;
			}
			wsci.getSession().sendMessage(new TextMessage(fullMsg));
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		String outMemberSessionId = session.getId();
		String outMemberNickName = sessionMap.get(outMemberSessionId).getChatMember().getNickname();
		String outMessage = String.format("<p align='center' style='color: silver;'>%s 님이 퇴장하셨습니다.</p>", outMemberNickName);
		
		membersMap.remove(sessionMap.get(outMemberSessionId));
		sessionMap.remove(outMemberSessionId);
		
		for( WebSocketClientInfo wsci : membersMap ) {
			wsci.getSession().sendMessage(new TextMessage(outMessage));
			wsci.getSession().sendMessage(new TextMessage(String.format("<p align='center' style='color: silver;'>현재 참여자 수 : %d</p>", membersMap.size())));

		}
	}
}