//
//  ViewController.swift
//  mvvmRickAndMorty
//
//  Created by Макар Тюрморезов on 29.11.2023.
//

import UIKit
import Combine
import MBProgressHUD

class MainViewController: UIViewController {

    // MARK: - UIView
    
   private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainTableHeroesCell.self, forCellReuseIdentifier: MainTableHeroesCell.id)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Private propetries
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public propetries
    
    var viewModel: MainViewModel? {
        didSet {
            guard let viewModel else  { return }
             bind(viewModel: viewModel)
        }
    }
    
    // MARK: - Lifecycle - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    //MARK: - Private method

    private func bind(viewModel: MainViewModel) {
        viewModel.$state.removeDuplicates()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] state in
                        self?.render(state: state)
                    }.store(in: &cancellables)
        viewModel.send(event: .onAppear)
    }
    
    private func render(state: MainViewModel.State) {
        switch state {
            case .idle:
                break
            case .loading:
                MBProgressHUD.showAdded(to: self.view, animated: true)
            case .loaded:
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.reloadData()
                }
            case .error:
                MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

// MARK: - Extention for layout

extension MainViewController {
    private func setupUI() {
        
        view.backgroundColor = .white
        title = "Rick and Morty!"
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
    }
}

// MARK: - Extention for TableView DataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.data?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableHeroesCell.id, for: indexPath) as! MainTableHeroesCell
        let modelForCell =  viewModel?.data?[indexPath.row]
        cell.configure(withModel: modelForCell)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel?.pageNumber != viewModel?.pagesNum.info?.pages && indexPath.row == (viewModel?.data?.count ?? 18) - 2  {
            viewModel?.send(event: .nextPage)
        }
    }
}

// MARK: - Extention for TableView Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.send(event: .onDetailScreen(indexPath.item))
    }
}
