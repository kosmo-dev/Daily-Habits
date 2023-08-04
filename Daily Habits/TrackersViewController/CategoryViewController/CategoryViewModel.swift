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

    @Observable private (set) var categoriesModel: [CategoryCellModel] = []
    @Observable private(set) var alertText: String?

    private var choosedCategoryIndex: Int?
    private var navigationController: UINavigationController?
    private var categoriesController: TrackerDataControllerCategoriesProtocol

    init(
        choosedCategoryIndex: Int?,
        navigationController: UINavigationController?,
        categoriesController: TrackerDataControllerCategoriesProtocol
    ) {
        self.choosedCategoryIndex = choosedCategoryIndex
        self.navigationController = navigationController
        self.categoriesController = categoriesController
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
        delegate?.addCategory(categoriesModel[indexPath.row].title, index: indexPath.row)
        navigationController?.popViewController(animated: true)
    }

    private func fetchCategories() {
        categoriesModel.removeAll()
        let categories = categoriesController.fetchCategoriesList()
        for (index, category) in categories.enumerated() {
            let upperMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            let lowerMaskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            var hideBottomDivider = false
            var maskedCorners: CACornerMask = []
            var hideCheckMark = true
            if index == 0 {
                maskedCorners = upperMaskedCorners
            }
            if index == categories.count - 1 {
                maskedCorners = lowerMaskedCorners
                hideBottomDivider = true
            }
            if categories.count == 1 {
                maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
                hideBottomDivider = true
            }
            if index == choosedCategoryIndex {
                hideCheckMark = false
            }
            categoriesModel.append(CategoryCellModel(title: category, hideCheckmark: hideCheckMark, hideBottomDivider: hideBottomDivider, maskedCorners: maskedCorners))
        }
    }
}

extension CategoryViewModel: NewCategoryViewControllerDelegate {
    func addNewCategory(_ category: String) {
        do {
            try categoriesController.addNewCategory(category)
            fetchCategories()
        } catch let error as TrackerCategoryStoreError {
            switch error {
            case .categoryExist:
                alertText = S.CategoryViewController.alertControllerErrorCategoryExist
            default:
                alertText = S.TrackersViewController.alertControllerErrorAddingTracker
            }
        } catch {
            alertText = S.TrackersViewController.alertControllerErrorAddingTracker
        }
    }
}
