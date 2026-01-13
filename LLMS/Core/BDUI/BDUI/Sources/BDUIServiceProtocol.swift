//
//  BDUIServiceProtocol.swift
//  BDUI
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation

@MainActor
public protocol BDUIServiceProtocol {
    
    func loadUIElement() async -> UIElementData
}
