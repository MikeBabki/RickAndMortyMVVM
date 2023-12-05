//
//  CharactersTableViewCell.swift
//
//  Created by Макар Тюрморезов on 02.12.2023.
//

import Foundation
import UIKit
import Kingfisher

final class MainTableHeroesCell: UITableViewCell {
    //Mark: - PrivatePropetries
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    private lazy var race: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    private lazy var gender: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    private lazy var smallDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.layer.cornerRadius = image.frame.height / 2
    }

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

extension MainTableHeroesCell {
    
    static var id: String  = "charsIdCell"
    func configure(withModel model: CharacterSet?) {
        self.image.layer.cornerRadius = 10
        selectionStyle = .none
        self.name.text = model?.name
        self.gender.text = model?.gender
        self.race.text = model?.species
        if let url = URL(string: model?.image ?? "") {
            self.image.kf.indicatorType = .activity
            self.image.kf.setImage(with: url)
        }
        else {
            self.image.image = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
        }
    }
    
    // MARK: - Setup Cell
    
    func setupUI() {
        
        addSubview(name)
        addSubview(race)
        addSubview(gender)
        addSubview(image)

        NSLayoutConstraint.activate([
        
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            image.widthAnchor.constraint(equalToConstant: 90),
            image.heightAnchor.constraint(equalToConstant: 90),
            
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            race.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            race.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 6),
            
            gender.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            gender.topAnchor.constraint(equalTo: race.bottomAnchor, constant: 6),
            
            contentView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
