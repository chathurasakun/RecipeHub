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
    private var cancellable: AnyCancellable?
    var loginSuccess: Bool!

    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        apiClientMock = nil
        keyChainMock = nil
        userDefaultsMock = nil
    }
    
    // Login Success
    func test_UserLoginSuccesspath() {
        apiClientMock = ApiClientMock(shouldSucceed: true)
        keyChainMock = KeyChainMock(shouldSucceed: true)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: true)
        sut = LoginViewModel(apiClient: apiClientMock, userDefaults: userDefaultsMock,
                             keyChain: keyChainMock)
        
        let expectation = expectation(description: "Recieve login response expectation")
        cancellable = sut.apiClient.loginUser(route: .authenticate(credentials: mockUser))
            .sink(receiveCompletion: { recievedCompletion in
                switch recievedCompletion {
                case .finished:
                    XCTAssertEqual(recievedCompletion, .finished)
                case .failure(_):
                    break
                }
                expectation.fulfill()
            }, receiveValue: { [weak self] loginResponse in
                let keyChainToken = self?.keyChainMock.loadValue(forKey: KeyChainKeys.tokenKey)
                XCTAssertEqual(loginResponse.token, keyChainToken)
                XCTAssertNotNil(loginResponse.token)

                let loggedStatus = self?.userDefaultsMock.getUserLoggedStatus()
                XCTAssertTrue((loggedStatus != nil))
            })

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // Login Failed
    func test_UserLoginFailpath() {
        apiClientMock = ApiClientMock(shouldSucceed: false)
        keyChainMock = KeyChainMock(shouldSucceed: false)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: false)
        sut = LoginViewModel(apiClient: apiClientMock, userDefaults: userDefaultsMock,
                             keyChain: keyChainMock)
        
        let expection = expectation(description: "Recieve login error response expectation")
        cancellable = sut.apiClient.loginUser(route: .authenticate(credentials: mockUser))
            .sink(receiveCompletion: { recievedCompletion in
                switch recievedCompletion {
                case .failure(let error):
                    let networkError = NSError(domain: "Error", code: 200,
                                        userInfo: [NSLocalizedDescriptionKey: "session task error"])
                    XCTAssertEqual(error, AFError.sessionTaskFailed(error: networkError))
                    XCTAssertNotNil(error.errorDescription)
                case .finished:
                    break
                }
                expection.fulfill()
            }, receiveValue: { _ in })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // Send through after login success
    func test_SendTrueAfterLoginSuccess() {
        apiClientMock = ApiClientMock(shouldSucceed: true)
        keyChainMock = KeyChainMock(shouldSucceed: true)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: true)
        sut = LoginViewModel(apiClient: apiClientMock, userDefaults: userDefaultsMock,
                             keyChain: keyChainMock)

        sut.loginUser()

        cancellable = sut.loggedSuccessfully
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            }, receiveValue: { [weak self] recievedValue in
                XCTAssertEqual(recievedValue, true)
                self?.loginSuccess = recievedValue
            })
    }

    // login fail
    func test_SendFaliureAfterLoginFailed() {
        apiClientMock = ApiClientMock(shouldSucceed: false)
        keyChainMock = KeyChainMock(shouldSucceed: false)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: false)
        sut = LoginViewModel(apiClient: apiClientMock, userDefaults: userDefaultsMock,
                             keyChain: keyChainMock)

        sut.loginUser()

        cancellable = sut.loggedSuccessfully
            .sink(receiveCompletion: { recivedCompletion in
                switch recivedCompletion {
                case .failure(let error):
                    XCTAssertNil(recivedCompletion)
                    XCTAssertEqual(error as! AFError, AFError.explicitlyCancelled)
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                
            })
    }

}
