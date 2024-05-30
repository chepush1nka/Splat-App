//
//  AnalysisResult.swift
//  DentalHealthApp
//
//  Created by Pavel Vyaltsev.
//

enum ByteType: String, Codable, Hashable {
    case undefined = "Не определен"
    case normal = "Нормальный"
    case distal = "Дистальный"
    case mesial = "Мезиальный"
    case deep = "Глубокий"
    case open = "Открытый"
    case cross = "Перекрестный"

    static func mapFromSting(string: String) -> ByteType {
        if string == "0" {
            return .undefined
        } else if string == "1" {
            return .normal
        } else if string == "2" {
            return .distal
        } else if string == "3" {
            return .mesial
        } else if string == "4" {
            return .deep
        } else if string == "5" {
            return .open
        } else if string == "6" {
            return .cross
        } else {
            return .undefined
        }
    }
}

enum TeethType: Codable, Hashable {
    case undefined
    case M(String)

    func toString() -> String {
        switch self {
        case .undefined:
            return "Не определен"
        case let .M(str):
            return str
        }
    }
}

enum AnalisysType: String, Codable, Hashable {
    case all = "Определение цвета зубов и прикуса"
    case teethColor = "Определение цвета зубов"
    case bite = "Определение прикуса"
}

struct AnalysisResult: Codable, Hashable {
    static func == (lhs: AnalysisResult, rhs: AnalysisResult) -> Bool {
        return lhs.type == rhs.type && lhs.teethColor == rhs.teethColor &&
        lhs.teethColorCareRecommendations == rhs.teethColorCareRecommendations &&
        lhs.bite == rhs.bite && lhs.biteСorrectionRecommendations == rhs.biteСorrectionRecommendations
    }

    let type: AnalisysType

    let teethColor: TeethType
    let teethColorCareRecommendations: String?

    let bite: ByteType
    let biteСorrectionRecommendations: String?

    init(type: AnalisysType, teethColor: TeethType, teethColorCareRecommendations: String? = nil, bite: ByteType, biteСorrectionRecommendations: String? = nil) {
        self.type = type
        self.teethColor = teethColor
        self.teethColorCareRecommendations = teethColorCareRecommendations
        self.bite = bite
        self.biteСorrectionRecommendations = biteСorrectionRecommendations
    }
}
