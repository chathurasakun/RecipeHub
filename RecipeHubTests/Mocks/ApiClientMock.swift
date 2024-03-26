//
//  ApiClientMock.swift
//  RecipeHubTests
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//
@testable import RecipeHub
import Combine
import Alamofire

enum NetworkError {
    case genericError
}

class ApiClientMock: ApiClientProtocol {
    var shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    let noodles = Recipe(id: 1, name: "Noodles",rating: 4.7, reviewCount: 10, caloriesPerServing: 120,
                         tags: ["Dinner"],
                         cuisine: "Asian", difficulty: "Easy", prepTimeMinutes: 10,
                         cookTimeMinutes: 12,
                         servings: 4)
    let pizza = Recipe(id: 2, name: "Pizza",rating: 4.3, reviewCount: 22, caloriesPerServing: 320,
                       tags: ["Dinner"],
                       cuisine: "Chinese", difficulty: "Easy", prepTimeMinutes: 20,
                       cookTimeMinutes: 20,
                       servings: 2)
    
    func getRecipeList(route: APIRouter) -> AnyPublisher<RecipeResponse, AFError> {
        if shouldSucceed {
            let recipies: [Recipe] = [noodles, pizza]
            let recipeResponse: RecipeResponse = RecipeResponse(recipes: recipies, total: 50, skip: 0,
                                                                limit: 30)
            let mockRecipeListSuccessSubject = PassthroughSubject<RecipeResponse, AFError>()
            mockRecipeListSuccessSubject.send(recipeResponse)
            mockRecipeListSuccessSubject.send(completion: .finished)
            return mockRecipeListSuccessSubject.eraseToAnyPublisher()
        } else {
            let mockRecipeListFailureSubject = PassthroughSubject<RecipeResponse, AFError>()
            mockRecipeListFailureSubject.send(completion: .failure(.explicitlyCancelled))
            return mockRecipeListFailureSubject.eraseToAnyPublisher()
        }
    }
    
    func saveRecipe(route: RecipeHub.APIRouter) -> AnyPublisher<RecipeHub.Recipe, Alamofire.AFError> {
        let mockSubject = PassthroughSubject<Recipe, AFError>()
        mockSubject.send(noodles)
        
        return mockSubject.eraseToAnyPublisher()
    }
    
    func updateRecipe(route: RecipeHub.APIRouter) -> AnyPublisher<RecipeHub.Recipe, Alamofire.AFError> {
        let mockSubject = PassthroughSubject<Recipe, AFError>()
        mockSubject.send(noodles)
        
        return mockSubject.eraseToAnyPublisher()
    }
    
    func deleteRecipe(route: RecipeHub.APIRouter) -> AnyPublisher<RecipeHub.Recipe, Alamofire.AFError> {
        let mockSubject = PassthroughSubject<Recipe, AFError>()
        mockSubject.send(noodles)
        
        return mockSubject.eraseToAnyPublisher()
    }
    
    func loginUser(route: APIRouter) -> AnyPublisher<LoginResponse, AFError> {
        if shouldSucceed {
            let mockSuccessSubject = PassthroughSubject<LoginResponse, AFError>()
            let successResponse = LoginResponse(id: 1, username: "testuser", email: "test@gmail.com", firstName: "test", lastName: "User", gender: "male", image: "", token: "testValue")
            mockSuccessSubject.send(successResponse)
            mockSuccessSubject.send(completion: .finished)
            return mockSuccessSubject.eraseToAnyPublisher()
        } else {
            let mockFailureSubject = PassthroughSubject<LoginResponse, AFError>()
            mockFailureSubject.send(completion: .failure(.explicitlyCancelled))
            return mockFailureSubject.eraseToAnyPublisher()
        }
    }
}
