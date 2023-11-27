//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Алексей Голованов on 24.05.2023.
//

import UIKit
import StorageService
import iOSIntPackage

final class PostTableViewCell: UITableViewCell {
    
    private var postModel: PostModel?
    static let id = "PostTableViewCell"
    
    // MARK: - Subviews
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private let imagePost: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    // MARK: - Action
    
    @objc private func didDoubleTapOnPost(recognizer: UITapGestureRecognizer) {
        let coreDataService = CoreDataService.shared
        
        if let post = postModel {
            let result = coreDataService.savePost(post: post)
            if result {
                postModel!.favorite = !post.favorite
            }
        }
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        [authorLabel,
         imagePost,
         descriptionLabel,
         likesLabel,
         viewsLabel].forEach({contentView.addSubview($0)})
    }
    
    func configure(with post: StorageService.OldPostModel) {
        authorLabel.text = post.author
        descriptionLabel.text = post.description
        ImageProcessor().processImage(sourceImage: UIImage(named: post.image)!, filter: .allCases.randomElement() ?? .noir) { image in
            imagePost.image = image
        }
        likesLabel.text = "Лайки: \(String(post.likes))"
        viewsLabel.text = "Просмотры: \(String(post.views))"
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didDoubleTapOnPost)
        )
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    func configure(with post: PostModel) {
        postModel = post
        authorLabel.text = post.author
        descriptionLabel.text = post.postDescription
        ImageProcessor().processImage(sourceImage: UIImage(named: post.nameImage)!, filter: .allCases.randomElement() ?? .noir) { image in
            imagePost.image = image
        }
        likesLabel.text = "Лайки: \(String(post.likes))"
        viewsLabel.text = "Просмотры: \(String(post.views))"
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didDoubleTapOnPost)
        )
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            imagePost.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            imagePost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagePost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagePost.heightAnchor.constraint(equalTo: imagePost.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
