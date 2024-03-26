//
//  LoginViewModelTests.swift
//  RecipeHubTests
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

import XCTest
import Combine
import Alamofire
@testable import RecipeHub

extension AFError: Equatable {
    public static func == (lhs: AFError, rhs: AFError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    var apiClientMock: ApiClientMock!
    var keyChainMock: KeyChainMock!
    var userDefaultsMock: UserDefaultsMock!
    let mockUser = LoginRequest(username: "test", password: "test")
    private var cancellables: Set<AnyCancellable> = []
    var completion: Subscribers.Completion<Error>?
    var token: String?
    var value: Bool?

    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        apiClientMock = nil
        keyChainMock = nil
        userDefaultsMock = nil
        completion = nil
        token = nil
        value = nil
    }
    
    // Login Success
    func test_UserLoginSuccesspath() {
        apiClientMock = ApiClientMock(shouldSucceed: true)
        keyChainMock = KeyChainMock(shouldSucceed: true)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: true)
        sut = LoginViewModel(apiClient: apiClientMock, userDefaults: userDefaultsMock,
                             keyChain: keyChainMock)
        
        sut.apiClient.loginUser(route: .authenticate(credentials: mockUser))
            .sink(receiveCompletion: { recievedCompletion in
                switch recievedCompletion {
                case .finished:
                    XCTAssertEqual(recievedCompletion, .finished)
                case .failure(_):
                    break
                }
            }, receiveValue: { [weak self] response in
                print("Erased Received value:", response)
                self?.token = response.token
            })
            .store(in: &cancellables)
        
        let keyChainToken = keyChainMock.loadValue(forKey: KeyChainKeys.tokenKey)
        XCTAssertEqual(token, keyChainToken)
        XCTAssertNotNil(token)

        let loggedStatus = userDefaultsMock.getUserLoggedStatus()
        XCTAssertTrue(loggedStatus)
    }
    
    // Login Failed
    func test_UserLoginFailpath() {
        apiClientMock = ApiClientMock(shouldSucceed: false)
        keyChainMock = KeyChainMock(shouldSucceed: false)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: false)
        sut = LoginViewModel(apiClient: apiClientMock, userDefaults: userDefaultsMock,
                             keyChain: keyChainMock)
        
        sut.apiClient.loginUser(route: .authenticate(credentials: mockUser))
            .sink{ recievedCompletion in
                switch recievedCompletion {
                case .failure(let error):
                    XCTAssertEqual(error, .explicitlyCancelled)
                    XCTAssertNotNil(error.errorDescription)
                case .finished:
                    break
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)

        let loggedStatus = userDefaultsMock.getUserLoggedStatus()
        XCTAssertFalse(loggedStatus)
        
        let token = keyChainMock.loadValue(forKey: KeyChainKeys.tokenKey)
        XCTAssertNil(token)
    }
    
    // Send through after login success
    func test_SendTrueAfterLoginSuccess() {
        apiClientMock = ApiClientMock(shouldSucceed: true)
        keyChainMock = KeyChainMock(shouldSucceed: true)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: true)
        sut = LoginViewModel(apiClient: apiClientMock, userDefaults: userDefaultsMock,
                             keyChain: keyChainMock)

        sut.loginUser()

        sut.loggedSuccessfully
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] recievedValue in
                self?.value = recievedValue
            })
            .store(in: &cancellables)

        XCTAssertEqual(value, true)
    }
    
    // login fail
    func test_SendFaliureAfterLoginFailed() {
        apiClientMock = ApiClientMock(shouldSucceed: false)
        keyChainMock = KeyChainMock(shouldSucceed: false)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: false)
        sut = LoginViewModel(apiClient: apiClientMock, userDefaults: userDefaultsMock,
                             keyChain: keyChainMock)
        
        sut.loginUser()
        
        sut.loggedSuccessfully
            .sink(receiveCompletion: { [weak self] recivedCompletion in
                switch recivedCompletion {
                case .failure(_):
                    self?.completion = recivedCompletion
                case .finished:
                    break
                }
            }, receiveValue: { _ in

            })
            .store(in: &cancellables)
        
        XCTAssertNil(completion)
    }

}
