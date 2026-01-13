//
//  ServiceAssembly.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation
import Swinject
import OpenRouter
import BDUI

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnalyticsService.self) { _ in
            AnalyticsService.shared
        }.inObjectScope(.container)
        
        container.register(BDUIService.self) { _ in
            BDUIService.shared
        }.inObjectScope(.container)
        
        container.register(OpenRouterManager.self) { (resolver, apiKey: String) in
            OpenRouterManager(apiKey: apiKey)
        }
    }
}
