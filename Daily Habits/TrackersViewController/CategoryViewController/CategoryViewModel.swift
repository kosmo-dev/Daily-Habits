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

    @Observable private (set) var categories: [String] = []
    @Observable private(set) var alertText: String?

    private var choosedCategoryIndex: Int?
    private var navigationController: UINavigationController?
    private var dataController: TrackerDataControllerProtocol

    init(choosedCategoryIndex: Int?, navigationController: UINavigationController?, dataController: TrackerDataControllerProtocol) {
        self.choosedCategoryIndex = choosedCategoryIndex
        self.navigationController = navigationController
        self.dataController = dataController
        fetchCategories()
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

    private func fetchCategories() {
        categories = dataController.fetchCategoriesList()
    }
}

extension CategoryViewModel: NewCategoryViewControllerDelegate {
    func addNewCategory(_ category: String) {
        do {
            try dataController.addNewCategory(category)
            categories.append(category)
        } catch let error as TrackerCategoryStoreError {
            switch error {
            case .categoryExist:
                alertText = "Категория уже существует"
            default:
                alertText = "Ошибка добавления новой категории"
            }
        } catch {
            alertText = "Ошибка добавления новой категории"
        }
    }
}
