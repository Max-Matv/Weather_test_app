//
//  SceneDelegate.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 8.12.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
   
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let viewController = CurrentWeatherViewController()
        viewController.viewModel = CurrentWeatherViewModel(viewController: viewController)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
    }


}

