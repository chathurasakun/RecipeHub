//
//  NetworkManager.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import Foundation
import Alamofire

protocol ApiConfiguartion: URLRequestConvertible {
    var method: HTTPMethod { get }
    var baseUrl: String { get }
    var endPoint: String { get }
    var parameters: Parameters? { get }
    
    func asURLRequest() throws -> URLRequest
}

enum APIRouter: ApiConfiguartion {
//    case authenticate(credentials: LoginRequest)
    case getRecipeLsit(type: String)
    case saveRecipe(recipe: Recipe)
    
    /// Set Method
    var method: HTTPMethod {
        switch self {
        case .getRecipeLsit(_):
            return .get
        case .saveRecipe(_):
            return .post
        }
    }
    
    /// Set Base URL
    var baseUrl: String {
        return "https://dummyjson.com/"
    }
    
    /// End Points
    var endPoint: String {
        switch self {
        case .getRecipeLsit(type: let type):
            return "recipes/meal-type/\(type)"
        case .saveRecipe(_):
            return "recipes/save"
//        case .authenticate(_):
//            return "auth/login"
        }
    }
    
    /// Parameters
    var parameters: Parameters? {
        return nil
    }
    
    /// URLRequest Convertible
    func asURLRequest() throws -> URLRequest {
        let fullPath = baseUrl + endPoint
        let url = try fullPath.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
    
        switch self {
        case .saveRecipe(recipe: let recipe):
            urlRequest.httpBody = try JSONEncoder().encode(recipe)
//        case .authenticate(let credentials):
//            urlRequest.httpBody = try JSONEncoder().encode(credentials)
        case .getRecipeLsit(type: _):
            return try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
