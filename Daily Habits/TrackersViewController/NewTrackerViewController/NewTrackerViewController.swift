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
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        return titleTextField
    }()

    private let emojiCollectionView: UICollectionView = {
        let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return emojiCollectionView
    }()

    private let colorsCollectionView: UICollectionView = {
        let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return colorsCollectionView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiLabel.text = "Emoji"
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()

    private let colorsLabel: UILabel = {
        let colorsLabel = UILabel()
        colorsLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorsLabel.text = "Цвет"
        colorsLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorsLabel
    }()

    private let cancelButton = PrimaryButton(title: "Отменить", action: #selector(cancelButtonTapped), type: .cancel)
    private let saveButton = PrimaryButton(title: "Создать", action: #selector(saveButtonTapped), type: .notActive)
    private let categoryButtonView = ListView(viewMaskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], bottomDividerIsHidden: false, primaryText: "Категория", type: .disclosure, action: #selector(categoryViewButtonTapped))
    private let scheduleButtonView = ListView(viewMaskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], bottomDividerIsHidden: true, primaryText: "Расписание", type: .disclosure, action: #selector(scheduleViewButtonTapped))

    private var category: String?
    private var choosedDays: [Int] = []
    private var choosedCategoryIndex: Int?
    private var buttonIsEnabled = false

    private let emojis = C.Emojis.emojis
    private let colors = C.Colors.colors

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        titleTextField.delegate = self
        emojiCollectionView.dataSource = self
        colorsCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        colorsCollectionView.delegate = self
        emojiCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        colorsCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Новая привычка"
        navigationItem.hidesBackButton = true

        categoryButtonView.translatesAutoresizingMaskIntoConstraints = false
        scheduleButtonView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        [titleTextField, categoryButtonView, scheduleButtonView, emojiLabel, emojiCollectionView, colorsLabel, colorsCollectionView, cancelButton, saveButton].forEach({ scrollView.addSubview($0) })

        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            titleTextField.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),

            categoryButtonView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            categoryButtonView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            categoryButtonView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            categoryButtonView.heightAnchor.constraint(equalToConstant: 75),

            scheduleButtonView.topAnchor.constraint(equalTo: categoryButtonView.bottomAnchor),
            scheduleButtonView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scheduleButtonView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scheduleButtonView.heightAnchor.constraint(equalToConstant: 75),

            emojiLabel.topAnchor.constraint(equalTo: scheduleButtonView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 28),

            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),

            colorsLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 32),
            colorsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 28),

            colorsCollectionView.topAnchor.constraint(equalTo: colorsLabel.bottomAnchor),
            colorsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            cancelButton.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            saveButton.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonTapped() {
        guard buttonIsEnabled else { return }
        let text: String = titleTextField.text ?? "Tracker"
        let category: String = category ?? "Category"
        delegate?.addNewTracker(TrackerCategory(name: category, trackers: [Tracker(id: UUID(), name: text, color: .colorSelection5, emoji: "❤️", schedule: choosedDays)]))
        dismiss(animated: true)
    }

    @objc private func categoryViewButtonTapped() {
        let viewController = CategoryViewController(choosedCategoryIndex: choosedCategoryIndex)
        viewController.delegate = self
        titleTextField.resignFirstResponder()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func scheduleViewButtonTapped() {
        let viewController = ScheduleViewController(choosedDays: choosedDays)
        titleTextField.resignFirstResponder()
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func checkFormCompletion() {
        if titleTextField.text?.isEmpty == false,
           category != nil,
           choosedDays.isEmpty == false {
            buttonIsEnabled = true
        } else {
            buttonIsEnabled = false
        }
        changeButtonView()
    }

    private func changeButtonView() {
        if buttonIsEnabled {
            saveButton.configureButtonType(.primary)
        } else {
            saveButton.configureButtonType(.notActive)
        }
    }
}

// MARK: - CategoryViewControllerDelegate
extension NewTrackerViewController: CategoryViewControllerDelegate {
    func addCategory(_ category: String, index: Int) {
        categoryButtonView.addSecondaryText(category)
        self.category = category
        choosedCategoryIndex = index
        checkFormCompletion()
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
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ru_RU")
            let day = calendar.shortWeekdaySymbols[index]
            daysView.append(day)
            daysView.append(", ")
        }
        daysView = String(daysView.dropLast(2))
        scheduleButtonView.addSecondaryText(daysView)
        checkFormCompletion()
    }
}

// MARK: - UITextFieldDelegate
extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkFormCompletion()
        titleTextField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else {
            return colors.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? CollectionViewCell
            cell?.configureView(with: emojis[indexPath.row])

            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? CollectionViewCell

            cell?.configureView(with: colors[indexPath.row])
            return cell ?? UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
}
