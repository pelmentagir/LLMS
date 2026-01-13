//
//  Constants.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

public enum OpenRouterConstants {
    public static let baseURL = "https://openrouter.ai/api/v1/chat/completions"
    public static let httpMethod = "POST"
    public static let contentType = "application/json"
    public static let authorizationHeaderPrefix = "Bearer"
    public static let refererHeader = "HTTP-Referer"
    public static let titleHeader = "X-Title"
    public static let appName = "LLMS"
    public static let appVersion = "1.0"
    public static let sseDataPrefix = "data: "
    public static let sseDoneMarker = "[DONE]"
    public static let successStatusCode = 200
    
    public enum DefaultModels {
        public static let streaming = "allenai/molmo-2-8b:free"
        public static let nonStreaming = "anthropic/claude-3.5-sonnet"
    }
    
    public enum DefaultProvider {
        public static let zdr = true
        public static let sort = "price"
    }
}
