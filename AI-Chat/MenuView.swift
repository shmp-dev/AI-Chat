//
//  MenuView.swift
//  AI-Chat
//
//  Created by shumpei shimizu on 2023/04/09.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ChatView()) {
                    Text("Chat").padding()
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
