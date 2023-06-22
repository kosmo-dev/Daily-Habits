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
    }
    // MARK: - Private Properties
    let disclosureButton: UIButton = {
        let disclosureButton = UIButton()
        disclosureButton.setTitle("", for: .normal)
        disclosureButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        disclosureButton.tintColor = .ypGray
        disclosureButton.translatesAutoresizingMaskIntoConstraints = false
        return disclosureButton
    }()

    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .ypBlue
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
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

    private var viewType: ViewType?

    // MARK: - Initializers
    /// Creates a view with disclosure button
    init(viewMaskedCorners: CACornerMask, bottomDividerIsHidden: Bool, primaryText: String, action: Selector) {
        super.init(frame: .zero)
        layer.maskedCorners = viewMaskedCorners
        bottomDivider.isHidden = bottomDividerIsHidden
        self.primaryText.text = primaryText
        disclosureButton.addTarget(nil, action: action, for: .touchUpInside)
        viewType = .disclosure
        configureView()
    }

    /// Creates a view with UISwitch
    init(viewMaskedCorners: CACornerMask, bottomDividerIsHidden: Bool, primaryText: String) {
        super.init(frame: .zero)
        layer.maskedCorners = viewMaskedCorners
        bottomDivider.isHidden = bottomDividerIsHidden
        self.primaryText.text = primaryText
        viewType = .switcher
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

        addSubview(stackView)
        addSubview(bottomDivider)
        stackView.addArrangedSubview(primaryText)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            bottomDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        
        configureViewType()
    }

    private func configureViewType() {
        guard let viewType else { return }
        switch viewType {
        case .disclosure:
            addSubview(disclosureButton)
            NSLayoutConstraint.activate([
                disclosureButton.widthAnchor.constraint(equalToConstant: 10),
                disclosureButton.heightAnchor.constraint(equalToConstant: 17),
                disclosureButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
                disclosureButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                disclosureButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        case .switcher:
            addSubview(switcher)
            NSLayoutConstraint.activate([
                switcher.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
                switcher.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                switcher.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
}
