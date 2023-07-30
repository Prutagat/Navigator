//
//  CustomButton.swift
//  Navigation
//
//  Created by Алексей Голованов on 25.07.2023.
//

import UIKit

final class CustomButton: UIButton {
    
    var buttonAction: (() -> Void)?
    
    init(title: String, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        buttonSetup(title: title, cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        buttonAction?()
    }
    
    private func buttonSetup(title: String, cornerRadius: CGFloat) {
        setTitle(title, for: .normal)
        setBackgroundImage(UIImage(named:"blue_pixel"), for: .normal)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
}
