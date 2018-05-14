//
//  AppDelegate.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/11/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
            .subscribe()
            .disposed(by: DisposeBag())
        return true
    }
}

