//
//  AnalyticsService.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation
import FirebaseAnalytics
import OpenRouter

final class AnalyticsService: AnalyticsServiceProtocol {

    static let shared = AnalyticsService()
    
    // MARK: - Initialization
    
    private init() {}
    
    func logModelSelection(modelName: String, displayName: String) {
        Analytics.logEvent("model_selected", parameters: [
            "model_name": modelName,
            "model_display_name": displayName
        ])
    }
    
    func logMessageSent(modelName: String, messageLength: Int, messageCount: Int) {
        Analytics.logEvent("message_sent", parameters: [
            "model_name": modelName,
            "message_length": messageLength,
            "message_count": messageCount
        ])
    }
    
    func logMessageReceived(modelName: String, responseLength: Int, responseTime: TimeInterval) {
        Analytics.logEvent("message_received", parameters: [
            "model_name": modelName,
            "response_length": responseLength,
            "response_time_seconds": responseTime
        ])
    }
    
    func logMessageError(modelName: String, error: Error) {
        Analytics.logEvent("message_error", parameters: [
            "model_name": modelName,
            "error_description": error.localizedDescription,
            "error_type": String(describing: type(of: error))
        ])
    }
    
    func logEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(eventName, parameters: parameters)
    }

    func setUserProperty(_ value: String?, forName property: String) {
        Analytics.setUserProperty(value, forName: property)
    }
}
