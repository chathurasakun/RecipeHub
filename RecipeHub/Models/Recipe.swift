//
//  Recipe.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

struct Recipe: Codable {
    let id: Int?
    var name: String?
    var image: String?
    let rating: Double?
    let reviewCount: Int?
    let caloriesPerServing: Int?
    var mealType: [String]?
    let tags: [String]?
    var ingredients: [String]?
    var instructions: [String]?
    let cuisine: String?
    let difficulty: String?
    let prepTimeMinutes: Int?
    let cookTimeMinutes: Int?
    let servings: Int?
}
