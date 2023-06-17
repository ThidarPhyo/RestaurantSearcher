//
//  ShopData.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/06.
//

import Foundation

class ShopData: Decodable {
    
    let results: Result
}

class Result: Decodable {
    
    let shop: [Shop]
}

class Shop: Decodable {
    
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

class Photo: Decodable {
    
    let mobile: Mobile
    let pc: PC
}

class Mobile: Decodable {
    
    let l: String
    let s: String
}

class PC: Decodable {
    
    let l: String
    let s: String
    
}
struct Budget: Decodable {
    let average, code, name: String
}
