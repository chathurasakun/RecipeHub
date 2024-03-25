//
//  KeyChainManger.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

import Foundation

enum KeyChainKeys {
    static let tokenKey = "com.chathura.RecipeHub.token"
}

protocol KeyChainWrapperProtocol {
    func save(_ value: String, forKey key: String)
    func loadValue(forKey key: String) -> String?
    func update(_ value: String, forKey key: String) -> Bool
    func deleteValue(forKey key: String)
}

class KeyChainWrapper: KeyChainWrapperProtocol {
    func save(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            // Delete existing item before saving
            deleteValue(forKey: key)
            
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    func loadValue(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func update(_ value: String, forKey key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]
            
            let updateFields: [String: Any] = [
                kSecValueData as String: data
            ]
            
            let status = SecItemUpdate(query as CFDictionary, updateFields as CFDictionary)
            return status == errSecSuccess
        }
        return false
    }
    
    func deleteValue(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
