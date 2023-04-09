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

    private var chatClient = OpenAISwift(authToken: "your api key")

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
                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding(.trailing)
            }
            .padding(4)
            .navigationTitle("Chat")
        }
    }

    func sendMessage() {
        if inputText.isEmpty { return }

        chatHistory.append(Message(text: inputText, isUserMessage: true))

        chatClient.sendCompletion(with: inputText, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    let output = model.choices?.first?.text ?? ""
                    chatHistory.append(Message(text: output, isUserMessage: false))
                    self.inputText = ""
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        })
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
