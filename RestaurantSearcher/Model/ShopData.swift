//
//  ShopData.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/06.
//

import Foundation

class ShopData: Codable {
    let results: Result
    
    init(results: Result) {
        self.results = results
    }
}

class Result: Codable {
    let shop: [Shop]
    
    init(shop: [Shop]) {
        self.shop = shop
    }
}

class Shop: Codable {
    let access: String
    let address: String
    let `catch`: String
    let lat: Double
    let lng: Double
    let name: String
    let open: String
    let parking: String
    let photo: Photo
    let budget: Budget
    let card: String
}

class Photo: Codable {
    let mobile: Mobile
    let pc: PC
}

class Mobile: Codable {
    let l: String
    let s: String
}

class PC: Codable {
    let l: String
    let s: String
}

struct Budget: Codable {
    let average, code, name: String
}

// Save ShopData to UserDefaults
func saveShopData(shopData: [Shop]) {
    let results = Result(shop: shopData)
    let shopData = ShopData(results: results)
    
    let encoder = JSONEncoder()
    if let encodedData = try? encoder.encode(shopData) {
        UserDefaults.standard.set(encodedData, forKey: "ShopDataKey")
    }
}

// Retrieve ShopData from UserDefaults
func retrieveShopData() -> [Shop]? {
    if let encodedData = UserDefaults.standard.data(forKey: "ShopDataKey") {
        let decoder = JSONDecoder()
        if let shopData = try? decoder.decode(ShopData.self, from: encodedData) {
            return shopData.results.shop
        }
    }
    return nil
}
