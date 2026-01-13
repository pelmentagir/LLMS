//
//  UIElementData.swift
//  BDUI
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation

public struct UIElementData: Equatable {
    
    public let iconName: String
    public let label: String
    public let colorHex: String
    
    public static let `default` = UIElementData(
        iconName: "star",
        label: "Star",
        colorHex: "#000000"
    )
    
    public init(iconName: String, label: String, colorHex: String) {
        self.iconName = iconName
        self.label = label
        self.colorHex = colorHex
    }
}
