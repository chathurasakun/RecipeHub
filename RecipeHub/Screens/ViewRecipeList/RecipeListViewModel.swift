//
//  RecipeListViewModel.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import Foundation
import Swinject
import RxCocoa
import RxSwift
import Combine

protocol RecipeListViewModelProtocol {
    var recipeTypes: [String] { get }
    var recipies: BehaviorRelay<[Recipe]> { get set }
    var mealType: String { get set }
    var recipiesRecieved: PassthroughSubject<Bool, Never> { get set }
    func sendGetRecipeListRequestToServer()
    func persistRecipies(recipies: [Recipe])
    func getStoredRecipies(completion: @escaping(Bool) -> Void)
}

class RecipeListViewModel: RecipeListViewModelProtocol {
    let recipeTypes: [String] = ["Dinner", "Lunch", "Dessert", "Side Dish", "Appetizer", "Snacks",
    "Breakfast", "Beverage", "Snack"]
    let apiClient: ApiClientProtocol
    let coreDataStorage: CoreDataRecipeStorageProtocol
    var recipies: BehaviorRelay<[Recipe]> = BehaviorRelay(value: [])
    var mealType: String = "Dinner"
    var recipiesRecieved = PassthroughSubject<Bool, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ApiClientProtocol = Container.sharedDIContainer.resolve(ApiClientProtocol.self)!,
         coreDataStorage: CoreDataRecipeStorageProtocol = Container.sharedDIContainer.resolve(CoreDataRecipeStorageProtocol.self)!) {
        self.apiClient = apiClient
        self.coreDataStorage = coreDataStorage
    }
    
    func persistRecipies(recipies: [Recipe]) {
        for recipe in recipies {
            coreDataStorage.saveData(toPersist: recipe)
        }
    }
    
    func getStoredRecipies(completion: @escaping(Bool) -> Void) {
        coreDataStorage.fetchData { [weak self] storedRecipies in
            var fetched: Bool = false
            defer {
                completion(fetched)
            }
            guard let storedRecipies = storedRecipies else {
                return
            }
            
            fetched = true
            
            // filter stored recipies according to meal type
            let filteredRecipies = storedRecipies.filter({
                let recipe = $0.toDTO()
                if let mealType = recipe.mealType {
                    if mealType.contains(self!.mealType) {
                        return true
                    }
                    return false
                }
                return false
            })
            // convert filtered recipies and put into array
            let recipies = filteredRecipies.map { storedRecipe in
                let recipe = storedRecipe.toDTO()
                return recipe
            }
            
            self?.recipies.accept(recipies)
        }
    }
    
    func sendGetRecipeListRequestToServer() {
        apiClient.getRecipeList(route: .getRecipeLsit(type: mealType))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.recipiesRecieved.send(false)
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
            } receiveValue: { [weak self] response in
                guard let recipies = response.recipes else {
                    self?.recipiesRecieved.send(false)
                    return
                }
                self?.recipies.accept(recipies)
                self?.recipiesRecieved.send(true)
                self?.persistRecipies(recipies: recipies)
            }
            .store(in: &cancellables)
    }
}
