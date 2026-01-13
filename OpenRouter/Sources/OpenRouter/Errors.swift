//
//  Errors.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

public enum OpenRouterError: Error, LocalizedError {
    
    case invalidResponse
    case httpError(statusCode: Int)
    case parsingError
    case invalidURL
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .parsingError:
            return "Failed to parse response"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
