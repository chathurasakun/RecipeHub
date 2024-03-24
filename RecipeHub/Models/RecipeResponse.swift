//
//  RecipeResponse.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

struct RecipeResponse: Codable {
    let recipes: [Recipe]?
    let total: Int?
    let skip: Int?
    let limit: Int?
}
