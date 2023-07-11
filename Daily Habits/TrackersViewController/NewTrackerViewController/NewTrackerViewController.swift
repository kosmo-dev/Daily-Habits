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
    enum Sections {
        case textField
        case listButtonViews
        case emojiLabel
        case emojisCollection
        case colorLabel
        case colorCollection
        case buttons
    }

    enum TrackerType {
        case habit
        case event
    }

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

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
//    private let categoryButtonView = ListView(viewMaskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], bottomDividerIsHidden: false, primaryText: "Категория", type: .disclosure, action: nil)
//    private let scheduleButtonView = ListView(viewMaskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], bottomDividerIsHidden: true, primaryText: "Расписание", type: .disclosure, action: #selector(scheduleViewButtonTapped))

    private var categoryButtonView: ListView?
    private var scheduleButtonView: ListView?

    private var category: String?
    private var choosedDays: [Int] = []
    private var choosedCategoryIndex: Int?
    private var buttonIsEnabled = false

    private let emojis = C.Emojis.emojis
    private let colors = C.Colors.colors
    private var selectedEmojiCellIndexPath: IndexPath?
    private var selectedColorCellIndexPath: IndexPath?

    private let sections: [Sections] = [.textField, .listButtonViews, .emojiLabel, .emojisCollection, .colorLabel, .colorCollection, .buttons]
    private let trackerType: TrackerType

    // MARK: - Initializers
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        titleTextField.delegate = self

        registerCells()
        collectionView.delegate = self
        collectionView.dataSource = self

        addCategory("Важное", index: 0)
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Новая привычка"
        navigationItem.hidesBackButton = true

//        categoryButtonView.translatesAutoresizingMaskIntoConstraints = false
//        scheduleButtonView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonTapped() {
        guard buttonIsEnabled else { return }
        guard let text = titleTextField.text,
              let category = category,
              let selectedEmojiCellIndexPath,
              let selectedColorCellIndexPath
        else {
            return
        }
        let emoji = emojis[selectedEmojiCellIndexPath.row]
        let color = colors[selectedColorCellIndexPath.row]
        delegate?.addNewTracker(TrackerCategory(name: category, trackers: [Tracker(id: UUID(), name: text, color: color, emoji: emoji, schedule: choosedDays)]))
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
           choosedDays.isEmpty == false,
           selectedEmojiCellIndexPath != nil,
           selectedColorCellIndexPath != nil
        {
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

    private func registerCells() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "textFieldCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "listViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emojiLabelCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorsLabelCell")
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "colorsCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "buttonCell")
    }
}

// MARK: - CategoryViewControllerDelegate
extension NewTrackerViewController: CategoryViewControllerDelegate {
    func addCategory(_ category: String, index: Int) {
        categoryButtonView?.addSecondaryText(category)
        self.category = category
        choosedCategoryIndex = index
        checkFormCompletion()
    }
}

// MARK: - ScheduleViewControllerDelegate
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func addWeekDays(_ weekdays: [Int]) {
        choosedDays = weekdays
        var daysView = ""
        if weekdays.count == 7 {
            daysView = "Каждый день"
            scheduleButtonView?.addSecondaryText(daysView)
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
        scheduleButtonView?.addSecondaryText(daysView)
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

extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if section == .emojisCollection  {
            if let selectedEmojiCellIndexPath,
               let previousCell = collectionView.cellForItem(at: selectedEmojiCellIndexPath) as? CollectionViewCell {
                previousCell.cellDeselected()
            }
            guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
            cell.cellSelected(type: .emoji, color: nil)
            selectedEmojiCellIndexPath = indexPath

        } else if section == .colorCollection {
            if let selectedColorCellIndexPath,
               let previousCell = collectionView.cellForItem(at: selectedColorCellIndexPath) as? CollectionViewCell {
                previousCell.cellDeselected()
            }
            guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
            let color = colors[indexPath.row].withAlphaComponent(0.3)
            cell.cellSelected(type: .color, color: color)
            selectedColorCellIndexPath = indexPath
        }
        checkFormCompletion()
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let section = sections[indexPath.section]
        if section == .colorCollection || section == .emojisCollection {
            return true
        } else {
            return false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .textField:
            return 1
        case .listButtonViews:
            if trackerType == .habit {
                return 2
            } else {
                return 1
            }
        case .emojiLabel:
            return 1
        case .emojisCollection:
            return emojis.count
        case .colorLabel:
            return 1
        case .colorCollection:
            return colors.count
        case .buttons:
            return 2
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let padding: CGFloat = 16
        switch section {
        case .textField:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textFieldCell", for: indexPath)
            cell.addSubview(titleTextField)
            NSLayoutConstraint.activate([
                titleTextField.topAnchor.constraint(equalTo: cell.topAnchor),
                titleTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: padding),
                titleTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -padding),
                titleTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            return cell

        case .listButtonViews:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listViewCell", for: indexPath)
            if trackerType == .habit {
                categoryButtonView = ListView(viewMaskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], bottomDividerIsHidden: false, primaryText: "Категория", type: .disclosure, action: nil)
                scheduleButtonView = ListView(viewMaskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], bottomDividerIsHidden: true, primaryText: "Расписание", type: .disclosure, action: #selector(scheduleViewButtonTapped))
            } else {
                categoryButtonView = ListView(viewMaskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], bottomDividerIsHidden: true, primaryText: "Категория", type: .disclosure, action: nil)
            }
            if indexPath.row == 0 {
                if let categoryButtonView {
                    cell.addSubview(categoryButtonView)
                    NSLayoutConstraint.activate([
                        categoryButtonView.topAnchor.constraint(equalTo: cell.topAnchor),
                        categoryButtonView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: padding),
                        categoryButtonView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -padding),
                        categoryButtonView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
                    ])
                }
            } else {
                if let scheduleButtonView {
                    cell.addSubview(scheduleButtonView)
                    NSLayoutConstraint.activate([
                        scheduleButtonView.topAnchor.constraint(equalTo: cell.topAnchor),
                        scheduleButtonView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: padding),
                        scheduleButtonView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -padding),
                        scheduleButtonView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
                    ])
                }
            }
            return cell

        case .emojiLabel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiLabelCell", for: indexPath)
            cell.addSubview(emojiLabel)
            NSLayoutConstraint.activate([
                emojiLabel.topAnchor.constraint(equalTo: cell.topAnchor),
                emojiLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 28),
                emojiLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            return cell

        case .emojisCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? CollectionViewCell
            cell?.configureView(with: emojis[indexPath.row])
            return cell ?? UICollectionViewCell()

        case .colorLabel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorsLabelCell", for: indexPath)
            cell.addSubview(colorsLabel)
            NSLayoutConstraint.activate([
                colorsLabel.topAnchor.constraint(equalTo: cell.topAnchor),
                colorsLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 28),
                colorsLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            return cell

        case .colorCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorsCell", for: indexPath) as? CollectionViewCell
            cell?.configureView(with: colors[indexPath.row])
            return cell ?? UICollectionViewCell()

        case .buttons:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath)
            if indexPath.row == 0 {
                cell.addSubview(cancelButton)
                NSLayoutConstraint.activate([
                    cancelButton.topAnchor.constraint(equalTo: cell.topAnchor),
                    cancelButton.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                    cancelButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                    cancelButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
                ])
            } else {
                cell.addSubview(saveButton)
                NSLayoutConstraint.activate([
                    saveButton.topAnchor.constraint(equalTo: cell.topAnchor),
                    saveButton.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                    saveButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                    saveButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
                ])
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        let cellSpacing: CGFloat = 5
        let cellCount = 6
        let availableWidth = collectionWidth - CGFloat(cellCount - 1) * cellSpacing
        let cellWidth = availableWidth / CGFloat(cellCount)

        let section = sections[indexPath.section]
        switch section {
        case .textField:
            return CGSize(width: view.bounds.width, height: 75)
        case .listButtonViews:
            return CGSize(width: view.bounds.width, height: 75)
        case .emojiLabel:
            return CGSize(width: view.bounds.width, height: 20)
        case .emojisCollection:
            return CGSize(width: cellWidth, height: cellWidth)
        case .colorLabel:
            return CGSize(width: view.bounds.width, height: 20)
        case .colorCollection:
            return CGSize(width: cellWidth, height: cellWidth)
        case .buttons:
            let spacing: CGFloat = 8
            let cellWidth = (collectionWidth - spacing) / 2
            return CGSize(width: cellWidth, height: 60)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = sections[section]

        switch section {
        case .textField:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .listButtonViews:
            return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        case .emojiLabel:
            return UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        case .emojisCollection:
            return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        case .colorLabel:
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        case .colorCollection:
            return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        case .buttons:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionEnum = sections[section]
        if sectionEnum == .emojisCollection || sectionEnum == .colorCollection {
            return 5
        } else {
            return 0
        }
    }


}
