//
//  RecipeEntity+CoreDataProperties.swift
//  
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var caloriesPerServing: Int32
    @NSManaged public var cookTimeMinutes: Int32
    @NSManaged public var cuisine: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var id: Int32
    @NSManaged public var image: String?
    @NSManaged public var ingredients: NSArray?
    @NSManaged public var instructions: NSArray?
    @NSManaged public var mealType: NSArray?
    @NSManaged public var name: String?
    @NSManaged public var prepTimeMinutes: Int32
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int32
    @NSManaged public var servings: Int32
    @NSManaged public var tags: NSArray?
    @NSManaged public var userId: Int32

}
