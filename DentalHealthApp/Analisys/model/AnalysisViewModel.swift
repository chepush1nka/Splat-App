//
//  AnalysisViewModel.swift
//  DentalHealthApp
//
//  Created by Pavel Vyaltsev on 26.03.2024.
//

import SwiftUI
import Combine

class AnalysisViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showResultScreen = false
    @Published var showErrorScreen = false
    @Published var analysisResult: AnalysisResult = AnalysisResult(type: .all, teethColor: .M("M1-1"), bite: .undefined)

    private let apiClient = APIClient()

    func performAnalysis(type: String, images: [UIImage]) {
        isLoading = true

        let imageDataArray = images.map { $0.jpegData(compressionQuality: 0.8) ?? Data() }

        apiClient.uploadPhotos(type: type, images: imageDataArray) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.requestAnalysis(type: type)
                case .failure(let error):
                    print("Error uploading photos: \(error.localizedDescription)")
                    self?.isLoading = false
                }
            }
        }
    }

    private func requestAnalysis(type: String) {
        apiClient.requestAnalysis(type: type) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response == "0" || response.isEmpty || response.count > 15 {
                        self?.showErrorScreen = true
                        return
                    }
                    if type == "color" {
                        let analysisResult = AnalysisResult(
                            type: .teethColor,
                            teethColor: .M(response),
                            teethColorCareRecommendations: "Используйте отбеливающую зубную пасту и регулярно посещайте стоматолога для профессиональной чистки зубов.",
                            bite: .normal,
                            biteСorrectionRecommendations: nil
                        )
                        UserData.shared.addResult(analysisResult)
                        self?.analysisResult = analysisResult
                        self?.showResultScreen = true
                    } else {
                        let analysisResult = AnalysisResult(
                            type: .bite,
                            teethColor: .undefined,
                            teethColorCareRecommendations: nil,
                            bite: ByteType.mapFromSting(string: response),
                            biteСorrectionRecommendations: "Рекомендуется посещение стоматолога"
                        )
                        UserData.shared.addResult(analysisResult)
                        self?.analysisResult = analysisResult
                        self?.showResultScreen = true
                    }

                case .failure(let error):
                    print("Error requesting analysis: \(error.localizedDescription)")
                    self?.showErrorScreen = true
                }
                self?.isLoading = false
            }
        }
    }
}


