//
//  CustomButton.swift
//  Navigation
//
//  Created by Алексей Голованов on 25.07.2023.
//

import UIKit


final class CustomButton: UIButton {
    
    typealias Action = () -> Void
    
    var buttonAction: Action
    
    init(title: String, cornerRadius: CGFloat, image: UIImage = UIImage(), action: @escaping Action) {
        buttonAction = action
        super.init(frame: .zero)
        buttonSetup(title: title, cornerRadius: cornerRadius, image: image, action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        buttonAction()
    }
    
    private func buttonSetup(title: String, cornerRadius: CGFloat, image: UIImage, action: Action) {
        setTitle(title.localized, for: .normal)
        if image != UIImage() {
            setBackgroundImage(UIImage(named:"blue_pixel"), for: .normal)
            setImage(image, for: .normal)
        } else {
            setBackgroundImage(UIImage(named:"blue_pixel"), for: .normal)
        }
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
}
