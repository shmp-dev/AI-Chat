//
//  AI_ChatApp.swift
//  AI-Chat
//
//  Created by shumpei shimizu on 2023/04/09.
//

import SwiftUI

@main
struct AI_ChatApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    // スプラッシュ画面が表示された後に、アプリのメイン画面に遷移する処理
                }
            }
        }
    }
}
