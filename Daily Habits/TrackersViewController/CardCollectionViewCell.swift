//
//  CardCollectionViewCell.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 19.06.2023.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    // MARK: - Private Properties
    private let cardView: UIView = {
        let cardView = UIView()
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()

    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 14)
        emojiLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        emojiLabel.textAlignment = .center
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()

    private let pinImageView: UIImageView = {
        let pinImageView = UIImageView()
        pinImageView.image = UIImage(systemName: "pin.fill")
        pinImageView.tintColor = .ypWhite
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        return pinImageView
    }()

    private let cardText: UILabel = {
        let cardText = UILabel()
        cardText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        cardText.textColor = .white
        cardText.translatesAutoresizingMaskIntoConstraints = false
        return cardText
    }()

    private let daysLabel: UILabel = {
        let daysLabel = UILabel()
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        return daysLabel
    }()

    private let checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.setTitle("", for: .normal)
        checkButton.tintColor = .colorSelection5
        checkButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 0
            checkButton.configuration = config
        } else {
            checkButton.imageView?.contentMode = .scaleAspectFill
            checkButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        checkButton.addTarget(nil, action: #selector(checkButtonTapped), for: .touchUpInside)

        checkButton.translatesAutoresizingMaskIntoConstraints = false
        return checkButton
    }()

    var cardIsChecked = false

    // MARK: - Public Methods
    func configureCell() {
        emojiLabel.text = "❤️"
        cardText.text = "Поливать растение"
        daysLabel.text = "1 день"
        cardView.backgroundColor = .colorSelection5

        makeLayout()
    }

    // MARK: - Private Methods
    private func makeLayout() {
        addSubview(cardView)
        cardView.addSubview(emojiLabel)
        cardView.addSubview(pinImageView)
        cardView.addSubview(cardText)
        addSubview(daysLabel)
        addSubview(checkButton)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),

            pinImageView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            cardText.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            cardText.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            cardText.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            checkButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            checkButton.widthAnchor.constraint(equalToConstant: 34),
            checkButton.heightAnchor.constraint(equalToConstant: 34),

            daysLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            daysLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor)
        ])
    }

    @objc func checkButtonTapped() {
        if cardIsChecked {
            checkButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            checkButton.layer.opacity = 1
            cardIsChecked = false
        } else {
            checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkButton.layer.opacity = 0.3
            cardIsChecked = true
        }
    }
}
