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
        container.register(UserdefaultsManagerProtocol.self) { _ in UserdefaultsManager() }
        container.register(KeyChainWrapperProtocol.self) { _ in KeyChainWrapper() }
        container.register(CoreDataRecipeStorageProtocol.self) { _ in CoreDataRecipeStorage() }
        container.register(LoginViewModelProtocol.self) { _ in LoginViewModel() }
        container.register(RecipeListViewModelProtocol.self) { _ in RecipeListViewModel() }
        container.register(CreateRecipeViewModelProtocol.self) { _ in CreateRecipeViewModel() }
        container.register(RecipeDetailsViewModelProtocol.self) { _ in RecipeDetailsViewModel() }
        container.register(EditRecipeViewModelProtocol.self) { _ in EditRecipeViewModel() }
        
        return container
    }()
    
}
