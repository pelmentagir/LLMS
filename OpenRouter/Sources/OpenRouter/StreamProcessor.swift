//
//  StreamProcessor.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation
import OSLog

struct StreamProcessor {
    
    private let parser: OpenRouterResponseParser
    private let logger: Logger
    
    init(parser: OpenRouterResponseParser, logger: Logger) {
        self.parser = parser
        self.logger = logger
    }
    
    func processStream(
        bytes: URLSession.AsyncBytes
    ) -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    logger.debug("Starting stream processing")
                    var chunkCount = 0
                    
                    for try await line in bytes.lines {
                        if let content = try parser.parseStreamChunk(from: line) {
                            continuation.yield(content)
                            chunkCount += 1
                        }
                    }
                    
                    logger.debug("Stream processing completed. Total chunks: \(chunkCount)")
                    continuation.finish()
                } catch {
                    logger.error("Stream processing error: \(error.localizedDescription)")
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
