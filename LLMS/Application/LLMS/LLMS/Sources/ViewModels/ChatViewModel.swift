//
//  ChatViewModel.swift
//  LLMS
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation
import OpenRouter
import Combine
import os.log
import BDUI

@MainActor
class ChatViewModel: ObservableObject {
    
    private let logger = Logger(subsystem: "dev.tuist.LLMS", category: "ChatViewModel")
    
    @Published var selectedModel: AIModel = .molmo {
        didSet {
            logger.info("Модель изменена: \(self.selectedModel.rawValue, privacy: .public) (\(self.selectedModel.displayName, privacy: .public))")
            analyticsService.logModelSelection(
                modelName: selectedModel.rawValue,
                displayName: selectedModel.displayName
            )
        }
    }
    
    @Published var userInput: String = ""
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var streamingMessageId: UUID? = nil
    @Published var headerUIElement: UIElementData = .default
    
    private let openRouterManager: OpenRouterManagerProtocol
    private let analyticsService: AnalyticsServiceProtocol
    private let bduiService: BDUIServiceProtocol
    
    // MARK: - Initialization
    
    init(
        apiKey: String,
        openRouterManager: OpenRouterManagerProtocol,
        analyticsService: AnalyticsServiceProtocol,
        bduiService: BDUIServiceProtocol
    ) {
        logger.info("ChatViewModel инициализирован")
        self.openRouterManager = openRouterManager
        self.analyticsService = analyticsService
        self.bduiService = bduiService
    }
    
    func sendMessage() {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            logger.debug("Попытка отправить пустое сообщение - пропущено")
            return
        }
        
        let messageText = userInput
        logger.info("Отправка сообщения: модель=\(self.selectedModel.rawValue, privacy: .public), длина=\(messageText.count, privacy: .public) символов")
        
        let userMessage = ChatMessage(text: messageText, isUser: true, timestamp: Date())
        messages.append(userMessage)
        userInput = ""
        isLoading = true
        streamingMessageId = nil
        
        analyticsService.logMessageSent(
            modelName: selectedModel.rawValue,
            messageLength: messageText.count,
            messageCount: messages.count
        )
        
        let newMessage = OpenRouterMessage(role: "user", content: messageText)
        
        Task {
            let startTime = Date()
            logger.debug("Начало запроса к OpenRouter")
            do {
                let stream = try await openRouterManager.sendStreamingRequest(
                    messages: [newMessage],
                    model: selectedModel.rawValue,
                    provider: OpenRouterRequest.Provider(
                        zdr: OpenRouterConstants.DefaultProvider.zdr,
                        sort: OpenRouterConstants.DefaultProvider.sort
                    )
                )
                
                logger.info("Поток ответа получен")
                let aiMessageId = UUID()
                let aiMessage = ChatMessage(text: "", isUser: false, timestamp: Date())
                messages.append(aiMessage)
                streamingMessageId = aiMessageId
                isLoading = false
                
                var fullResponse = ""
                var lastUpdateTime = Date()
                let updateInterval: TimeInterval = 0.05
                var chunkCount = 0
                
                for try await chunk in stream {
                    fullResponse += chunk
                    chunkCount += 1
                    
                    let now = Date()
                    if now.timeIntervalSince(lastUpdateTime) >= updateInterval {
                        updateAIMessage(text: fullResponse)
                        lastUpdateTime = now
                    }
                }
                
                logger.debug("Получено \(chunkCount, privacy: .public) чанков, общая длина ответа: \(fullResponse.count, privacy: .public)")
                updateAIMessage(text: fullResponse)
                streamingMessageId = nil
                
                let responseTime = Date().timeIntervalSince(startTime)
                logger.info("Сообщение успешно получено: время ответа=\(responseTime, privacy: .public) сек, длина=\(fullResponse.count, privacy: .public)")
                analyticsService.logMessageReceived(
                    modelName: selectedModel.rawValue,
                    responseLength: fullResponse.count,
                    responseTime: responseTime
                )
                
            } catch {

                logger.error("Ошибка при отправке сообщения: \(error.localizedDescription, privacy: .public), тип ошибки: \(String(describing: type(of: error)), privacy: .public)")
                analyticsService.logMessageError(
                    modelName: selectedModel.rawValue,
                    error: error
                )
                
                let errorMessage = ChatMessage(
                    text: "Ошибка: \(error.localizedDescription)",
                    isUser: false,
                    timestamp: Date()
                )
                messages.append(errorMessage)
                isLoading = false
                streamingMessageId = nil
            }
        }
    }
    
    // MARK: - BDUI Methods
    
    func loadHeaderUIElement() async {
        logger.debug("Начало загрузки UI элемента для header")
        headerUIElement = await bduiService.loadUIElement()
        logger.info("UI элемент для header успешно загружен")
    }
    
    // MARK: - Private
    
    private func updateAIMessage(text: String) {
        guard let lastIndex = messages.indices.last,
              !messages[lastIndex].isUser else {
            logger.warning("Попытка обновить сообщение AI, но последнее сообщение принадлежит пользователю")
            return
        }
        
        logger.debug("Обновление AI сообщения: длина текста=\(text.count, privacy: .public) символов")
        messages[lastIndex] = ChatMessage(
            text: text,
            isUser: false,
            timestamp: messages[lastIndex].timestamp
        )
    }
    
}
