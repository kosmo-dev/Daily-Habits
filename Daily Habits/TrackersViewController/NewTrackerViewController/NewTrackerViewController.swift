//
//  NewTrackerViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func addNewTracker(_ trackerCategory: TrackerCategory)
}

final class NewTrackerViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: NewTrackerViewControllerDelegate?
    
    // MARK: - Private Properties
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = "Введите название трекера"
        titleTextField.backgroundColor = .ypBackground
        titleTextField.layer.cornerRadius = 16
        titleTextField.layer.masksToBounds = true
        titleTextField.setLeftPaddingPoints(16)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        return titleTextField
    }()

    private let cancelButton = PrimaryButton(title: "Отменить", action: #selector(cancelButtonTapped), type: .cancel)
    private let saveButton = PrimaryButton(title: "Создать", action: #selector(saveButtonTapped), type: .notActive)
    private let categoryButtonView = ListView(viewMaskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], bottomDividerIsHidden: false, primaryText: "Категория", type: .disclosure, action: #selector(categoryViewButtonTapped))
    private let scheduleButtonView = ListView(viewMaskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], bottomDividerIsHidden: true, primaryText: "Расписание", type: .disclosure, action: #selector(scheduleViewButtonTapped))

    private var category: String?
    private var choosedDays: [Int] = []
    private var choosedCategoryIndex: Int?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Новая привычка"
        navigationItem.hidesBackButton = true

        categoryButtonView.translatesAutoresizingMaskIntoConstraints = false
        scheduleButtonView.translatesAutoresizingMaskIntoConstraints = false

        [titleTextField, categoryButtonView, scheduleButtonView, cancelButton, saveButton].forEach({ view.addSubview($0) })

        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),

            categoryButtonView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            categoryButtonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            categoryButtonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            categoryButtonView.heightAnchor.constraint(equalToConstant: 75),

            scheduleButtonView.topAnchor.constraint(equalTo: categoryButtonView.bottomAnchor),
            scheduleButtonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scheduleButtonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scheduleButtonView.heightAnchor.constraint(equalToConstant: 75),

            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonTapped() {
        let text: String = titleTextField.text ?? "Tracker"
        let category: String = category ?? "Category"
        delegate?.addNewTracker(TrackerCategory(name: category, trackers: [Tracker(id: UUID(), name: text, color: .colorSelection5, emoji: "❤️", schedule: choosedDays)]))
        dismiss(animated: true)
    }

    @objc private func categoryViewButtonTapped() {
        let viewController = CategoryViewController(choosedCategoryIndex: choosedCategoryIndex)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func scheduleViewButtonTapped() {
        let viewController = ScheduleViewController(choosedDays: choosedDays)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - CategoryViewControllerDelegate
extension NewTrackerViewController: CategoryViewControllerDelegate {
    func addCategory(_ category: String, index: Int) {
        categoryButtonView.addSecondaryText(category)
        self.category = category
        choosedCategoryIndex = index
    }
}

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func addWeekDays(_ weekdays: [Int]) {
        choosedDays = weekdays
        var daysView = ""
        if weekdays.count == 7 {
            daysView = "Каждый день"
            scheduleButtonView.addSecondaryText(daysView)
            return
        }
        for index in choosedDays {
            let day = Calendar.current.shortWeekdaySymbols[index]
            daysView.append(day)
            daysView.append(", ")
        }
        daysView = String(daysView.dropLast(2))
        scheduleButtonView.addSecondaryText(daysView)
    }
}
