//
//  OpenRouterMessage.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

public struct OpenRouterMessage: Codable {
    public let role: String
    public let content: String
    
    public init(role: String, content: String) {
        self.role = role
        self.content = content
    }
}
