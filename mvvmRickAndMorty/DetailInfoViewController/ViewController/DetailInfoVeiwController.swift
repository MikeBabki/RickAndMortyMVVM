//
//  DetailInfoVc.swift
//  mvvmRickAndMorty
//
//  Created by Макар Тюрморезов on 02.12.2023.
//

import Foundation
import UIKit
import Combine
import Kingfisher
import MBProgressHUD

class DetailInfoVeiwController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var heroName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private lazy var status: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private lazy var species: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private lazy var type: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private lazy var gender: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private lazy var origin: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private lazy var location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var heroImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var mainStackViewWithIncludedStacks: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fill
        return stack
    }()
    private lazy var heroDescriptionStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalCentering
        return stack
    }()
    
    private lazy var contentView: UIView = {
        let contentview = UIStackView()
        contentview.translatesAutoresizingMaskIntoConstraints = false
        return contentview
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
   
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public properties
    
    var viewModel: DetailHeroViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            bind(viewModel: viewModel)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func bind(viewModel: DetailHeroViewModel) {
        viewModel.$state.removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state: state)
            }.store(in: &cancellables)
        viewModel.send(event: .onAppear)
    }
    
    private func render(state: DetailHeroViewModel.State) {
        switch state {
        case .idle:
            break
        case .loading:
            MBProgressHUD.showAdded(to: self.view, animated: true)
        case .loaded(let data):
            MBProgressHUD.hide(for: self.view, animated: true)
            configure(withModel: data)
        case .error:
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func configure(withModel model: CharactersModel) {
        heroName.text = "Name - \(model.results?[0].name ?? "Unknown")"
        status.text = "Status - \(model.results?[0].status ?? "Unknown")"
        species.text = "Race - \(model.results?[0].species ?? "Unknown")"
        type.text = "Type - \(model.results?[0].type ?? "Unknown")"
        if model.results?[0].type == "" {
            type.text = "Type - Unknown"
        }
        gender.text = "Gender - \(model.results?[0].gender ?? "Unknown")"
        origin.text = "Number episodes - \(model.results?[0].origin.name?.count ?? 0)"
        location.text = "Last location - \(model.results?[0].location.name ?? "Unknown")"
        
        if let url = URL(string: model.results?[0].image ?? "") {
            heroImage.kf.indicatorType = .activity
            heroImage.kf.setImage(with: url)
        }
        else {
            heroImage.image = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
        }
    }
}

// MARK: - Setup UI

extension DetailInfoVeiwController {
    
    func setupUI() {
        view.backgroundColor = .white
        heroImage.layer.cornerRadius = 10
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(heroImage)
        contentView.addSubview(mainStackViewWithIncludedStacks)
        
        heroDescriptionStackView.addArrangedSubview(heroName)
        heroDescriptionStackView.addArrangedSubview(status)
        heroDescriptionStackView.addArrangedSubview(species)
        heroDescriptionStackView.addArrangedSubview(type)
        heroDescriptionStackView.addArrangedSubview(gender)
        heroDescriptionStackView.addArrangedSubview(origin)
        heroDescriptionStackView.addArrangedSubview(location)
        
        mainStackViewWithIncludedStacks.addArrangedSubview(heroDescriptionStackView)
        
        NSLayoutConstraint.activate([
            
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            heroImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            heroImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            heroImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            mainStackViewWithIncludedStacks.centerXAnchor.constraint(equalTo: heroImage.centerXAnchor),
            mainStackViewWithIncludedStacks.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: 16),
            mainStackViewWithIncludedStacks.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackViewWithIncludedStacks.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackViewWithIncludedStacks.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

