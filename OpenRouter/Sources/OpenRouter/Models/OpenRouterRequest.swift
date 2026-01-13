//
//  OpenRouterRequest.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

public struct OpenRouterRequest: Codable {
    public let messages: [OpenRouterMessage]
    public let model: String
    public let provider: Provider?
    public let stream: Bool
    
    public struct Provider: Codable {
        public let zdr: Bool?
        public let sort: String?
        
        public init(zdr: Bool? = nil, sort: String? = nil) {
            self.zdr = zdr
            self.sort = sort
        }
    }
    
    public init(messages: [OpenRouterMessage], model: String, provider: Provider? = nil, stream: Bool) {
        self.messages = messages
        self.model = model
        self.provider = provider
        self.stream = stream
    }
}
