//
//  OpenRouterStreamChunk.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

public struct OpenRouterStreamChunk: Codable {
    public let id: String?
    public let choices: [Choice]?
    
    public struct Choice: Codable {
        public let delta: Delta?
        
        public struct Delta: Codable {
            public let content: String?
            public let role: String?
        }
    }
}
