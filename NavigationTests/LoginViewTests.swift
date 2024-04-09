//
//  LoginViewTests.swift
//  NavigationTests
//
//  Created by Алексей Голованов on 19.02.2024.
//

import XCTest
@testable import Navigation

final class LoginViewTests: XCTestCase {

    var authorizationHelper: AuthorizationHelperMock?
    var authorizationService: AuthorizationService?
    var workItem: DispatchWorkItem?
    var resultAutorization: String?
    var resultChoosePassword: String?
    
    override func setUp() {
        super.setUp()
        authorizationHelper = AuthorizationHelperMock()
        authorizationService = AuthorizationService()
        authorizationService?.loginDelegate = MyLoginFactory().makeLoginInspector()
        authorizationService?.authorizationHelper = authorizationHelper
        authorizationService?.workItem = workItem
    }
    
    func testLogIn() {
        let expectation = expectation(description: "Alert displayed")
        authorizationHelper?.resultAutorization = { result in
            self.resultAutorization = result
            expectation.fulfill()
        }
        
        authorizationService?.logIn(login: "a.v.golovanov@icloud.com", password: "Ghbdtn1324")
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(resultAutorization, "correct")
        
//        authorizationService?.logIn(login: "login", password: "password")
//        waitForExpectations(timeout: 5.0)
//        XCTAssertEqual(resultAutorization, "correct")
    }

    func testSignUp() {
        let expectation = expectation(description: "Alert displayed")
        authorizationHelper?.resultAutorization = { result in
            self.resultAutorization = result
            expectation.fulfill()
        }
        
        authorizationService?.signUp(login: "testUser@mail.ru", password: "TestPassword")
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(resultAutorization, "correct")
    }
    
    func testChoosePassword() {
        
        let expectation = expectation(description: "Alert displayed")
        authorizationHelper?.resultChoosePassword = { result in
            self.resultChoosePassword = result
            expectation.fulfill()
        }
        
        authorizationService?.choosePassword(password: "true")
        waitForExpectations(timeout: 180.0)
        XCTAssertEqual(resultChoosePassword, "true")
    }
}
