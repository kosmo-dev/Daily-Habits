//
//  CategoryViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 20.07.2023.
//

import UIKit

protocol CategoryViewModelDelegate: AnyObject {
    func addCategory(_ category: String, index: Int)
}

final class CategoryViewModel {
    weak var delegate: CategoryViewModelDelegate?

    @Observable private (set) var categories: [String] = ["Важное", "Не важное"]

    private var choosedCategoryIndex: Int?
    private var navigationController: UINavigationController?

    init(choosedCategoryIndex: Int?, navigationController: UINavigationController?) {
        self.choosedCategoryIndex = choosedCategoryIndex
        self.navigationController = navigationController
    }

    func addCategoryButtonTapped() {
        let addCategoryViewController = NewCategoryViewController()
        addCategoryViewController.delegate = self
        navigationController?.pushViewController(addCategoryViewController, animated: true)
    }

    func hideCheckMarkImage(for indexPath: IndexPath) -> Bool {
        if let choosedCategoryIndex, choosedCategoryIndex == indexPath.row {
            return false
        } else {
            return true
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        delegate?.addCategory(categories[indexPath.row], index: indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryViewModel: NewCategoryViewControllerDelegate {
    func addNewCategory(_ category: String) {
        categories.append(category)
    }
}
