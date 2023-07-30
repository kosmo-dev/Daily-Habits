//
//  CategoryTableViewCell.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 19.07.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {

    private let listView = ListView(type: .checkmark)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "categoryTableViewCell")
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(_ model: CategoryCellModel) {
        listView.addPrimaryText(model.title)
        listView.hideCheckMarkImage(model.hideCheckmark)
        listView.setMaskedCorners(model.maskedCorners)
        listView.setBottomDividerHidden(model.hideBottomDivider)
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
