//
//  AIModel.swift
//  OpenRouter
//
//  Created by Тагир Файрушин on 1/10/26.
//

import Foundation

public enum AIModel: String, CaseIterable, Identifiable {
    case molmo = "allenai/molmo-2-8b:free"
    case mimo = "xiaomi/mimo-v2-flash:free"
    case nemotron = "nvidia/nemotron-3-nano-30b-a3b:free"
    case devstral = "mistralai/devstral-2512:free"
    case trinity = "arcee-ai/trinity-mini:free"
    case chimera = "tngtech/tng-r1t-chimera:free"
    case gptOss = "openai/gpt-oss-120b:free"
    case glm = "z-ai/glm-4.5-air:free"
    case qwen = "qwen/qwen3-coder:free"
    case kimi = "moonshotai/kimi-k2:free"
    case dolphin = "cognitivecomputations/dolphin-mistral-24b-venice-edition:free"
    case gemma = "google/gemma-3n-e2b-it:free"
    case deepseek = "deepseek/deepseek-r1-0528:free"
    case gemini = "google/gemini-2.0-flash-exp:free"
    case llama = "meta-llama/llama-3.1-405b-instruct:free"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .molmo: return "Molmo 2 8B"
        case .mimo: return "Mimo V2 Flash"
        case .nemotron: return "Nemotron 3 Nano 30B"
        case .devstral: return "Devstral 2512"
        case .trinity: return "Trinity Mini"
        case .chimera: return "TNG R1T Chimera"
        case .gptOss: return "GPT OSS 120B"
        case .glm: return "GLM 4.5 Air"
        case .qwen: return "Qwen3 Coder"
        case .kimi: return "Kimi K2"
        case .dolphin: return "Dolphin Mistral 24B"
        case .gemma: return "Gemma 3N E2B"
        case .deepseek: return "DeepSeek R1"
        case .gemini: return "Gemini 2.0 Flash"
        case .llama: return "Llama 3.1 405B"
        }
    }
}
