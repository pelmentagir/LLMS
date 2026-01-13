//
//  ResponseParser.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation
import OSLog

struct OpenRouterResponseParser {
    
    private let logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func parseStreamChunk(from line: String) throws -> String? {
        guard line.hasPrefix(OpenRouterConstants.sseDataPrefix) else {
            return nil
        }
        
        let jsonString = String(line.dropFirst(OpenRouterConstants.sseDataPrefix.count))
        let trimmedString = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedString == OpenRouterConstants.sseDoneMarker {
            logger.debug("Received stream completion marker")
            return nil
        }
        
        guard let jsonData = trimmedString.data(using: .utf8) else {
            logger.warning("Failed to convert JSON string to data")
            return nil
        }
        
        do {
            let chunk = try JSONDecoder().decode(OpenRouterStreamChunk.self, from: jsonData)
            return chunk.choices?.first?.delta?.content
        } catch {
            logger.error("Failed to decode stream chunk: \(error.localizedDescription)")
            throw OpenRouterError.parsingError
        }
    }
    
    func parseNonStreamingResponse(from data: Data) throws -> String {
        do {
            let response = try JSONDecoder().decode(OpenRouterResponse.self, from: data)
            guard let content = response.choices?.first?.message?.content else {
                logger.error("Response does not contain content")
                throw OpenRouterError.parsingError
            }
            return content
        } catch {
            logger.error("Failed to parse non-streaming response: \(error.localizedDescription)")
            throw OpenRouterError.parsingError
        }
    }
}
