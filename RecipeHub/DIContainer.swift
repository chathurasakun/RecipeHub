//
//  DIContainer.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import Foundation
import Swinject

extension Container {
    static let sharedDIContainer: Container = {
        let container = Container()
        
        container.register(ApiClientProtocol.self) { _ in ApiClient() }
        container.register(RecipeListViewModelProtocol.self) { _ in RecipeListViewModel() }
        container.register(CreateRecipeViewModelProtocol.self) { _ in CreateRecipeViewModel() }
        
        return container
    }()
    
}
