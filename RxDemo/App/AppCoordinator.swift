//
//  AppCoordinator.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/11/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    fileprivate let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let loginCoordinator = LoginCoordinator(window: window)
        return coordinate(to: loginCoordinator)
    }
}
