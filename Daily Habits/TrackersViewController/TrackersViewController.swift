//
//  TrackersViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 15.06.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    enum PlaceholderState {
        case noTrackers
        case notFound
    }
    // MARK: - Private Properties
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()

    private let datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.preferredDatePickerStyle = .compact
        datePickerView.datePickerMode = .date
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        datePickerView.calendar = calendar
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        return datePickerView
    }()

    private let searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
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
        cancelSearchButton.setTitle("Отменить", for: .normal)
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
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderImageView
    }()

    private let placeholderText: UILabel = {
        let placeholderText = UILabel()
        placeholderText.text = "Что будем отслеживать?"
        placeholderText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderText.textColor = .ypBlack
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        return placeholderText
    }()

    private var visibleCategories: [TrackerCategory] = []
    private var currentDate: Date = Date()

    private var insertedIndexesInSearch: [IndexPath] = []
    private var removedIndexesInSearch: [IndexPath] = []
    private var insertedSectionsInSearch: IndexSet = []
    private var removedSectionsInSearch: IndexSet = []

    private let trackerDataController: TrackerDataControllerProtocol

    // MARK: - Initializers
    init(trackerDataController: TrackerDataControllerProtocol) {
        self.trackerDataController = trackerDataController
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
        searchField.delegate = self
        trackerDataController.delegate = self
        let weekday = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchCategoriesFor(weekday: weekday, animating: false)
    }

    // MARK: - Private Methods
    private func configureNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: nil)
        let rightBarButtonItem = UIBarButtonItem(customView: datePickerView)
        leftBarButtonItem.tintColor = .ypBlack

        leftBarButtonItem.action = #selector(leftBarButtonTapped)
        rightBarButtonItem.action = #selector(rightBarButtonTapped)

        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem

        navigationItem.title = "Трекеры"
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

    private func checkNeedPlaceholder(for state: PlaceholderState) {
        if visibleCategories.isEmpty {
            placeholderImageView.isHidden = false
            placeholderText.isHidden = false
            switch state {
            case .noTrackers:
                placeholderImageView.image = UIImage(named: C.UIImages.emptyTrackersPlaceholder)
                placeholderText.text = "Что будем отслеживать?"
            case .notFound:
                placeholderImageView.image = UIImage(named: C.UIImages.searchNotFoundPlaceholder)
                placeholderText.text = "Ничего не найдено"
            }
        } else {
            placeholderImageView.isHidden = true
            placeholderText.isHidden = true
        }
    }

    @objc private func leftBarButtonTapped() {
        let newTrackerTypeChoosingviewController = NewTrackerTypeChoosingViewController(trackersViewController: self)
        let modalNavigationController = UINavigationController(rootViewController: newTrackerTypeChoosingviewController)
        navigationController?.present(modalNavigationController, animated: true)
    }
    
    @objc private func rightBarButtonTapped() {
    }

    @objc private func datePickerValueChanged() {
        currentDate = datePickerView.date
        let weekday = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchCategoriesFor(weekday: weekday, animating: true)
    }

    private func configureViewModel(for indexPath: IndexPath) -> CardCellViewModel {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let counter = trackerDataController.fetchRecordsCountForId(tracker.id)
        let cardIsChecked = trackerDataController.checkTrackerRecordExist(id: tracker.id, date: dateFormatter.string(from: currentDate))
        let dateComparision = Calendar.current.compare(currentDate, to: Date(), toGranularity: .day)
        var buttonEnabled = true
        if dateComparision.rawValue == 1 {
            buttonEnabled = false
        }
        return CardCellViewModel(tracker: tracker, counter: counter, buttonIsChecked: cardIsChecked, indexPath: indexPath, buttonIsEnabled: buttonEnabled)
    }

    @objc private func cancelSearchButtonTapped() {
        searchField.text = ""
        searchField.resignFirstResponder()
        cancelSearchButton.removeFromSuperview()
        datePickerValueChanged()
        checkNeedPlaceholder(for: .noTrackers)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = visibleCategories[section].trackers.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardCollectionViewCell
        cell?.delegate = self
        let viewModel = configureViewModel(for: indexPath)
        cell?.configureCell(viewModel: viewModel)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionReusableView
        view?.configureView(text: visibleCategories[indexPath.section].name)
        return view ?? UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)

        if visibleCategories[indexPath.section].trackers.count == 0 {
            return CGSizeZero
        }

        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - NewTrackerViewControllerDelegate
extension TrackersViewController: NewTrackerViewControllerDelegate {
    func addNewTracker(_ trackerCategory: TrackerCategory) {
        dismiss(animated: true)
        print("1. Will call trackerDataController.addTrackerCategory")
        try? trackerDataController.addTrackerCategory(trackerCategory)
    }
}

// MARK: - CardCollectionViewCellDelegate
extension TrackersViewController: CardCollectionViewCellDelegate {
    func checkButtonTapped(viewModel: CardCellViewModel) {
        if viewModel.buttonIsChecked {
            trackerDataController.addTrackerRecord(id: viewModel.tracker.id, date: dateFormatter.string(from: currentDate))
        } else {
            trackerDataController.deleteTrackerRecord(id: viewModel.tracker.id, date: dateFormatter.string(from: currentDate))
        }
        collectionView.reloadItems(at: [viewModel.indexPath])
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
        let weekday = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchSearchedCategories(textToSearch: textToSearch, weekday: weekday)
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

    private func calculateDiff(newCategories: [TrackerCategory]) {
        removedIndexesInSearch.removeAll()
        insertedIndexesInSearch.removeAll()
        removedSectionsInSearch.removeAll()
        insertedSectionsInSearch.removeAll()

        for (section, category) in visibleCategories.enumerated() {
            for (index, item) in category.trackers.enumerated() {
                if !newCategories.contains(where: { $0.trackers.contains(where: { $0.id == item.id }) }) {
                    removedIndexesInSearch.append(IndexPath(item: index, section: section))
                }
            }
        }

        for (section, category) in newCategories.enumerated() {
            for (index, item) in category.trackers.enumerated() {
                if !visibleCategories.contains(where: { $0.trackers.contains(where: { $0.id == item.id }) }) {
                    insertedIndexesInSearch.append(IndexPath(item: index, section: section))
                }
            }
        }

        for (section, category) in visibleCategories.enumerated() {
            if !newCategories.contains(where: { $0.name == category.name }) {
                removedSectionsInSearch.insert(section)
            }
        }

        for (section, category) in newCategories.enumerated() {
            if !visibleCategories.contains(where: { $0.name == category.name }) {
                insertedSectionsInSearch.insert(section)
            }
        }
    }

    private func performBatchUpdates() {
        guard !removedSectionsInSearch.isEmpty,
              !insertedSectionsInSearch.isEmpty,
              !removedIndexesInSearch.isEmpty,
              !insertedIndexesInSearch.isEmpty
        else {
            collectionView.reloadData()
            return
        }
        collectionView.performBatchUpdates {
            if !removedSectionsInSearch.isEmpty {
                collectionView.deleteSections(removedSectionsInSearch)
            }
            if !insertedSectionsInSearch.isEmpty {
                collectionView.insertSections(insertedSectionsInSearch)
            }
            if !removedIndexesInSearch.isEmpty {
                collectionView.deleteItems(at: removedIndexesInSearch)
            }
            if !insertedIndexesInSearch.isEmpty {
                collectionView.insertItems(at: insertedIndexesInSearch)
            }
        }
    }
}

extension TrackersViewController: TrackerDataControllerDelegate {
    func updateView(categories: [TrackerCategory], animating: Bool) {
        calculateDiff(newCategories: categories)
        visibleCategories = categories
        if animating {
            performBatchUpdates()
        } else {
            collectionView.reloadData()
        }
        checkNeedPlaceholder(for: .notFound)
    }

    func updateViewByController(_ update: TrackerCategoryStoreUpdate) {
        visibleCategories = trackerDataController.categories
        checkNeedPlaceholder(for: .noTrackers)
        print("7. Will call collectionView.performBatchUpdates")
        print("VisibleCategories: \(visibleCategories)")
        print("Update: ", update)
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: update.insertedIndexes)
            collectionView.deleteItems(at: update.deletedIndexes)
            collectionView.reloadItems(at: update.updatedIndexes)
            for move in update.movedIndexes {
                collectionView.moveItem(at: move.oldIndex, to: move.newIndex)
            }
        }
    }
}
