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
    func getRecipeList()
}

class RecipeListViewModel: RecipeListViewModelProtocol {
    let recipeTypes: [String] = ["Dinner", "Lunch", "Dessert", "Side Dish", "Appetizer", "Snacks",
    "Breakfast", "Beverage", "Snack"]
    let apiClient: ApiClientProtocol
    var recipies: BehaviorRelay<[Recipe]> = BehaviorRelay(value: [])
    var mealType: String = "Dinner"
    var recipiesRecieved = PassthroughSubject<Bool, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ApiClientProtocol = Container.sharedDIContainer.resolve(ApiClientProtocol.self)!) {
        self.apiClient = apiClient
    }
    
    func getRecipeList() {
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
            }
            .store(in: &cancellables)
    }
}
