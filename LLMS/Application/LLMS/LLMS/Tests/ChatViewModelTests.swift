//
//  ChatViewModelTests.swift
//  LLMSTests
//
//  Created by Тагир Файрушин on 1/11/26.
//

import XCTest
import Combine
@testable import LLMS
import OpenRouter
import BDUI

@MainActor
final class ChatViewModelTests: XCTestCase {
    
    var viewModel: ChatViewModel!
    var mockOpenRouterManager: MockOpenRouterManager!
    var mockAnalyticsService: MockAnalyticsService!
    var mockBDUIService: MockBDUIService!
    
    override func setUp() {
        super.setUp()
        mockOpenRouterManager = MockOpenRouterManager()
        mockAnalyticsService = MockAnalyticsService()
        mockBDUIService = MockBDUIService()
        
        viewModel = ChatViewModel(
            apiKey: "test-api-key",
            openRouterManager: mockOpenRouterManager,
            analyticsService: mockAnalyticsService,
            bduiService: mockBDUIService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockOpenRouterManager = nil
        mockAnalyticsService = nil
        mockBDUIService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        XCTAssertEqual(viewModel.selectedModel, .molmo)
        XCTAssertEqual(viewModel.userInput, "")
        XCTAssertEqual(viewModel.messages.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.streamingMessageId)
        XCTAssertEqual(viewModel.headerUIElement, UIElementData.default)
    }
    
    // MARK: - Model Selection Tests
    
    func testModelSelection() {

        let newModel = AIModel.allCases.first { $0 != .molmo } ?? .molmo
        
        viewModel.selectedModel = newModel
        
        XCTAssertEqual(viewModel.selectedModel, newModel)
        XCTAssertTrue(mockAnalyticsService.logModelSelectionCalled)
        XCTAssertEqual(mockAnalyticsService.lastModelName, newModel.rawValue)
        XCTAssertEqual(mockAnalyticsService.lastDisplayName, newModel.displayName)
    }
    
    // MARK: - Send Message Tests
    
    func testSendMessageWithEmptyInput() {

        viewModel.userInput = "   "
        
        viewModel.sendMessage()
        
        XCTAssertEqual(viewModel.messages.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(mockAnalyticsService.logMessageSentCalled)
    }
    
    func testSendMessageSuccess() async {

        let testMessage = "Test message"
        viewModel.userInput = testMessage
        let expectedResponse = "AI response"
        
        mockOpenRouterManager.mockStream = createMockStream(chunks: ["AI ", "response"])
        
        viewModel.sendMessage()
        
        await waitForCondition(timeout: 2.0) {
            self.viewModel.messages.count >= 2 && 
            self.viewModel.streamingMessageId == nil &&
            !self.viewModel.messages[1].text.isEmpty
        }
        
        XCTAssertEqual(viewModel.userInput, "")
        XCTAssertEqual(viewModel.messages.count, 2)
        XCTAssertTrue(viewModel.messages[0].isUser)
        XCTAssertEqual(viewModel.messages[0].text, testMessage)
        XCTAssertFalse(viewModel.messages[1].isUser)
        XCTAssertEqual(viewModel.messages[1].text, expectedResponse)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.streamingMessageId)
        XCTAssertTrue(mockAnalyticsService.logMessageSentCalled)
        XCTAssertTrue(mockAnalyticsService.logMessageReceivedCalled)
    }
    
    func testSendMessageWithError() async {

        let testMessage = "Test message"
        viewModel.userInput = testMessage
        let testError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        
        mockOpenRouterManager.shouldThrowError = true
        mockOpenRouterManager.mockError = testError
        
        viewModel.sendMessage()
        
        await waitForCondition(timeout: 2.0) {
            !self.viewModel.isLoading && self.viewModel.messages.count >= 2
        }
        
        XCTAssertEqual(viewModel.userInput, "")
        XCTAssertEqual(viewModel.messages.count, 2)
        XCTAssertTrue(viewModel.messages[0].isUser)
        XCTAssertEqual(viewModel.messages[0].text, testMessage)
        XCTAssertFalse(viewModel.messages[1].isUser)
        XCTAssertTrue(viewModel.messages[1].text.contains("Ошибка"))
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.streamingMessageId)
        XCTAssertTrue(mockAnalyticsService.logMessageSentCalled)
        XCTAssertTrue(mockAnalyticsService.logMessageErrorCalled)
    }
    
    func testSendMessageStreaming() async {

        let testMessage = "Test message"
        viewModel.userInput = testMessage
        let chunks = ["Hello", " ", "World", "!"]
        
        mockOpenRouterManager.mockStream = createMockStream(chunks: chunks)
        
        viewModel.sendMessage()
        
        await waitForCondition(timeout: 2.0) {
            self.viewModel.messages.count >= 2 && 
            self.viewModel.streamingMessageId == nil &&
            !self.viewModel.messages[1].text.isEmpty
        }
        
        XCTAssertEqual(viewModel.messages.count, 2)
        XCTAssertFalse(viewModel.messages[1].isUser)
        XCTAssertEqual(viewModel.messages[1].text, "Hello World!")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.streamingMessageId)
    }
    
    func testLoadHeaderUIElement() async {

        let expectedUIElement = UIElementData(
            iconName: "test-icon",
            label: "Test Label",
            colorHex: "#FF0000"
        )
        mockBDUIService.mockUIElement = expectedUIElement
        
        await viewModel.loadHeaderUIElement()
        
        XCTAssertEqual(viewModel.headerUIElement, expectedUIElement)
    }
    
    func testLoadHeaderUIElementWithError() async {

        mockBDUIService.shouldReturnError = true
        
        await viewModel.loadHeaderUIElement()
        
        XCTAssertEqual(viewModel.headerUIElement, UIElementData.default)
    }
    
    // MARK: - Helper Methods
    
    private func createMockStream(chunks: [String]) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task { @MainActor in
                for chunk in chunks {
                    continuation.yield(chunk)
             
                    try? await Task.sleep(nanoseconds: 50_000_000)
                }
                continuation.finish()
            }
        }
    }
    
    private func waitForCondition(timeout: TimeInterval, condition: @escaping () -> Bool) async {
        let startTime = Date()
        while !condition() && Date().timeIntervalSince(startTime) < timeout {
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        
        try? await Task.sleep(nanoseconds: 100_000_000)
    }
}

// MARK: - Mock Classes

final class MockOpenRouterManager: OpenRouterManagerProtocol {
    var mockStream: AsyncThrowingStream<String, Error>?
    var shouldThrowError = false
    var mockError: Error?
    var sendStreamingRequestCalled = false
    var lastMessages: [OpenRouterMessage]?
    var lastModel: String?
    
    func sendStreamingRequest(
        messages: [OpenRouterMessage],
        model: String,
        provider: OpenRouterRequest.Provider
    ) async throws -> AsyncThrowingStream<String, Error> {
        sendStreamingRequestCalled = true
        lastMessages = messages
        lastModel = model
        
        if shouldThrowError {
            throw mockError ?? NSError(domain: "TestError", code: 500, userInfo: nil)
        }
        
        return mockStream ?? createEmptyStream()
    }
    
    private func createEmptyStream() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }
}

final class MockAnalyticsService: AnalyticsServiceProtocol {
    var logModelSelectionCalled = false
    var lastModelName: String?
    var lastDisplayName: String?
    
    var logMessageSentCalled = false
    var lastMessageLength: Int?
    var lastMessageCount: Int?
    
    var logMessageReceivedCalled = false
    var lastResponseLength: Int?
    var lastResponseTime: TimeInterval?
    
    var logMessageErrorCalled = false
    var lastError: Error?
    
    func logModelSelection(modelName: String, displayName: String) {
        logModelSelectionCalled = true
        lastModelName = modelName
        lastDisplayName = displayName
    }
    
    func logMessageSent(modelName: String, messageLength: Int, messageCount: Int) {
        logMessageSentCalled = true
        lastMessageLength = messageLength
        lastMessageCount = messageCount
    }
    
    func logMessageReceived(modelName: String, responseLength: Int, responseTime: TimeInterval) {
        logMessageReceivedCalled = true
        lastResponseLength = responseLength
        lastResponseTime = responseTime
    }
    
    func logMessageError(modelName: String, error: Error) {
        logMessageErrorCalled = true
        lastError = error
    }
    
    func logEvent(_ eventName: String, parameters: [String: Any]?) {
        // Mock implementation
    }
    
    func setUserProperty(_ value: String?, forName property: String) {
        // Mock implementation
    }
}

@MainActor
final class MockBDUIService: BDUIServiceProtocol {
    var mockUIElement: UIElementData = .default
    var shouldReturnError = false
    var loadUIElementCalled = false
    
    func loadUIElement() async -> UIElementData {
        loadUIElementCalled = true
        
        if shouldReturnError {
            return .default
        }
        
        return mockUIElement
    }
}
