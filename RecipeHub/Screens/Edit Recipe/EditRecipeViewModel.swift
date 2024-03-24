//
//  EditRecipeViewModel.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//

import Swinject
import Combine

protocol EditRecipeViewModelProtocol {
    var currentRecipe: Recipe? { get set }
    var recipeTypes: [String] { get }
    func updateRecipeDetails()
    var recipieUpdated: PassthroughSubject<Bool, Never> { get set }
    var recipieDeleted: PassthroughSubject<Bool, Never> { get set }
    func deleteRecipe()
}

class EditRecipeViewModel: EditRecipeViewModelProtocol {
    let apiClient: ApiClientProtocol
    var currentRecipe: Recipe?
    var recipieUpdated = PassthroughSubject<Bool, Never>()
    var recipieDeleted = PassthroughSubject<Bool, Never>()
    let recipeTypes: [String] = ["Dinner", "Lunch", "Dessert", "Side Dish", "Appetizer", "Snacks",
    "Breakfast", "Beverage", "Snack"]
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ApiClientProtocol = Container.sharedDIContainer.resolve(ApiClientProtocol.self)!,
         currentRecipe: Recipe? = nil) {
        self.apiClient = apiClient
        self.currentRecipe = currentRecipe
    }
    
    func updateRecipeDetails() {
        guard let currentRecipe = currentRecipe else {
            return
        }
        apiClient.updateRecipe(route: .upadateRecipe(recipe: currentRecipe))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.recipieUpdated.send(false)
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
                    self?.recipieUpdated.send(true)
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func deleteRecipe() {
        guard let recipeId = currentRecipe?.id else {
            return
        }
        apiClient.deleteRecipe(route: .deleteRecipe(id: String(recipeId)))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.recipieDeleted.send(false)
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
                    self?.recipieDeleted.send(true)
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
