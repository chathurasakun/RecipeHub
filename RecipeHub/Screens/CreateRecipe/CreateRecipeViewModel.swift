//
//  CreateRecipeViewModel.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import Swinject
import Combine

protocol CreateRecipeViewModelProtocol {
    var recipeTypes: [String] { get }
    var recipeSaved: PassthroughSubject<Bool, Never> { get set }
    var recipeName: String { get set }
    var mealType: String { get set }
    var ingrediats: [String] { get set }
    var steps: [String] { get set }
    var recipeImage: String { get set }
    
    func saveRecipe()
}

class CreateRecipeViewModel: CreateRecipeViewModelProtocol {
    let apiClient: ApiClientProtocol
    var mealType: String = ""
    var recipeName: String = ""
    var ingrediats: [String] = []
    var steps: [String] = []
    var recipeImage: String = ""
    let recipeTypes: [String] = ["Dinner", "Lunch", "Dessert", "Side Dish", "Appetizer", "Snacks",
    "Breakfast", "Beverage", "Snack"]
    var recipeSaved = PassthroughSubject<Bool, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ApiClientProtocol = Container.sharedDIContainer.resolve(ApiClientProtocol.self)!) {
        self.apiClient = apiClient
    }
    
    func saveRecipe() {
        var recipe = Recipe(id: nil, rating: nil, reviewCount: nil, caloriesPerServing: nil,
                            tags: nil, cuisine: nil, difficulty: nil, prepTimeMinutes: nil,
                            cookTimeMinutes: nil, servings: nil)
        recipe.mealType = [mealType]
        recipe.name = recipeName
        recipe.ingredients = ingrediats
        recipe.instructions = steps
        recipe.image = recipeImage
        
        apiClient.saveRecipe(route: .saveRecipe(recipe: recipe))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.recipeSaved.send(false)
                    if let code = error.responseCode {
                        print("code ", code)
                    }
                    if error.isSessionTaskError {
                        print("session Tak error")
                    }
                    if error.isResponseSerializationError {
                        print("serialization error")
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] recipe in
                self?.recipeSaved.send(true)
            }
            .store(in: &cancellables)
    }
    
}
