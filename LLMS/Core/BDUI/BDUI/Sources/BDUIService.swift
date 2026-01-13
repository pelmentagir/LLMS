//
//  BDUIService.swift
//  BDUI
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation
import FirebaseFirestore

@MainActor
public final class BDUIService: BDUIServiceProtocol {
    
    public static let shared = BDUIService()
    
    private let db = Firestore.firestore()
    private let collectionName = "uiElements"
    private let documentId = "appIcon"
    
    // MARK: - Initialization
    
    private init() {}
    
    public func loadUIElement() async -> UIElementData {
        do {
            let document = try await db.collection(collectionName).document(documentId).getDocument()
            guard let data = document.data() else {
                return UIElementData.default
            }
            
            let iconName = data["iconName"] as? String ?? UIElementData.default.iconName
            let label = data["label"] as? String ?? UIElementData.default.label
            let colorHex = data["colorHex"] as? String ?? UIElementData.default.colorHex
            
            return UIElementData(
                iconName: iconName,
                label: label,
                colorHex: colorHex
            )
        } catch {
            return UIElementData.default
        }
    }
}
