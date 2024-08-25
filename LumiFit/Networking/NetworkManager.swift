//
//  NetworkRequest.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/25.
//

import Foundation
import Alamofire

class NetworkManager {
    private let apiKey: String
    private let headers: HTTPHeaders

    init() async throws {
        // Loading API Keys
        if Constants.APIKeys.calorieNinjaApiKey.isEmpty {
            try await Constants.loadAPIKeys()
        }
        
        self.apiKey = Constants.APIKeys.calorieNinjaApiKey
        self.headers = ["X-Api-Key": apiKey]
    }

    func fetchData(params: String, completion: @escaping (Result<FoodResponse, Error>) -> Void) {
        let url = "https://api.calorieninjas.com/v1/nutrition"
        let parameters: Parameters = ["query": params]

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    // Print the raw data as a string to debug
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw JSON response: \(jsonString)")
                    }

                    // Attempt to decode the data
                    do {
                        let foodResponse = try JSONDecoder().decode(FoodResponse.self, from: data)
                        completion(.success(foodResponse))
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Network error: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
