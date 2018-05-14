//
//  LoginViewModelTests.swift
//  RxDemoTests
//
//  Created by Jean-Michel Barbieri on 5/13/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

@testable import RxDemo
import XCTest
import RxTest
import RxSwift

class LanguageListViewModelTests: XCTestCase {
    var testScheduler: TestScheduler!
    var bag: DisposeBag!
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        
        testScheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()
        viewModel = LoginViewModel()
    }
    
    func test_Enter_Username_Password_Enable_Login_Button() {
        testScheduler.createHotObservable([Recorded.next(300, "Username")])
            .bind(to: viewModel.setUsername)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(400, "Password")])
            .bind(to: viewModel.setPassword)
            .disposed(by: bag)
        
        let result = testScheduler.start { self.viewModel.loginButtonEnabled }
        XCTAssertEqual(result.events, [Recorded.next(400, true)])
    }
    
    func test_Enter_Username_Password_Disable_Login_Button() {
        testScheduler.createHotObservable([Recorded.next(300, "Username")])
            .bind(to: viewModel.setUsername)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(400, "Password")])
            .bind(to: viewModel.setPassword)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(500, "")])
            .bind(to: viewModel.setPassword)
            .disposed(by: bag)
        
        let result = testScheduler.start { self.viewModel.loginButtonEnabled }
        XCTAssertEqual(result.events, [Recorded.next(400, true), Recorded.next(500, false)])
    }
    
    func test_Click_Login_Triggers_Display_of_Loading_view() {
        testScheduler.createHotObservable([Recorded.next(300, "Username")])
            .bind(to: viewModel.setUsername)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(400, "Password")])
            .bind(to: viewModel.setPassword)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(600, ())])
            .bind(to: viewModel.loginAttempt)
            .disposed(by: bag)
        
        viewModel.loginResult.subscribe().disposed(by: bag)
        
        let result = testScheduler.start { self.viewModel.loadingHidden }
        XCTAssertEqual(result.events, [Recorded.next(200, true), Recorded.next(600, false)])
    }
    
    func test_Click_Login_Triggers_Changing_Text_in_LoadingView() {
        testScheduler.createHotObservable([Recorded.next(300, "Username")])
            .bind(to: viewModel.setUsername)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(400, "Password")])
            .bind(to: viewModel.setPassword)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(600, ())])
            .bind(to: viewModel.loginAttempt)
            .disposed(by: bag)
        
        viewModel.loginResult.subscribe().disposed(by: bag)
        
        let result = testScheduler.start { self.viewModel.loadingText }
        XCTAssertEqual(result.events, [Recorded.next(200, ""), Recorded.next(600, "Authenticating")])
    }

    func test_Click_Login_Shows_and_Hide_LoadingView() {
        testScheduler.createHotObservable([Recorded.next(300, "Username")])
            .bind(to: viewModel.setUsername)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(400, "Password")])
            .bind(to: viewModel.setPassword)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(600, ())])
            .bind(to: viewModel.loginAttempt)
            .disposed(by: bag)
        
        viewModel.loginResult.subscribe().disposed(by: bag)
        
        _ = testScheduler.start { self.viewModel.loadingHidden }
        let expectation1 = expectation(description: "Wait for completiong")
        var expectedResult = [Bool]()
        
        /// There must be a better way to write this test (instead of using waitForExpecation)
        self.viewModel.loadingHidden.subscribe(onNext: { val in
            expectedResult.append(val)
            if expectedResult.count == 2 {
                expectation1.fulfill()
            }
        }).disposed(by: self.bag)
        
        waitForExpectations(timeout: 2) { error in
             XCTAssertEqual(expectedResult, [false, true])
        }
    }
}
