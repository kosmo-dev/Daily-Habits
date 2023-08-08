//
//  NewTrackerViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    // MARK: - Private Properties
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = S.NewTrackerViewController.titleTextFieldPlaceholder
        titleTextField.backgroundColor = .ypBackground
        titleTextField.layer.cornerRadius = 16
        titleTextField.layer.masksToBounds = true
        titleTextField.setLeftPaddingPoints(16)
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.addTarget(nil, action: #selector(didChangeTitleTextField), for: .editingChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        return titleTextField
    }()

    private let daysTitle: UILabel = {
        let daysTitle = UILabel()
        daysTitle.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        daysTitle.textAlignment = .center
        daysTitle.translatesAutoresizingMaskIntoConstraints = false
        return daysTitle
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
        emojiLabel.text = S.NewTrackerViewController.emojiTitle
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()

    private let colorsLabel: UILabel = {
        let colorsLabel = UILabel()
        colorsLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorsLabel.text = S.NewTrackerViewController.colorsTitle
        colorsLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorsLabel
    }()

    private lazy var cancelButton = PrimaryButton(title: S.cancelButton, action: #selector(cancelButtonTapped), type: .cancel)
    private lazy var saveButton = PrimaryButton(title: viewModel.saveButtonTitle, action: #selector(saveButtonTapped), type: .notActive)

    private var viewModel: NewTrackerViewModel

    // MARK: - Initializers
    init(viewModel: NewTrackerViewModel) {
        self.viewModel = viewModel
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

        setBindings()
        viewModel.viewControllerDidLoad()
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        if viewModel.trackerType == .edit {
            navigationItem.title = S.NewTrackerViewController.navigationTitleEdit
        } else {
            navigationItem.title = S.NewTrackerViewController.navigationTitleNew
        }
        navigationItem.hidesBackButton = true

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
        guard let text = titleTextField.text else { return }
        viewModel.saveButtonTapped(text: text)
    }

    private func registerCells() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "textFieldCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "daysCell")
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "listViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emojiLabelCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorsLabelCell")
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "colorsCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "buttonCell")
    }

    @objc private func didChangeTitleTextField() {
        viewModel.setTitleText(text: titleTextField.text)
    }

    private func setBindings() {
        viewModel.$buttonIsEnabled.bind { [weak self] enabled in
            enabled ? self?.saveButton.configureButtonType(.primary) : self?.saveButton.configureButtonType(.notActive)
        }

        viewModel.$category.bind { [weak self] category in
            guard let self, let category else { return }
            self.updateCategoryViewSecondaryText(category)
        }

        viewModel.$weekdaysTitle.bind { [weak self] weekdays in
            guard let self, let weekdays else { return }
            self.updateScheduleViewSecondaryText(weekdays)
        }

        viewModel.$selectedEmojiCellIndexPath.bind { [weak self] oldIndexPath in
            self?.deselectCell(at: oldIndexPath)
        } didAction: { [weak self] newIndexPath in
            self?.selectCell(at: newIndexPath, type: .emoji)
        }

        viewModel.$selectedColorCellIndexPath.bind { [weak self] oldIndexPath in
            self?.deselectCell(at: oldIndexPath)
        } didAction: { [weak self] newIndexPath in
            self?.selectCell(at: newIndexPath, type: .color)
        }
    }

    private func deselectCell(at indexPath: IndexPath?) {
        guard let indexPath, let previousCell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        previousCell.cellDeselected()
    }

    private func selectCell(at indexPath: IndexPath?, type: CollectionViewCell.CellType) {
        guard let indexPath, let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        var color: UIColor? = nil
        if type == .color {
            color = viewModel.colors[indexPath.row].withAlphaComponent(0.3)
        }
        cell.cellSelected(type: type, color: color)
    }

    private func updateCategoryViewSecondaryText(_ text: String) {
        let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 2)) as? ListCollectionViewCell
        cell?.addSecondaryText(text)
    }

    private func updateScheduleViewSecondaryText(_ text: String) {
        let indexPath = viewModel.trackerType == .event ? IndexPath(item: 0, section: 3) : IndexPath(item: 1, section: 2)
        let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell
        cell?.addSecondaryText(text)
    }

    private func updateSecondaryText(in cell: ListCollectionViewCell?, for indexPath: IndexPath) {
        if indexPath.item == 0 {
            guard let category = viewModel.$category.wrappedValue else { return }
            cell?.addSecondaryText(category)
        } else {
            guard let schedule = viewModel.$weekdaysTitle.wrappedValue else { return }
            cell?.addSecondaryText(schedule)
        }
    }

    private func updateCellSelection(in cell: CollectionViewCell?, at indexPath: IndexPath, type: CollectionViewCell.CellType) {
        if type == .color {
            guard indexPath.item == viewModel.$selectedColorCellIndexPath.wrappedValue?.item else { return }
            let color = viewModel.colors[indexPath.row].withAlphaComponent(0.3)
            cell?.cellSelected(type: type, color: color)
        } else {
            guard indexPath.item == viewModel.$selectedEmojiCellIndexPath.wrappedValue?.item else { return }
            cell?.cellSelected(type: type, color: nil)
        }
    }
}

// MARK: - UITextFieldDelegate
extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.checkFormCompletion()
        titleTextField.resignFirstResponder()
        return true
    }
}

extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let section = viewModel.sections[indexPath.section]
        return section == .colorCollection || section == .emojisCollection || section == .listButtonViews
    }
}

// MARK: - UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.sections[indexPath.section]
        let padding: CGFloat = 16
        switch section {
        case .textField:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textFieldCell", for: indexPath)
            cell.addSubview(titleTextField)
            NSLayoutConstraint.activate([
                titleTextField.topAnchor.constraint(equalTo: cell.topAnchor),
                titleTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                titleTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                titleTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            if let title = viewModel.titleTextFieldText {
                titleTextField.text = title
            }
            return cell

        case .daysLabel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daysCell", for: indexPath)
            daysTitle.text = viewModel.daysTitle
            cell.addSubview(daysTitle)
            NSLayoutConstraint.activate([
                daysTitle.topAnchor.constraint(equalTo: cell.topAnchor),
                daysTitle.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                daysTitle.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                daysTitle.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            return cell

        case .listButtonViews:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listViewCell", for: indexPath) as? ListCollectionViewCell
            let upperMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            let lowerMaskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            var hideBottomDivider = false
            var maskedCorners: CACornerMask = []
            var primaryText: String = ""
            if indexPath.row == 0 {
                maskedCorners = upperMaskedCorners
                primaryText = S.NewTrackerViewController.categoryHeader
            }
            if indexPath.row == 1 {
                maskedCorners = lowerMaskedCorners
                hideBottomDivider = true
                primaryText = S.NewTrackerViewController.scheduleHeader
            }
            if viewModel.trackerType == .event {
                maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
                hideBottomDivider = true
            }
            let cellViewModel = ListViewModel(maskedCorners: maskedCorners, bottomDividerIsHidden: hideBottomDivider, primaryText: primaryText, type: .disclosure, action: nil, switcherIsOn: nil)
            cell?.configureCell(cellViewModel)
            updateSecondaryText(in: cell, for: indexPath)
            return cell ?? UICollectionViewCell()

        case .emojiLabel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiLabelCell", for: indexPath)
            cell.addSubview(emojiLabel)
            NSLayoutConstraint.activate([
                emojiLabel.topAnchor.constraint(equalTo: cell.topAnchor),
                emojiLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: padding),
                emojiLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            return cell

        case .emojisCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? CollectionViewCell
            cell?.configureView(with: viewModel.emojis[indexPath.row])
            updateCellSelection(in: cell, at: indexPath, type: .emoji)
            return cell ?? UICollectionViewCell()

        case .colorLabel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorsLabelCell", for: indexPath)
            cell.addSubview(colorsLabel)
            NSLayoutConstraint.activate([
                colorsLabel.topAnchor.constraint(equalTo: cell.topAnchor),
                colorsLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: padding),
                colorsLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            return cell

        case .colorCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorsCell", for: indexPath) as? CollectionViewCell
            cell?.configureView(with: viewModel.colors[indexPath.row])
            updateCellSelection(in: cell, at: indexPath, type: .color)
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

        let section = viewModel.sections[indexPath.section]
        switch section {
        case .textField:
            return CGSize(width: collectionView.bounds.width, height: 75)
        case .listButtonViews:
            return CGSize(width: collectionView.bounds.width, height: 75)
        case .emojiLabel:
            return CGSize(width: collectionView.bounds.width, height: 20)
        case .emojisCollection:
            return CGSize(width: cellWidth, height: cellWidth)
        case .colorLabel:
            return CGSize(width: collectionView.bounds.width, height: 20)
        case .colorCollection:
            return CGSize(width: cellWidth, height: cellWidth)
        case .buttons:
            let spacing: CGFloat = 8
            let cellWidth = (collectionWidth - spacing) / 2
            return CGSize(width: cellWidth, height: 60)
        case .daysLabel:
            return CGSize(width: collectionView.bounds.width, height: 40)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = viewModel.sections[section]

        switch section {
        case .textField, .buttons:
            return UIEdgeInsets.zero
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
        case .daysLabel:
            if viewModel.trackerType == .edit {
                return UIEdgeInsets(top: 24, left: 0, bottom: 40, right: 0)
            } else {
                return UIEdgeInsets.zero
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionEnum = viewModel.sections[section]
        if sectionEnum == .emojisCollection || sectionEnum == .colorCollection {
            return 5
        } else {
            return 0
        }
    }


}
