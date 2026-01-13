//
//  ViewAssembly.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation
import SwiftUI
import Swinject

final class ViewAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ChatView.self) { (resolver, apiKey: String) in
            let viewModel = resolver.resolve(ChatViewModel.self, argument: apiKey)!
            return ChatView(viewModel: viewModel)
        }
    }
}
