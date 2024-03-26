//
//  CoreDataStorageMock.swift
//  RecipeHubTests
//
//  Created by CHATHURA ELLAWALA on 2024-03-26.
//
@testable import RecipeHub
import CoreData

class CoreDataStorageMock: CoreDataRecipeStorageProtocol {
    var savedToCoreDataDb: Bool = false
    var deletedFromCoreDataDb: Bool = false
    
    func fetchData(onSuccess: @escaping ([RecipeEntity]?) -> Void) {
        let noodles = RecipeEntity()
        let pizza = RecipeEntity()
        let entities: [RecipeEntity] = [noodles, pizza]
        onSuccess(entities)
    }
    
    func saveData(toPersist persisting: Recipe) {
        savedToCoreDataDb = true
    }
    
    func deleteResponse(for recipe: Recipe, in context: NSManagedObjectContext) {
        deletedFromCoreDataDb = true
    }
}
