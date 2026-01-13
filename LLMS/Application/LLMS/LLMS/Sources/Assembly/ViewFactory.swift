//
//  ViewFactory.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation
import SwiftUI

final class ViewFactory {
    
    private let container = DIContainer.shared.container
    
    func makeChatView(apiKey: String) -> ChatView? {
        return container.resolve(ChatView.self, argument: apiKey)
    }
}
