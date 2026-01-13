//
//  OpenRouterResponse.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

public struct OpenRouterResponse: Codable {
    public let choices: [ResponseChoice]?
    
    public struct ResponseChoice: Codable {
        public let message: ResponseMessage?
        
        public struct ResponseMessage: Codable {
            public let content: String?
        }
    }
}
