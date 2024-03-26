//
//  RecipeViewModelTests.swift
//  RecipeHubTests
//
//  Created by CHATHURA ELLAWALA on 2024-03-26.
//

@testable import RecipeHub
import XCTest
import Combine

class RecipeViewModelTests: XCTestCase {
    var sut: RecipeListViewModel!
    var apiClientMock: ApiClientMock!
    var userDefaultsMock: UserdefaultsManagerProtocol!
    var keyChainMock: KeyChainWrapperProtocol!
    var coreDataStorageMock: CoreDataRecipeStorageProtocol!
    var mealType: String = "Dinner"
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        apiClientMock = nil
        userDefaultsMock = nil
        keyChainMock = nil
        coreDataStorageMock = nil
    }
    
    // Get Recipe List Success Test
    func test_SendGetRecipeRequestToServerSuccesspath() {
        apiClientMock = ApiClientMock(shouldSucceed: true)
        keyChainMock = KeyChainMock(shouldSucceed: true)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: true)
        coreDataStorageMock = CoreDataStorageMock()
        sut = RecipeListViewModel(apiClient: apiClientMock, coreDataStorage: coreDataStorageMock, userDefaults: userDefaultsMock, keyChain: keyChainMock)
        
        sut.apiClient.getRecipeList(route: .getRecipeLsit(type: mealType))
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] response in
                print(response)
            })
            .store(in: &cancellables)
    }
    
    // Get Recipe List Failure Test
    func test_SendGetRecipeRequestToServerFailurepath() {
        apiClientMock = ApiClientMock(shouldSucceed: false)
        keyChainMock = KeyChainMock(shouldSucceed: false)
        userDefaultsMock = UserDefaultsMock(shouldSucceed: false)
        coreDataStorageMock = CoreDataStorageMock()
        sut = RecipeListViewModel(apiClient: apiClientMock, coreDataStorage: coreDataStorageMock, userDefaults: userDefaultsMock, keyChain: keyChainMock)
        
        sut.apiClient.getRecipeList(route: .getRecipeLsit(type: mealType))
            .sink(receiveCompletion: { recievedCompletion in
                switch recievedCompletion {
                case .finished:
                    break
                case .failure(_):
                    XCTAssertEqual(recievedCompletion, .failure(.explicitlyCancelled))
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &cancellables)
    }
}
