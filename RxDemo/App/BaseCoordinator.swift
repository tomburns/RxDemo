//
//  BaseCoordinator.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/11/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import Foundation
import RxSwift

protocol Coordinator {
    associatedtype CoordinatorResultType
    func start() -> Observable<CoordinatorResultType>
}

class BaseCoordinator<CoordinatorResultType>: Coordinator {
    let bag = DisposeBag()
    
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    func start() -> Observable<CoordinatorResultType> {
        fatalError("Start method should be implemented.")
    }
    
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.free(coordinator: coordinator)
            }
        )
    }
}
