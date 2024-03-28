//
//  Recipe.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//
import CoreData

struct Recipe: Codable {
    let id: String?
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

extension Recipe {
    func toEntity(in context: NSManagedObjectContext, entity: RecipeEntity) -> RecipeEntity {
        if let id = id {
            entity.id = id
        }
        if let name = name {
            entity.name = name
        }
        if let image = image {
            entity.image = image
        }
        if let rating = rating {
            entity.rating = rating
        }
        if let reviewCount = reviewCount {
            entity.reviewCount = Int32(reviewCount)
        }
        if let caloriesPerServing = caloriesPerServing {
            entity.caloriesPerServing = Int32(caloriesPerServing)
        }
        if let mealType = mealType {
            entity.mealType = convertArrayToData(array: mealType)
        }
        if let tags = tags {
            entity.tags = convertArrayToData(array: tags)
        }
        if let ingredients = ingredients {
            entity.ingredients = convertArrayToData(array: ingredients)
        }
        if let instructions = instructions {
            entity.instructions = convertArrayToData(array: instructions)
        }
        if let cuisine = cuisine {
            entity.cuisine = cuisine
        }
        if let difficulty = difficulty {
            entity.difficulty = difficulty
        }
        if let prepTimeMinutes = prepTimeMinutes {
            entity.prepTimeMinutes = Int32(prepTimeMinutes)
        }
        if let cookTimeMinutes = cookTimeMinutes {
            entity.cookTimeMinutes = Int32(cookTimeMinutes)
        }
        if let servings = servings {
            entity.servings = Int32(servings)
        }

        return entity
    }
    
    // Function to convert array to NSData for storage
    func convertArrayToData(array: [Any]) -> NSData? {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array,
                                                        requiringSecureCoding: false)
            return NSData(data: data)
        } catch {
            print("Couldn't convert array to NSData: \(error)")
            return nil
        }
    }
}
