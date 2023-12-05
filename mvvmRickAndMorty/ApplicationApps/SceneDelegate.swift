//
//  SceneDelegate.swift
//  mvvmRickAndMorty
//
//  Created by Макар Тюрморезов on 29.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinateController: MainFlowController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        coordinateController = MainFlowController()
        window?.rootViewController = coordinateController
        window?.makeKeyAndVisible()
    }
}

