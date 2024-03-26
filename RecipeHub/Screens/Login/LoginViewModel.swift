//
//  LoginViewModel.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

import Swinject
import Combine

protocol LoginViewModelProtocol {
    var username: String { get set }
    var password: String { get set }
    var loggedSuccessfully: PassthroughSubject<Bool, Error> { get set }
    func loginUser()
}

class LoginViewModel: LoginViewModelProtocol {
    let apiClient: ApiClientProtocol
    let userDefaults: UserdefaultsManagerProtocol
    let keyChain: KeyChainWrapperProtocol
    var username: String = ""
    var password: String = ""
    var loggedSuccessfully = PassthroughSubject<Bool, Error>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ApiClientProtocol = Container.sharedDIContainer.resolve(ApiClientProtocol.self)!,
         userDefaults: UserdefaultsManagerProtocol = Container.sharedDIContainer.resolve(UserdefaultsManagerProtocol.self)!,
         keyChain: KeyChainWrapperProtocol = Container.sharedDIContainer.resolve(KeyChainWrapperProtocol.self)!
    ) {
        self.apiClient = apiClient
        self.userDefaults = userDefaults
        self.keyChain = keyChain
    }
    
    func loginUser() {
        let authObject = LoginRequest(username: username, password: password)
        apiClient.loginUser(route: .authenticate(credentials: authObject))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    guard let code = error.responseCode else {
                        return
                    }
                    if let errorMsg = error.errorDescription {
                        let error = NSError(domain: "Network Error", code: code,
                                            userInfo: [NSLocalizedDescriptionKey: errorMsg])
                        self?.loggedSuccessfully.send(completion: .failure(error))
                    }
                case .finished:
                    self?.loggedSuccessfully.send(true)
                }
            } receiveValue: { [weak self] response in
                guard let token = response.token else {
                    return
                }
                self?.keyChain.save(token, forKey: KeyChainKeys.tokenKey)
                self?.userDefaults.setUserLoggedStatus(logged: true)
            }
            .store(in: &cancellables)
    }
}
