//
//  PrimaryButton.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

final class PrimaryButton: UIButton {
    enum ButtonType {
        case primary
        case notActive
        case cancel
        case secondary
    }

    init(title: String, action: Selector, type: ButtonType) {
        super.init(frame: .zero)
        configureView(title: title, action: action, type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView(title: String, action: Selector, type: ButtonType) {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        setTitle(title, for: .normal)
        addTarget(nil, action: action, for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
        configureButtonType(type)
    }

    func configureButtonType(_ type: ButtonType) {
        switch type {
        case .primary:
            setTitleColor(.ypWhite, for: .normal)
            backgroundColor = .ypBlack
        case .notActive:
            setTitleColor(.ypWhite, for: .normal)
            backgroundColor = .gray
        case .cancel:
            setTitleColor(.ypRed, for: .normal)
            backgroundColor = .clear
            layer.borderColor = UIColor.ypRed.cgColor
            layer.borderWidth = 1
        case .secondary:
            setTitleColor(.ypWhite, for: .normal)
            backgroundColor = .ypBlue
        }
    }
}
