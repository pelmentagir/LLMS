//
//  DIContainer.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/11/26.
//

import Foundation
import Swinject

final class DIContainer {
    
    static let shared = DIContainer()
    
    let container: Container
    private let assembler: Assembler
    
    private init() {
        container = Container()
        let assemblies: [Assembly] = [
            ServiceAssembly(),
            ViewModelAssembly(),
            ViewAssembly()
        ]
        assembler = Assembler(assemblies, container: container)
    }
}
