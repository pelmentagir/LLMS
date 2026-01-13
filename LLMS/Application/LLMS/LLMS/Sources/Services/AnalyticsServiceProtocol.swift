//
//  AnalyticsServiceProtocol.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation
import OpenRouter

protocol AnalyticsServiceProtocol {
    func logModelSelection(modelName: String, displayName: String)
    func logMessageSent(modelName: String, messageLength: Int, messageCount: Int)
    func logMessageReceived(modelName: String, responseLength: Int, responseTime: TimeInterval)
    func logMessageError(modelName: String, error: Error)
    func logEvent(_ eventName: String, parameters: [String: Any]?)
    func setUserProperty(_ value: String?, forName property: String)
}
