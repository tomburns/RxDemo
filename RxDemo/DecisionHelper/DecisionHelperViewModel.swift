//
//  DecisionHelperViewModel.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/12/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DecisionHelperViewModel {
    // MARK: - INPUTS (Coming from the VC or the Coordinator)
    let logout: AnyObserver<Void>
    
    let setFamillyDinner: AnyObserver<Bool>
    let setGoodWeather: AnyObserver<Bool>
    let setDuringWeekend: AnyObserver<Bool>
    
    // MARK: - OUTPUTS
    let imageTitle: Observable<String>
    let didLogout: Observable<Void>
    
    init() {
        let _logout = PublishSubject<Void>()
        self.logout = _logout.asObserver()
        self.didLogout = _logout.asObservable()
        
        let _familly = PublishSubject<Bool>()
        self.setFamillyDinner = _familly.asObserver()
        
        let _weather = PublishSubject<Bool>()
        self.setGoodWeather = _weather.asObserver()
        
        let _weekend = PublishSubject<Bool>()
        self.setDuringWeekend = _weekend.asObserver()
        
        let family = _familly.startWith(false)
        let weather = _weather.startWith(false)
        let weekend = _weekend.startWith(false)
        
        self.imageTitle = Observable
            .combineLatest(family, weather, weekend)
            .map { [$0, $1, $2] }
            .map { $0.filter { $0 }.count >= 2 ? "happy": "sad" }
    }
}
