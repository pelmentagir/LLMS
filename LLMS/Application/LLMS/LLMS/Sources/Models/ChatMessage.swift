//
//  ChatMessage.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    
    let id: String
    var text: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: String = UUID().uuidString, text: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id && lhs.text == rhs.text
    }
}
