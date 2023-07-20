//
//  ListView.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

final class ListView: UIView {
    enum ViewType {
        case disclosure
        case switcher
        case checkmark
    }
    // MARK: - Private Properties
    private let disclosureImageView: UIImageView = {
        let disclosureImageView = UIImageView()
        disclosureImageView.image = UIImage(systemName: "chevron.right")
        disclosureImageView.tintColor = .ypGray
        disclosureImageView.isUserInteractionEnabled = true
        disclosureImageView.translatesAutoresizingMaskIntoConstraints = false
        return disclosureImageView
    }()

    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .ypBlue
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()

    private let checkmarkImageView: UIImageView = {
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = .ypBlue
        checkmarkImageView.isUserInteractionEnabled = true
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        return checkmarkImageView
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

    private var buttonView: ListButton
    private var viewType: ViewType?

    // MARK: - Initializers
    init(viewMaskedCorners: CACornerMask, bottomDividerIsHidden: Bool, primaryText: String, type: ViewType, action: Selector?) {
        self.buttonView = ListButton(primaryText: primaryText)
        super.init(frame: .zero)
        self.layer.maskedCorners = viewMaskedCorners
        self.bottomDivider.isHidden = bottomDividerIsHidden
        self.primaryText.text = primaryText
        self.buttonView.delegate = self
        if let action {
            buttonView.addTarget(nil, action: action, for: .touchUpInside)
        }
        viewType = type
        configureView()
    }

    init(type: ViewType) {
        self.buttonView = ListButton(primaryText: "")
        super.init(frame: .zero)
        viewType = type
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Public Methods
    func addSecondaryText(_ text: String) {
        secondaryText.text = text
        stackView.addArrangedSubview(secondaryText)
    }

    func addPrimaryText(_ text: String) {
        primaryText.text = text
    }

    func updateSecondaryText(_ text: String) {
        secondaryText.text = text
    }

    func switcherIsOn() -> Bool {
        return switcher.isOn
    }

    func setSwitcherOn() {
        switcher.setOn(true, animated: false)
    }

    func getPrimaryText() -> String? {
        return primaryText.text
    }

    func hideCheckMarkImage(_ hide: Bool) {
        checkmarkImageView.isHidden = hide
    }

    func setMaskedCorners(_ corners: CACornerMask) {
        layer.maskedCorners = corners
    }

    func setBottomDividerHidded(_ hidden: Bool) {
        bottomDivider.isHidden = hidden
    }

    // MARK: - Private Methods
    private func configureView() {
        backgroundColor = .ypBackground
        layer.masksToBounds = true
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addSubview(bottomDivider)
        stackView.addArrangedSubview(primaryText)
        addSubview(buttonView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            bottomDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.5),

            buttonView.topAnchor.constraint(equalTo: topAnchor),
            buttonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        configureViewType()
    }

    private func configureViewType() {
        guard let viewType else { return }
        switch viewType {
        case .disclosure:
            addSubview(disclosureImageView)
            NSLayoutConstraint.activate([
                disclosureImageView.widthAnchor.constraint(equalToConstant: 10),
                disclosureImageView.heightAnchor.constraint(equalToConstant: 17),
                disclosureImageView.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
                disclosureImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                disclosureImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        case .switcher:
            addSubview(switcher)
            NSLayoutConstraint.activate([
                switcher.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
                switcher.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                switcher.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        case .checkmark:
            addSubview(checkmarkImageView)
            NSLayoutConstraint.activate([
                checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
                checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
                checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                checkmarkImageView.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
                checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        }
    }
}

extension ListView: ListButtonDelegate {}
