//
//  CardCollectionViewCell.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 19.06.2023.
//

import UIKit

protocol CardCollectionViewCellDelegate: AnyObject {
    func checkButtonTapped(viewModel: CardCellViewModel)
}

final class CardCollectionViewCell: UICollectionViewCell {
    // MARK: - Public Properties
    weak var delegate: CardCollectionViewCellDelegate?

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
        checkButton.tintColor = .ypWhite
        checkButton.backgroundColor = .colorSelection5
        checkButton.layer.cornerRadius = 17
        checkButton.layer.masksToBounds = true

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

    private var viewModel: CardCellViewModel?

    // MARK: - Public Methods
    func configureCell(viewModel: CardCellViewModel) {
        emojiLabel.text = viewModel.tracker.emoji
        cardText.text = viewModel.tracker.name
        daysLabel.text = "\(viewModel.counter) \(dayStringDeclension(for: viewModel.counter))"
        cardView.backgroundColor = viewModel.tracker.color
        self.viewModel = viewModel
        pinImageView.isHidden = true
        checkButtonState()
        checkIsButtonEnabled()

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

        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),

            pinImageView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),

            cardText.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor, constant: 8),
            cardText.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            cardText.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            cardText.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding),

            checkButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            checkButton.widthAnchor.constraint(equalToConstant: 34),
            checkButton.heightAnchor.constraint(equalToConstant: 34),

            daysLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            daysLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor)
        ])

        checkButtonState()
    }

    @objc func checkButtonTapped() {
        viewModel?.buttonIsChecked.toggle()
        checkButtonState()
        guard let viewModel else { return }
        delegate?.checkButtonTapped(viewModel: viewModel)
    }

    private func checkButtonState() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 9, weight: .bold)
        var image: UIImage?
        guard let viewModel else { return }
        if viewModel.buttonIsChecked {
            image = UIImage(systemName: "checkmark", withConfiguration: imageConfiguration)
            checkButton.layer.opacity = 0.3
        } else {
            image = UIImage(systemName: "plus", withConfiguration: imageConfiguration)
            checkButton.layer.opacity = 1
        }
        checkButton.setImage(image, for: .normal)
    }

    private func checkIsButtonEnabled() {
        guard let viewModel else { return }
        if !viewModel.buttonIsEnabled {
            checkButton.backgroundColor = viewModel.tracker.color.withAlphaComponent(0.3)
            checkButton.isEnabled = false
        } else {
            checkButton.backgroundColor = viewModel.tracker.color.withAlphaComponent(1)
            checkButton.isEnabled = true
        }
    }

    private func dayStringDeclension(for counter: Int) -> String {
        let reminder = counter % 10
        if counter == 11 || counter == 12 || counter == 13 || counter == 14 {
            return "дней"
        }
        switch reminder {
        case 1:
            return "день"
        case 2, 3, 4:
            return "дня"
        default:
            return "дней"
        }
    }
}
