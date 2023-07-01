//
//  CollectionViewCell.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 30.06.2023.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    enum CellType {
        case emoji
        case color
    }
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
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

    func cellSelected(type: CellType, color: UIColor?) {
        switch type {
        case .emoji:
            backgroundColor = .ypLightGray
            layer.cornerRadius = 16
            layer.masksToBounds = true
        case .color:
            guard let color else { return }
            layer.borderColor = color.cgColor
            layer.borderWidth = 3
            layer.cornerRadius = 11
            layer.masksToBounds = true
        }
    }

    func cellDeselected() {
        backgroundColor = .clear
        layer.borderColor = UIColor.clear.cgColor
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
