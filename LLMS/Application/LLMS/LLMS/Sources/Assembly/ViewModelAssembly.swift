//
//  ViewModelAssembly.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation
import Swinject
import OpenRouter
import BDUI

final class ViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ChatViewModel.self) { (resolver, apiKey: String) in
            let analyticsService = resolver.resolve(AnalyticsService.self)!
            let bduiService = resolver.resolve(BDUIService.self)!
            let openRouterManager = resolver.resolve(OpenRouterManager.self, argument: apiKey)!
            let openRouterManagerAdapter = OpenRouterManagerAdapter(openRouterManager: openRouterManager)
            
            return MainActor.assumeIsolated {
                ChatViewModel(
                    apiKey: apiKey,
                    openRouterManager: openRouterManagerAdapter,
                    analyticsService: analyticsService,
                    bduiService: bduiService
                )
            }
        }
    }
}
