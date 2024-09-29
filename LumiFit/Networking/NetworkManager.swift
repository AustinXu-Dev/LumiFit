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

    init() throws {
        // Load the API key from the Config.plist file
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let key = config["CalorieNinjaApiKey"] as? String {
            self.apiKey = key
        } else {
            throw NSError(domain: "NetworkManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "API Key not found in Config.plist"])
        }

        self.headers = ["X-Api-Key": apiKey]
    }

    func fetchData(params: String, completion: @escaping (Result<FoodResponse, Error>) -> Void) {
        let url = "https://api.calorieninjas.com/v1/nutrition"
        let parameters: Parameters = ["query": params]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let foodResponse = try JSONDecoder().decode(FoodResponse.self, from: data)
                        completion(.success(foodResponse))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
