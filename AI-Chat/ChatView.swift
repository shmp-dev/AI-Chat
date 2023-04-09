//
//  ChatView.swift
//  AI-Chat
//
//  Created by shumpei shimizu on 2023/04/09.
//

import SwiftUI
import OpenAISwift

struct Message: Hashable {
    let text: String
    let isUserMessage: Bool
}

struct ChatView: View {

    @State private var inputText = ""
    @State private var chatHistory: [Message] = []

    private var chatClient = OpenAISwift(authToken: "your API key")

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    ForEach(chatHistory, id: \.self) { message in
                        HStack {
                            if message.isUserMessage {
                                Spacer()
                                Text(message.text)
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .background(Color(red: 0.0, green: 0.0, blue: 0.6))
                                    .cornerRadius(8)
                            } else {
                                Text(message.text.replacingOccurrences(of: "\n\n", with: ""))
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .background(Color(red: 0.0, green: 0.4, blue: 0.0))
                                    .cornerRadius(8)
                                Spacer()
                            }
                        }
                        .padding(4)
                        .id(message)
                    }
                }
                .onChange(of: chatHistory) { _ in
                    withAnimation {
                        scrollView.scrollTo(chatHistory.last, anchor: .bottom)
                    }
                }
            }
            HStack {
                TextField("Type your message here...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: send) {
                    Text("Send")
                }
                .padding(.trailing)
            }
            .padding(4)
            .navigationTitle("Chat")
        }
    }
    
    func send() {
        Task {
            await sendMessage()
        }
    }

    // メッセージ送信
    func sendMessage() async {
        if inputText.isEmpty { return }

        // chatHistoryに、ユーザーのメッセージを追加
        chatHistory.append(Message(text: inputText, isUserMessage: true))
        self.inputText = ""

        // APIに質問を送
        do {
            // チャットメッセージを作成
            var chat: [ChatMessage] = [ChatMessage(role: .system, content: "あなたはとても優秀なアシスタントです。")]
            chatHistory.forEach { history in
                var role = ChatRole.assistant
                if (history.isUserMessage) {
                    role = ChatRole.user
                }
                chat.append(ChatMessage(role: role, content: history.text))
            }
             
            
            let result = try await chatClient.sendChat(with: chat)
            if let returnMessage = result.choices?[0].message.content {
                chatHistory.append(Message(text: returnMessage, isUserMessage: false))
            }
            // use result
        } catch {
            // ...
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
