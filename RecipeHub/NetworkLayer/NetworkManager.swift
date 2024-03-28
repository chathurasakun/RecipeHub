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
    case authenticate(credentials: LoginRequest)
    case getRecipeLsit(type: String)
    case saveRecipe(recipe: Recipe)
    case upadateRecipe(recipe: Recipe)
    case deleteRecipe(id: String)
    
    /// Set Method
    var method: HTTPMethod {
        switch self {
        case .authenticate(_):
            return .post
        case .getRecipeLsit(_):
            return .get
        case .saveRecipe(_):
            return .post
        case .upadateRecipe(_):
            return .put
        case .deleteRecipe(_):
            return .delete
        }
    }
    
    /// Set Base URL
    var baseUrl: String {
        return "http://localhost:8080/"
    }
    
    /// End Points
    var endPoint: String {
        switch self {
        case .getRecipeLsit(type: let type):
            return "api/recipes/\(type)"
        case .saveRecipe(_):
            return "api/recipes/create"
        case .authenticate(_):
            return "api/recipes/login"
        case .upadateRecipe(recipe: let recipe):
            if let id = recipe.id {
                return "api/recipes/\(id)"
            }
            return ""
        case .deleteRecipe(id: let id):
            return "api/recipes/\(id)"
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
        case .saveRecipe(recipe: let recipe), .upadateRecipe(recipe: let recipe):
            urlRequest.httpBody = try JSONEncoder().encode(recipe)
        case .authenticate(let credentials):
            urlRequest.httpBody = try JSONEncoder().encode(credentials)
        case .getRecipeLsit(type: _), .deleteRecipe(id: _):
            return try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
