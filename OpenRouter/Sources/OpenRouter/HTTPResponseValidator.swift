//
//  HTTPResponseValidator.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation
import OSLog

struct HTTPResponseValidator {
    
    private let logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Response is not HTTPURLResponse")
            throw OpenRouterError.invalidResponse
        }
        
        guard httpResponse.statusCode == OpenRouterConstants.successStatusCode else {
            logger.error("HTTP error with status code: \(httpResponse.statusCode)")
            throw OpenRouterError.httpError(statusCode: httpResponse.statusCode)
        }
        
        logger.debug("HTTP response validated successfully")
    }
}
