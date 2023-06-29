//
//  CollectionViewCell.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 30.06.2023.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()

    func configureView(with text: String) {
        label.text = text
        label.isHidden = false
        colorView.isHidden = true
        setupView()
    }

    func configureView(with color: UIColor) {
        colorView.backgroundColor = color
        label.isHidden = true
        colorView.isHidden = false
        setupView()
    }

    private func setupView() {
        addSubview(label)
        addSubview(colorView)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),

            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
