//
//  LLMSApp.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/10/26.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct LLMSApp: App {
    private let viewFactory = ViewFactory()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if let chatView = viewFactory.makeChatView(apiKey: APIKey.openRouter) {
                chatView
            } else {
                Text("Ошибка инициализации")
            }
        }
    }
}
