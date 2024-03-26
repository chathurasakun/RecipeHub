//
//  KeyChainMock.swift
//  RecipeHubTests
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

@testable import RecipeHub

class KeyChainMock: KeyChainWrapperProtocol {
    var shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func save(_ value: String, forKey key: String) {
        let _ : Bool = true
    }
    
    func loadValue(forKey key: String) -> String? {
        if shouldSucceed {
            let savedValue: String = "testValue"
            return savedValue
        } else {
            return nil
        }
    }
    
    func update(_ value: String, forKey key: String) -> Bool {
        let isSuccess: Bool = true
        return isSuccess
    }
    
    func deleteValue(forKey key: String) {
        let _ : Bool = true
    }
}
