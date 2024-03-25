//
//  UserdefaultsManager.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

import Foundation

protocol UserdefaultsManagerProtocol {
    func setUserLoggedStatus(logged: Bool)
    func getUserLoggedStatus() -> Bool
}

class UserdefaultsManager: UserdefaultsManagerProtocol {
    private let defaults: UserDefaults!
    
    init() {
        defaults = UserDefaults.standard
    }
    
    func setUserLoggedStatus(logged: Bool) {
        defaults.set(logged, forKey: "userLoginStatus")
    }
    
    func getUserLoggedStatus() -> Bool {
        return defaults.bool(forKey: "userLoginStatus")
    }
}
