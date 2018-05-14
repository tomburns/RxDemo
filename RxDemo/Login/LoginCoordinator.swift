//
//  LoginCoordinator.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/11/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginCoordinator: BaseCoordinator<Void> {
    fileprivate let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        viewModel.loginResult
            .filter { $0 }
            .flatMap { [weak self] _ -> Observable<String> in
                guard let `self` = self else { return .empty() }
                return self.showDecisionHelper(on: loginViewController)
            }
            .bind(to: viewModel.setlogoutMsg)
            .disposed(by: bag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showDecisionHelper(on rootViewController: UIViewController) -> Observable<String> {
        let decisionHelperCoordinator = DecisionHelperCoordinator(rootViewController: rootViewController)
        return coordinate(to: decisionHelperCoordinator)
            .map { _ in "Have a good day!" }
    }
}
