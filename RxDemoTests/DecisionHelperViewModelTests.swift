//
//  DecisionHelperViewModelTests.swift
//  RxDemoTests
//
//  Created by Jean-Michel Barbieri on 5/13/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

@testable import RxDemo
import XCTest
import RxTest
import RxSwift

class DecisionHelperViewModelTests: XCTestCase {
    
    var testScheduler: TestScheduler!
    var bag: DisposeBag!
    var viewModel: DecisionHelperViewModel!
    
    override func setUp() {
        super.setUp()
        
        testScheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()
        viewModel = DecisionHelperViewModel()
    }
    
    func test_When_2_Options_Are_Selected_Happy_Is_The_Result() {
        testScheduler.createHotObservable([Recorded.next(300, true)])
            .bind(to: viewModel.setDuringWeekend)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(400, true)])
            .bind(to: viewModel.setGoodWeather)
            .disposed(by: bag)
        
        let result = testScheduler.start { self.viewModel.imageTitle }
        XCTAssertEqual(result.events, [Recorded.next(200, "sad"),
                                       Recorded.next(300, "sad"),
                                       Recorded.next(400, "happy")])
    }
    
    func test_Sad_Happy_Sad_Switch() {
        testScheduler.createHotObservable([Recorded.next(300, true)])
            .bind(to: viewModel.setDuringWeekend)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(400, true)])
            .bind(to: viewModel.setGoodWeather)
            .disposed(by: bag)
        
        testScheduler.createHotObservable([Recorded.next(500, false)])
            .bind(to: viewModel.setDuringWeekend)
            .disposed(by: bag)
        
        let result = testScheduler.start { self.viewModel.imageTitle }
        XCTAssertEqual(result.events, [Recorded.next(200, "sad"),
                                       Recorded.next(300, "sad"),
                                       Recorded.next(400, "happy"),
                                       Recorded.next(500, "sad")])
    }
}
