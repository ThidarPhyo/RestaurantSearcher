//
//  ShopAreaData.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/15.
//

import Foundation

// MARK: - ShopAreaData
struct ShopAreaData: Decodable {
    let results: ShopArea
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode(ShopArea.self, forKey: .results)
    }
}

// MARK: - AreaResults
struct ShopArea: Decodable {
    let largeArea: [LargeArea]

    enum CodingKeys: String, CodingKey {
        case largeArea = "large_area"
    }
}

// MARK: - LargeArea
struct LargeArea: Decodable {
    let code: String
    let largeServiceArea: ServiceArea
    let name: String
    let serviceArea: ServiceArea

    enum CodingKeys: String, CodingKey {
        case code
        case largeServiceArea = "large_service_area"
        case name
        case serviceArea = "service_area"
    }
}

// MARK: - ServiceArea
struct ServiceArea: Decodable {
    let code, name: String
}
