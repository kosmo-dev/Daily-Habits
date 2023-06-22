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
    private var visibleCategories: [TrackerCategory] = [TrackerCategory(name: "1", trackers: [Tracker(id: UUID(), name: "1", color: .colorSelection5, emoji: "❤️", schedule: "")])]
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
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        let viewController = NewTrackerTypeChoosingViewController()
        let modalNavigationController = UINavigationController(rootViewController: viewController)
        navigationController?.present(modalNavigationController, animated: true)
    }
    
    @objc private func rightBarButtonTapped() {
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = visibleCategories.reduce(0) { $0 + $1.trackers.count }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardCollectionViewCell
        cell?.configureCell()
        return cell ?? UICollectionViewCell()
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
}
