//
//  RequestBuilder.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

struct OpenRouterRequestBuilder {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func buildRequest(
        body: OpenRouterRequest,
        url: String = OpenRouterConstants.baseURL
    ) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw OpenRouterError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = OpenRouterConstants.httpMethod
        request.setValue(
            "\(OpenRouterConstants.authorizationHeaderPrefix) \(apiKey)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            OpenRouterConstants.contentType,
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            "\(OpenRouterConstants.appName)/\(OpenRouterConstants.appVersion)",
            forHTTPHeaderField: OpenRouterConstants.refererHeader
        )
        request.setValue(
            OpenRouterConstants.appName,
            forHTTPHeaderField: OpenRouterConstants.titleHeader
        )
        request.httpBody = try JSONEncoder().encode(body)
        
        return request
    }
}
