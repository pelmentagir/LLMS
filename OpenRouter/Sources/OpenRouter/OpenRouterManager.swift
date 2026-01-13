//
//  OpenRouterManager.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation
import OSLog

public final class OpenRouterManager {
    
    private let apiKey: String
    private let requestBuilder: OpenRouterRequestBuilder
    private let responseParser: OpenRouterResponseParser
    private let responseValidator: HTTPResponseValidator
    private let streamProcessor: StreamProcessor
    private let logger: Logger
    private let lock = NSLock()
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        let logger = Logger(subsystem: "com.llms.openrouter", category: "OpenRouterManager")
        self.logger = logger
        
        let requestBuilder = OpenRouterRequestBuilder(apiKey: apiKey)
        self.requestBuilder = requestBuilder
         
        let responseParser = OpenRouterResponseParser(logger: logger)
        self.responseParser = responseParser
        
        let responseValidator = HTTPResponseValidator(logger: logger)
        self.responseValidator = responseValidator
        
        let streamProcessor = StreamProcessor(parser: responseParser, logger: logger)
        self.streamProcessor = streamProcessor
    }
    
    public func sendStreamingRequest(
        messages: [OpenRouterMessage],
        model: String,
        provider: OpenRouterRequest.Provider?
    ) async throws -> AsyncThrowingStream<String, Error> {
        logger.info("Starting streaming request with model: \(model)")
        
        let requestBody = OpenRouterRequest(
            messages: messages,
            model: model,
            provider: provider,
            stream: true
        )
        
        let request = try requestBuilder.buildRequest(body: requestBody)
        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        
        try responseValidator.validate(response)
        
        logger.debug("Streaming request validated, starting stream processing")
        return streamProcessor.processStream(bytes: bytes)
    }
    
    public func sendRequest(
        messages: [OpenRouterMessage],
        model: String = OpenRouterConstants.DefaultModels.nonStreaming,
        provider: OpenRouterRequest.Provider? = nil
    ) async throws -> String {
        logger.info("Starting non-streaming request with model: \(model)")
        
        let requestBody = OpenRouterRequest(
            messages: messages,
            model: model,
            provider: provider,
            stream: false
        )
        
        let request = try requestBuilder.buildRequest(body: requestBody)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try responseValidator.validate(response)
        
        logger.debug("Non-streaming request validated, parsing response")
        return try responseParser.parseNonStreamingResponse(from: data)
    }
}
