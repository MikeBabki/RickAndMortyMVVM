//
//  Coordinato.swift
//  mvvmRickAndMorty
//
//  Created by Макар Тюрморезов on 03.12.2023.
//

import Foundation
import UIKit

final class MainFlowController: UINavigationController {
    
    // MARK: - Public methods
    
    func goToDetailScreen(_ heroName: String) {
        let detailView = DetailInfoVeiwController()
        let detailViewModel = DetailHeroViewModel(name: heroName, service: NetworkManager())
        detailView.viewModel = detailViewModel
        let backButton = UIBarButtonItem(title: self.title, style: .plain, target: nil, action: nil)
        backButton.tintColor = .black
        self.navigationBar.topItem?.backBarButtonItem = backButton
        self.pushViewController(detailView, animated: true)
    }
    
    // MARK: - Private methods
    
    private func goToMainScreen() {
        let mainView = MainViewController()
        let viewModel = MainViewModel(service: NetworkManager(), coordinatorController: self)
        mainView.viewModel  = viewModel
        self.navigationBar.prefersLargeTitles = true
        self.pushViewController(mainView, animated: false)
        
    }
    
    // MARK: - Init
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        goToMainScreen()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
