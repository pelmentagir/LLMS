//
//  MarkdownText.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/10/26.
//

import SwiftUI

struct MarkdownText: View {
    let markdown: String
    let isUserMessage: Bool
    
    var body: some View {
        if let attributedString = try? AttributedString(
            markdown: markdown,
            options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) {
            Text(attributedString)
        } else {
            Text(markdown)
        }
    }
}
