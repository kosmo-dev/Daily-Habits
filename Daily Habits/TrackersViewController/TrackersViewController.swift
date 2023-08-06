//
//  TrackersViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 15.06.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Private Properties
    private let datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.preferredDatePickerStyle = .compact
        datePickerView.datePickerMode = .date
        datePickerView.calendar = Calendar.current
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        return datePickerView
    }()

    private let searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = S.TrackersViewController.searchPlaceholder
        searchField.addTarget(nil, action: #selector(searchFieldEditingChanged), for: .editingChanged)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let cancelSearchButton: UIButton = {
        let cancelSearchButton = UIButton()
        cancelSearchButton.setTitle(S.cancelButton, for: .normal)
        cancelSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelSearchButton.setTitleColor(.ypBlue, for: .normal)
        cancelSearchButton.addTarget(nil, action: #selector(cancelSearchButtonTapped), for: .touchUpInside)
        cancelSearchButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelSearchButton
    }()

    private let searchStackView: UIStackView = {
        let searchStackView = UIStackView()
        searchStackView.axis = .horizontal
        searchStackView.spacing = 5
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        return searchStackView
    }()

    private let placeholderImageView: UIImageView = {
        let placeholderImageView = UIImageView()
        placeholderImageView.image = UIImage(named: C.UIImages.emptyTrackersPlaceholder)
        placeholderImageView.isHidden = true
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderImageView
    }()

    private let placeholderText: UILabel = {
        let placeholderText = UILabel()
        placeholderText.text = S.TrackersViewController.emptyTrackersPlaceholder
        placeholderText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderText.textColor = .ypBlack
        placeholderText.isHidden = true
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        return placeholderText
    }()

    private var viewModel: TrackersViewModel

    // MARK: - Initializers
    init(viewModel: TrackersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite

        configureNavigationBar()
        configureCollectionView()
        makeLayout()
        setBindings()
        
        searchField.delegate = self
        viewModel.viewControllerDidLoad()
    }

    // MARK: - Private Methods
    private func configureNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: nil)
        let rightBarButtonItem = UIBarButtonItem(customView: datePickerView)
        leftBarButtonItem.tintColor = .ypBlack

        leftBarButtonItem.action = #selector(leftBarButtonTapped)

        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem

        navigationItem.title = S.TrackersViewController.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true

        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }

    private func makeLayout() {
        [searchStackView, collectionView, placeholderImageView, placeholderText].forEach({ view.addSubview($0) })
        searchStackView.addArrangedSubview(searchField)

        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            searchStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),

            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            placeholderImageView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),

            placeholderText.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),

            cancelSearchButton.widthAnchor.constraint(equalToConstant: 83)
        ])
    }

    private func setBindings() {
        viewModel.$placeholderImage.bind { [weak self] image in
            guard let self else { return }
            if let image {
                placeholderImageView.isHidden = false
                placeholderImageView.image = image
            } else {
                placeholderImageView.isHidden = true
            }
        }

        viewModel.$placeholderText.bind { [weak self] text in
            guard let self else { return }
            if let text {
                placeholderText.isHidden = false
                placeholderText.text = text
            } else {
                placeholderText.isHidden = true
            }
        }

        viewModel.$alertText.bind { [weak self] alertText in
            guard let self, let alertText  else { return }
            showAlertController(with: alertText)

        }

        viewModel.$trackersCollectionViewUpdate.bind { [weak self] trackersCollectionViewUpdate in
            guard let self else { return }
            guard let trackersCollectionViewUpdate else { return }
            performBatchUpdates(trackersCollectionViewUpdate)
        }
    }

    @objc private func leftBarButtonTapped() {
        viewModel.leftBarButtonTapped()
    }

    @objc private func datePickerValueChanged() {
        viewModel.datePickerValueChanged(datePickerView.date)
    }

    @objc private func cancelSearchButtonTapped() {
        searchField.text = ""
        searchField.resignFirstResponder()
        cancelSearchButton.removeFromSuperview()
        datePickerValueChanged()
        viewModel.checkNeedPlaceholder(for: .noTrackers)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.visibleCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.visibleCategories[section].trackers.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardCollectionViewCell
        cell?.delegate = self
        let cellViewModel = viewModel.configureCellViewModel(for: indexPath)
        cell?.configureCell(viewModel: cellViewModel)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionReusableView
        view?.configureView(text: viewModel.visibleCategories[indexPath.section].name)
        return view ?? UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return makeCellContextMenuConfiguration(for: indexPath)
    }

    private func makeCellContextMenuConfiguration(for indexPath: IndexPath) -> UIContextMenuConfiguration {
        let cellIsPinned = viewModel.visibleCategories[indexPath.section].trackers[indexPath.row].isPinned
        let pinMenu = UIAction(title: S.TrackersViewController.pinAction) { [weak self] _ in
            self?.viewModel.pinButtonTapped(for: indexPath)
        }
        let unPinMenu = UIAction(title: S.TrackersViewController.unPinAction) { [weak self] _ in
            self?.viewModel.unPinButtonTapped(for: indexPath)
        }
        let editMenu = UIAction(title: S.TrackersViewController.editAction) { [weak self] _ in
            self?.viewModel.editButtonTapped(for: indexPath)
        }
        let deleteMenu = UIAction(title: S.TrackersViewController.deleteAction, attributes: .destructive) { [weak self] _ in
            self?.showDeleteAlert(indexPath)
        }
        let cellFirstMenu = cellIsPinned ? unPinMenu : pinMenu

        let uiContextMenuConfiguration = UIContextMenuConfiguration(actionProvider:  { actions in
            return UIMenu(children: [
                cellFirstMenu,
                editMenu,
                deleteMenu
            ])
        })
        return uiContextMenuConfiguration
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)

        if viewModel.visibleCategories[indexPath.section].trackers.count == 0 {
            return CGSizeZero
        }

        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return CGSize(width: collectionView.bounds.width, height: 50)
//        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - CardCollectionViewCellDelegate
extension TrackersViewController: CardCollectionViewCellDelegate {
    func checkButtonTapped(cellViewModel: CardCellViewModel) {
        viewModel.checkButtonOnCellTapped(cellViewModel: cellViewModel)
    }
}

// MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchStackView.addArrangedSubview(cancelSearchButton)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    @objc private func searchFieldEditingChanged() {
        guard let textToSearch = searchField.text else { return }
        if textToSearch != "" {
            viewModel.performSearchFor(text: textToSearch)
        } else {
            datePickerValueChanged()
            viewModel.checkNeedPlaceholder(for: .noTrackers)
        }
    }

    private func searchText(in categories: [TrackerCategory], textToSearch: String, weekday: Int) -> [TrackerCategory] {
        var searchedCategories: [TrackerCategory] = []

        for category in categories {
            var trackers: [Tracker] = []
            for tracker in category.trackers {
                let containsName = tracker.name.contains(textToSearch)
                let containsSchedule = tracker.schedule.contains(weekday)
                if containsName && containsSchedule {
                    trackers.append(tracker)
                }
            }
            if !trackers.isEmpty {
                searchedCategories.append(TrackerCategory(name: category.name, trackers: trackers))
            }
        }
        return searchedCategories
    }

    private func performBatchUpdates(_ trackersCollectionViewUpdate: TrackersCollectionViewUpdate) {
        if trackersCollectionViewUpdate.removedSections.isEmpty &&
            trackersCollectionViewUpdate.insertedSections.isEmpty &&
            trackersCollectionViewUpdate.removedIndexes.isEmpty &&
            trackersCollectionViewUpdate.insertedIndexes.isEmpty
        {
            collectionView.reloadData()
        }

        collectionView.performBatchUpdates {
            if  !trackersCollectionViewUpdate.removedSections.isEmpty {
                collectionView.deleteSections(trackersCollectionViewUpdate.removedSections)
            }
            if !trackersCollectionViewUpdate.insertedSections.isEmpty {
                collectionView.insertSections(trackersCollectionViewUpdate.insertedSections)
            }
            if !trackersCollectionViewUpdate.removedIndexes.isEmpty {
                collectionView.deleteItems(at: trackersCollectionViewUpdate.removedIndexes)
            }
            if !trackersCollectionViewUpdate.insertedIndexes.isEmpty {
                collectionView.insertItems(at: trackersCollectionViewUpdate.insertedIndexes)
            }
        }
        if !trackersCollectionViewUpdate.reloadedIndexes.isEmpty {
            collectionView.reloadItems(at: trackersCollectionViewUpdate.reloadedIndexes)
        }
    }
}

// MARK: - Alert Presentation
extension TrackersViewController {
    func showAlertController(with message: String) {
        let alertController = UIAlertController(title: S.TrackersViewController.alertControllerTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: S.TrackersViewController.alertControllerAction, style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    func showDeleteAlert(_ indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: S.TrackersViewController.alertControllerDeleteTitle, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: S.TrackersViewController.alertControllerDeleteAction, style: .destructive) { [weak self] _ in
            self?.viewModel.deleteButtonTapped(for: indexPath)
        }
        let cancelAction = UIAlertAction(title: S.cancelButton, style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
