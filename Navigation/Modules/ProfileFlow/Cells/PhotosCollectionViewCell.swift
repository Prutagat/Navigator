//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Алексей Голованов on 30.05.2023.
//

import UIKit
import iOSIntPackage

final class PhotosCollectionViewCell: UICollectionViewCell {
    
    static let id = "PhotosCollectionViewCell"
    
    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray
        setupSubviews()
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // MARK: - Public
    
    func setup(nameImage: String) {
        imageView.image = UIImage(named: nameImage)
    }
    
    func setup(image: UIImage) {
        imageView.image = image
    }
    
    func setup(nameImage: String, pablisher: ImagePublisherFacade) {
        let image = UIImage(named: nameImage)
        pablisher.addImagesWithTimer(time: 2.5, repeat: 10, userImages: [image!])
        imageView.image = image
    }
}
