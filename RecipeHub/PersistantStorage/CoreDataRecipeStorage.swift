//
//  CoreDataRecipeStorage.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

import Foundation
import CoreData

protocol CoreDataRecipeStorageProtocol {
    func fetchData(onSuccess: @escaping ([RecipeEntity]?) -> Void)
    func saveData(toPersist persisting: Recipe)
    func deleteResponse(for recipe: Recipe, in context: NSManagedObjectContext)
}

class CoreDataRecipeStorage: CoreDataRecipeStorageProtocol {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func fetchData(onSuccess: @escaping ([RecipeEntity]?) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let persistedRecipies = try context.fetch(RecipeEntity.fetchRequest()) as? [RecipeEntity]
                onSuccess(persistedRecipies)
            } catch {
                // Have to use crashlytics to log any errors in production
                debugPrint("CoreDataRecipeStorage Unresolved error " +
                           "\(CoreDataStorageError.readError(error))")
            }
        }
    }
    
    func saveData(toPersist recipe: Recipe) {
        coreDataStorage.performBackgroundTask { context in
            self.deleteResponse(for: recipe, in: context)
            
            var newRecipeEntity = RecipeEntity(context: context)
            newRecipeEntity = recipe.toEntity(in: context, entity: newRecipeEntity)

            do {
                try context.save()
            } catch {
                debugPrint("CoreDataRecipeStorage Unresolved error " +
                           "\(CoreDataStorageError.saveError(error))")
            }
        }
    }

    func deleteResponse(for recipe: Recipe, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        guard let id = recipe.id else {
            return
        }
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        
        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
            }
        } catch {
            debugPrint("CoreDataRecipeStorage Unresolved error" +
                       "\(CoreDataStorageError.deleteError(error))")
        }
    }
}
