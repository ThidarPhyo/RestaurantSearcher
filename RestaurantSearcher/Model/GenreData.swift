//
//  GenreData.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/15.
//

import Foundation

// MARK: - Welcome
struct GenreData: Decodable {
    let results: Results
}

// MARK: - Results
struct Results: Decodable {
    let genre: [Genre]

    enum CodingKeys: String, CodingKey {
        case genre
    }
}

// MARK: - Genre
struct Genre: Decodable {
    let code, name: String
}
