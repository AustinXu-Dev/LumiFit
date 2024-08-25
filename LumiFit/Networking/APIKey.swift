//
//  APIKey.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/25.
//

import Foundation

enum Constants {
  static func loadAPIKeys() async throws  {
    let request = NSBundleResourceRequest(tags: ["APIKeys"])
    try await request.beginAccessingResources()

    let url = Bundle.main.url(forResource: "APIKey", withExtension: "json")!
    let data = try Data(contentsOf: url)
    // TODO: Store in keychain and skip NSBundleResourceRequest on next launches
    APIKeys.storage = try JSONDecoder().decode([String: String].self, from: data)

    request.endAccessingResources()
  }

  enum APIKeys {
    static fileprivate(set) var storage = [String: String]()

    static var calorieNinjaApiKey: String { storage["CalorieNinjaAPIKey"] ?? "" }
  }
}
