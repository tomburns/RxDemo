//
//  DecisionHelperCoordinator.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/12/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa

enum DecisionHelperCoordinatorResult {
    case logout()
}

class DecisionHelperCoordinator: BaseCoordinator<DecisionHelperCoordinatorResult> {
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<DecisionHelperCoordinatorResult> {
        let viewModel = DecisionHelperViewModel()
        let loginViewController = DecisionHelperViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        
        rootViewController.present(navigationController, animated: true)
        
        return viewModel.didLogout
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
            .map { DecisionHelperCoordinatorResult.logout() }
    }
}
