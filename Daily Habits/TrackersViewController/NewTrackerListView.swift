//
//  NewTrackerListView.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

final class NewTrackerListButton: UIButton {
    // MARK: - Private Properties
    let disclosureImage: UIImageView = {
        let disclosureImage = UIImageView()
        disclosureImage.image = UIImage(systemName: "chevron.right")
        disclosureImage.tintColor = .ypGray
        disclosureImage.translatesAutoresizingMaskIntoConstraints = false
        return disclosureImage
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let bottomDivider: UIView = {
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .ypGray
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        return bottomDivider
    }()

    private let primaryText: UILabel = {
        let primaryText = UILabel()
        primaryText.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        primaryText.textColor = .ypBlack
        primaryText.translatesAutoresizingMaskIntoConstraints = false
        return primaryText
    }()

    private let secondaryText: UILabel = {
        let secondaryText = UILabel()
        secondaryText.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        secondaryText.textColor = .ypGray
        secondaryText.translatesAutoresizingMaskIntoConstraints = false
        return secondaryText
    }()

    // MARK: - Initializers
    init(frame: CGRect, viewMaskedCorners: CACornerMask, bottomDividerIsHidden: Bool, primaryText: String) {
        super.init(frame: frame)
        layer.maskedCorners = viewMaskedCorners
        bottomDivider.isHidden = bottomDividerIsHidden
        self.primaryText.text = primaryText
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public Methods
    func addSecondaryText(_ text: String) {
        secondaryText.text = text
        stackView.addArrangedSubview(secondaryText)
    }

    func updateSecondaryText(_ text: String) {
        secondaryText.text = text
    }

    // MARK: - Private Methods
    private func configureView() {
        backgroundColor = .ypBackground
        layer.masksToBounds = true
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false

        [stackView, disclosureImage, bottomDivider].forEach({ addSubview($0) })
        stackView.addArrangedSubview(primaryText)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            disclosureImage.widthAnchor.constraint(equalToConstant: 10),
            disclosureImage.heightAnchor.constraint(equalToConstant: 17),
            disclosureImage.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            disclosureImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            disclosureImage.centerYAnchor.constraint(equalTo: centerYAnchor),

            bottomDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
}
