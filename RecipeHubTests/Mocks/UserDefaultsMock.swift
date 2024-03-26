//
//  UserDefaultsMock.swift
//  RecipeHubTests
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

@testable import RecipeHub

class UserDefaultsMock: UserdefaultsManagerProtocol {
    var shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func setUserLoggedStatus(logged: Bool) {
        let _ : Bool = true
    }
    
    func getUserLoggedStatus() -> Bool {
        if shouldSucceed {
            let loggedStatus: Bool = true
            return loggedStatus
        } else {
            return false
        }
    }
}
