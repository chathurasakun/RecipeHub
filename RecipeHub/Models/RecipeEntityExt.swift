//
//  RecipeEntityExt.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

import CoreData

extension RecipeEntity {
    func toDTO() -> Recipe {
        return Recipe(
            id: id,
            name: String(name ?? ""),
            image: String(image ?? ""),
            rating: Double(rating),
            reviewCount: Int(reviewCount),
            caloriesPerServing: Int(caloriesPerServing),
            mealType: convertDataToArray(data: mealType as? NSData),
            tags: convertDataToArray(data: tags as? NSData),
            ingredients: convertDataToArray(data: ingredients as? NSData),
            instructions: convertDataToArray(data: instructions as? NSData),
            cuisine: String(cuisine ?? ""),
            difficulty: String(difficulty ?? ""),
            prepTimeMinutes: Int(prepTimeMinutes),
            cookTimeMinutes: Int(cookTimeMinutes),
            servings: Int(servings)
        )
    }
    
    func convertDataToArray(data: NSData?) -> [String]? {
        guard let data = data else { return nil }
        do {
            if let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(referencing: data)) as? [String] {
                return array
            }
        } catch {
            print("Couldn't convert NSData to array: \(error)")
        }
        return nil
    }
}
