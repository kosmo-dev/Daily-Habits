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

    func setPrimaryText(text: String) {
        listView.addPrimaryText(text)
    }

    func hideCheckMarkImage(_ hide: Bool) {
        listView.hideCheckMarkImage(hide)
    }

    func setMaskedCorners(_ corners: CACornerMask) {
        listView.setMaskedCorners(corners)
    }

    func setBottomDividerHidded(_ hidden: Bool) {
        listView.setBottomDividerHidded(hidden)
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
