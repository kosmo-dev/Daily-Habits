//
//  TrackersViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 15.06.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Private Properties

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
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
        return cancelSearchButton
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

    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite

        configureNavigationBar()
        configureCollectionView()
        makeLayout()
        checkNeedPlaceholder()
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
        [searchField, collectionView, placeholderImageView, placeholderText].forEach({ view.addSubview($0) })

        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),

            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            placeholderImageView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),

            placeholderText.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8)
        ])
    }

    private func checkNeedPlaceholder() {
        placeholderImageView.isHidden = true
        placeholderText.isHidden = true
    }

    @objc private func leftBarButtonTapped() {
        let newTrackerViewController = NewTrackerViewController(dateFormatter: dateFormatter)
        newTrackerViewController.delegate = self
        let newTrackerTypeChoosingviewController = NewTrackerTypeChoosingViewController(newTrackerViewController: newTrackerViewController, newHabitVIewController: nil)
        let modalNavigationController = UINavigationController(rootViewController: newTrackerTypeChoosingviewController)
        navigationController?.present(modalNavigationController, animated: true)
    }
    
    @objc private func rightBarButtonTapped() {
    }

    @objc private func datePickerValueChanged() {
        let weekday = Calendar.current.component(.weekday, from: datePickerView.date)-1
        var newCategories: [TrackerCategory] = []
        for category in categories {
            var trackers: [Tracker] = []
            for tracker in category.trackers {
                if tracker.schedule.contains(where: { $0 == weekday }) {
                    trackers.append(tracker)
                }
            }
            newCategories.append(TrackerCategory(name: category.name, trackers: trackers))
        }
        visibleCategories = newCategories
        collectionView.reloadData()
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
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell?.configureCell(with: tracker)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionReusableView
        view?.configureView(text: visibleCategories[indexPath.section].name)
        return view ?? UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - NewTrackerViewControllerDelegate
extension TrackersViewController: NewTrackerViewControllerDelegate {
    func addNewTracker(_ trackerCategory: TrackerCategory) {
        var newCategories: [TrackerCategory] = []

        if let categoryIndex = categories.firstIndex(where: { $0.name == trackerCategory.name }) {
            for (index, category) in categories.enumerated() {
                var trackers = category.trackers
                if index == categoryIndex {
                    trackers.append(contentsOf: trackerCategory.trackers)
                }
                newCategories.append(TrackerCategory(name: category.name, trackers: trackers))
            }
        } else {
            newCategories = categories
            newCategories.append(trackerCategory)
        }

        print(newCategories)
        categories = newCategories
        datePickerValueChanged()
        
        collectionView.reloadData()
    }
}
