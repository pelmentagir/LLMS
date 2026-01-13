//
//  ChatView.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/10/26.
//

import SwiftUI
import OpenRouter

struct ChatView: View {
    
    @StateObject private var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool
    
    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            Divider()
            
            messagesScrollView
            
            inputArea
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var headerView: some View {
        HStack {
            Image(systemName: viewModel.headerUIElement.iconName)
                .font(.headline)
                .foregroundColor(Color(UIColor(hex: viewModel.headerUIElement.colorHex) ?? .black))
            Text(viewModel.headerUIElement.label)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Menu {
                ForEach(AIModel.allCases) { model in
                    Button {
                        viewModel.selectedModel = model
                    } label: {
                        HStack {
                            Text(model.displayName)
                            if viewModel.selectedModel == model {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(viewModel.selectedModel.displayName)
                        .font(.subheadline)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .task {
            await viewModel.loadHeaderUIElement()
        }
    }
    
    private var messagesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                    
                    if viewModel.isLoading && viewModel.streamingMessageId == nil {
                        HStack {
                            ProgressView()
                                .padding(12)
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(18)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
            }
            .onChange(of: viewModel.messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.messages.last?.text) { _, _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    // MARK: - Input Area
    private var inputArea: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(alignment: .bottom, spacing: 8) {
                HStack {
                    TextField("Сообщение", text: $viewModel.userInput, axis: .vertical)
                        .textFieldStyle(.plain)
                        .lineLimit(1...6)
                        .focused($isInputFocused)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(20)
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(viewModel.userInput.isEmpty ? .gray : .blue)
                }
                .disabled(viewModel.userInput.isEmpty || viewModel.isLoading)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
        }
    }
}
