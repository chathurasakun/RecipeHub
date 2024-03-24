//
//  ApiClient.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//

import Foundation
import Combine
import Alamofire

protocol ApiClientProtocol {
    func getRecipeList(route: APIRouter) -> AnyPublisher<RecipeResponse, AFError>
    func saveRecipe(route: APIRouter) -> AnyPublisher<Recipe, AFError>
    func updateRecipe(route: APIRouter) -> AnyPublisher<Recipe, AFError>
    func deleteRecipe(route: APIRouter) -> AnyPublisher<Recipe, AFError>
//    func loginUser(route: APIRouter) -> AnyPublisher<LoginResponse, AFError>
}

class ApiClient: ApiClientProtocol {
    func getRecipeList(route: APIRouter) -> AnyPublisher<RecipeResponse, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: RecipeResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func saveRecipe(route: APIRouter) -> AnyPublisher<Recipe, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: Recipe.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func updateRecipe(route: APIRouter) -> AnyPublisher<Recipe, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: Recipe.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func deleteRecipe(route: APIRouter) -> AnyPublisher<Recipe, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: Recipe.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
//    func loginUser(route: APIRouter) -> AnyPublisher<LoginResponse, AFError> {
//        return AF.request(route)
//            .validate()
//            .publishDecodable(type: LoginResponse.self)
//            .value()
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
}
