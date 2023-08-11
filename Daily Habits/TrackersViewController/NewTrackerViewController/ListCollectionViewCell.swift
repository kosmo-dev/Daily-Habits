//
//  ListCollectionViewCell.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 30.07.2023.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {

    private let listView = ListView(type: .disclosure)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(_ viewModel: ListViewModel) {
        listView.addPrimaryText(viewModel.primaryText)
        listView.setMaskedCorners(viewModel.maskedCorners)
        listView.setBottomDividerHidden(viewModel.bottomDividerIsHidden)
    }

    func addSecondaryText(_ text: String) {
        listView.addSecondaryText(text)
    }

    private func configureView() {
        addSubview(listView)
        listView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: topAnchor),
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }


}
