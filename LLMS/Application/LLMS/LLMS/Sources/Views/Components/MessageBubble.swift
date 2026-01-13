//
//  MessageBubble.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/10/26.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if !message.text.isEmpty {
                    MarkdownText(markdown: message.text, isUserMessage: message.isUser)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(message.isUser ? Color.blue : Color(UIColor.systemGray5))
                        .foregroundColor(message.isUser ? .white : .primary)
                        .cornerRadius(18)
                        .textSelection(.enabled)
                } else {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(18)
                }
                
                if !message.text.isEmpty {
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 4)
                }
            }
            .frame(maxWidth: 260, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
