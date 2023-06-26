//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Алексей Голованов on 28.05.2023.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    
    private let widthHeightAnchor = (UIScreen.main.bounds.width - 48) / 4
    
    static let id = "PhotosTableViewCell"
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 1
        label.text = "Фотографии"
        return label
    }()
    
    private let nextImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.forward")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var photoStack: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        let arrayPhotos = makePhotos()
        for index in 0...3 {
            let imageView: UIImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage(named: arrayPhotos[index])
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 6
                return imageView
            }()
            stackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalToConstant: widthHeightAnchor)]
            )
        }
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    
    private func addSubviews() {
        [photoLabel,
         nextImage,
         photoStack
        ].forEach({contentView.addSubview($0)})
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            photoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            nextImage.centerYAnchor.constraint(equalTo: photoLabel.centerYAnchor),
            nextImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            photoStack.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 12),
            photoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            photoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            photoStack.heightAnchor.constraint(equalToConstant: widthHeightAnchor)
        ])
    }
}

