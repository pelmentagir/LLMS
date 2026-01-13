//
//  OpenRouterManagerProtocol.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation
import OpenRouter

protocol OpenRouterManagerProtocol {
    func sendStreamingRequest(
        messages: [OpenRouterMessage],
        model: String,
        provider: OpenRouterRequest.Provider
    ) async throws -> AsyncThrowingStream<String, Error>
}

final class OpenRouterManagerAdapter: OpenRouterManagerProtocol {
    private let openRouterManager: OpenRouterManager
    
    init(openRouterManager: OpenRouterManager) {
        self.openRouterManager = openRouterManager
    }
    
    func sendStreamingRequest(
        messages: [OpenRouterMessage],
        model: String,
        provider: OpenRouterRequest.Provider
    ) async throws -> AsyncThrowingStream<String, Error> {
        try await openRouterManager.sendStreamingRequest(
            messages: messages,
            model: model,
            provider: provider
        )
    }
}
