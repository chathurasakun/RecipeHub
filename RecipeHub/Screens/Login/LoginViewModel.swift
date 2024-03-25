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
    var loggedSuccessfully: PassthroughSubject<Bool, Never> { get set }
    func loginUser()
}

class LoginViewModel: LoginViewModelProtocol {
    let apiClient: ApiClientProtocol
    let userDefaults: UserdefaultsManagerProtocol
    let keyChain: KeyChainWrapperProtocol
    var username: String = ""
    var password: String = ""
    var loggedSuccessfully = PassthroughSubject<Bool, Never>()
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
                    self?.loggedSuccessfully.send(false)
                    if let code = error.responseCode {
                        print("code ", code)
                    }
                    if error.isSessionTaskError {
                        print("session Tak error")
                    }
                    if error.isResponseSerializationError {
                        print("serialization error")
                    }
                case .finished:
                    self?.loggedSuccessfully.send(true)
                    break
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
