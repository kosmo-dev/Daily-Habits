//
//  ListButton.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 24.06.2023.
//

import UIKit

protocol ListButtonDelegate: AnyObject {
    func getPrimaryText() -> String?
    func hideCheckMarkImage(_ hide: Bool)
}

class ListButton: UIButton {
    weak var delegate: ListButtonDelegate?

    init(primaryText: String) {
        super.init(frame: .zero)
        setTitle("", for: .normal)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getPrimaryText() -> String? {
        return delegate?.getPrimaryText()
    }

    func hideCheckMarkImage(_ hide: Bool) {
        delegate?.hideCheckMarkImage(hide)
    }
}
