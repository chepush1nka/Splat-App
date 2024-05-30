//
//  APIClient.swift
//  DentalHealthApp
//
//  Created by Pavel Vyaltsev.
//

import Foundation

class APIClient {
    private let baseURL = "http://158.160.114.113:5454"

    var lastJson: [String: String] = [:]


    func uploadPhotos(type: String, images: [Data], completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = type == "color" ? "/handle_photo_upload_color" : "/handle_photo_upload_bite"
        let url = URL(string: baseURL + endpoint)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var json: [String: String] = [:]
        for (index, image) in images.enumerated() {
            let base64String = image.base64EncodedString()
            if let utf8Data = base64String.data(using: .utf8) {
                let stringFromData = String(data: utf8Data, encoding: .utf8)
                json["user_photo_\(index)"] = stringFromData
            }
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
            lastJson = json
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            }
        }

        task.resume()
    }

    func requestAnalysis(type: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = type == "color" ? "/handle_analysis_request_color" : "/handle_analysis_request_bite"
        let url = URL(string: baseURL + endpoint)!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: lastJson, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            }
        }

        task.resume()
    }

    func provideRecommendations(type: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = type == "color" ? "/provide_recommendations_color" : "/provide_recommendations_bite"
        let url = URL(string: baseURL + endpoint)!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            }
        }

        task.resume()
    }
}
