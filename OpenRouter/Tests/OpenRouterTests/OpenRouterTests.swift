//
//  OpenRouterTests.swift
//  OpenRouterTests
//
//  Created by Тагир Файрушин on 1/10/26.
//

import XCTest
@testable import OpenRouter

final class OpenRouterTests: XCTestCase {
    
    func testOpenRouterMessageInitialization() {
        let message = OpenRouterMessage(role: "user", content: "Hello")
        XCTAssertEqual(message.role, "user")
        XCTAssertEqual(message.content, "Hello")
    }
    
    func testOpenRouterRequestInitialization() {
        let message = OpenRouterMessage(role: "user", content: "Hello")
        let request = OpenRouterRequest(
            messages: [message],
            model: "test-model",
            stream: false
        )
        XCTAssertEqual(request.messages.count, 1)
        XCTAssertEqual(request.model, "test-model")
        XCTAssertFalse(request.stream)
    }
    
    func testAIModelDisplayName() {
        let model = AIModel.molmo
        XCTAssertEqual(model.displayName, "Molmo 2 8B")
        XCTAssertEqual(model.rawValue, "allenai/molmo-2-8b:free")
    }
    
    func testOpenRouterConstants() {
        XCTAssertEqual(OpenRouterConstants.baseURL, "https://openrouter.ai/api/v1/chat/completions")
        XCTAssertEqual(OpenRouterConstants.httpMethod, "POST")
        XCTAssertEqual(OpenRouterConstants.successStatusCode, 200)
    }
    
    func testOpenRouterError() {
        let error = OpenRouterError.invalidResponse
        XCTAssertNotNil(error.errorDescription)
        
        let httpError = OpenRouterError.httpError(statusCode: 404)
        XCTAssertNotNil(httpError.errorDescription)
    }
}
