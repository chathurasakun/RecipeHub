//
//  RecipeDetailsViewModel.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//
import Swinject

protocol RecipeDetailsViewModelProtocol {
    var currentRecipe: Recipe? { get set }
}

class RecipeDetailsViewModel: RecipeDetailsViewModelProtocol {
    
    let apiClient: ApiClientProtocol
    var currentRecipe: Recipe?
    
    init(apiClient: ApiClientProtocol = Container.sharedDIContainer.resolve(ApiClientProtocol.self)!,
         currentRecipe: Recipe? = nil) {
        self.apiClient = apiClient
        self.currentRecipe = currentRecipe
    }
}
