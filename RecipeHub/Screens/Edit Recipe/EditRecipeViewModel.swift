//
//  EditRecipeViewModel.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//

import Swinject

protocol EditRecipeViewModelProtocol {
    var currentRecipe: Recipe? { get set }
    var recipeTypes: [String] { get }
    func updateRecipeDetails()
    func deleteRecipe()
}

class EditRecipeViewModel: EditRecipeViewModelProtocol {
    let apiClient: ApiClientProtocol
    var currentRecipe: Recipe?
    let recipeTypes: [String] = ["Dinner", "Lunch", "Dessert", "Side Dish", "Appetizer", "Snacks",
    "Breakfast", "Beverage", "Snack"]
    
    init(apiClient: ApiClientProtocol = Container.sharedDIContainer.resolve(ApiClientProtocol.self)!,
         currentRecipe: Recipe? = nil) {
        self.apiClient = apiClient
        self.currentRecipe = currentRecipe
    }
    
    func updateRecipeDetails() {
        
    }
    
    func deleteRecipe() {
        
    }
    
    
}
