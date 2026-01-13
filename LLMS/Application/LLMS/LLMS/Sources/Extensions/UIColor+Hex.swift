//
//  UIColor+Hex.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/10/26.
//

import UIKit

extension UIColor {

    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let length = hexSanitized.count
        
        switch length {
        case 6: // RRGGBB
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: 1.0
            )
        case 8: // RRGGBBAA
            self.init(
                red: CGFloat((rgb & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgb & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgb & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgb & 0x000000FF) / 255.0
            )
        default:
            return nil
        }
    }
    
    func toHex(includeAlpha: Bool = false) -> String? {
        guard let components = cgColor.components else {
            return nil
        }
        
        let r = components[0]
        let g = components.count > 1 ? components[1] : 0
        let b = components.count > 2 ? components[2] : 0
        let a = components.count > 3 ? components[3] : 1
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X",
                         Int(r * 255),
                         Int(g * 255),
                         Int(b * 255),
                         Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X",
                         Int(r * 255),
                         Int(g * 255),
                         Int(b * 255))
        }
    }
}
