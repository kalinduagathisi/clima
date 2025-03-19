//
//  SecretsHelper.swift
//  Clima
//
//  Created by Kalindu Agathisi on 2025-03-19.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

struct Secrets {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, format: nil) as? [String: Any] else {
            fatalError("Secrets.plist file is missing or corrupt.")
        }
        return plist["API_KEY"] as? String ?? ""
    }
}

