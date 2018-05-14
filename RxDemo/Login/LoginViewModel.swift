//
//  LoginViewModel.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/11/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    // MARK: - INPUTS (Coming from the VC or the Coordinator)
    
    /// Username textfield observer
    let setUsername: AnyObserver<String>
    
    /// Password textfield observer
    let setPassword: AnyObserver<String>
    
    /// Login button observer
    let loginAttempt: AnyObserver<Void>
    
    /// Logout message observer
    let setlogoutMsg: AnyObserver<String>
    
    // MARK: - OUTPUTS
    
    /// Login click action observable
    let loginResult: Observable<Bool>
    
    /// Login button enabled observable
    let loginButtonEnabled: Observable<Bool>
    
    /// Loading view hidden observable
    let loadingHidden: Observable<Bool>
    
    /// Loading view text observable
    let loadingText: Observable<String>
    
    /// Loading view text observable
    let logoutMsg: Observable<String>
    
    init() {
        let _login = PublishSubject<Void>()
        self.loginAttempt = _login.asObserver()
        
        let _logoutMsg = PublishSubject<String>()
        self.setlogoutMsg = _logoutMsg.asObserver()
        self.logoutMsg = _logoutMsg
        
        let _username = PublishSubject<String>()
        self.setUsername = _username.asObserver()
        
        let _password = PublishSubject<String>()
        self.setPassword = _password.asObserver()
        
        self.loginButtonEnabled = Observable.combineLatest(_username, _password) { username, password in
            return username.count > 0 && password.count > 0
        }
        
        let _loadingHidden = BehaviorSubject<Bool>(value: true)
        self.loadingHidden = _loadingHidden.asObservable()
        
        let _loadingText = BehaviorSubject<String>(value: "")
        self.loadingText = _loadingText.asObservable()
        
        self.loginResult = _login
            .do(onNext: { _ in
                _loadingHidden.onNext(false)
                _loadingText.onNext("Authenticating")
            })
            .delay(1, scheduler: MainScheduler.instance)
            .do(onNext: { _ in
                _loadingHidden.onNext(true)
            })
            .map { true }
    }
}
