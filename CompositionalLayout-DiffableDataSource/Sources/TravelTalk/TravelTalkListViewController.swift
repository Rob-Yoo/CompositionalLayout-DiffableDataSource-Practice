//
//  TravelTalkListViewController.swift
//  CompositionalLayout-DiffableDataSource
//
//  Created by Jinyoung Yoo on 7/21/24.
//

import UIKit
import SnapKit

struct ChattingRoom: Hashable, Identifiable {
    let id = UUID()
    let message: String
    let name: String
    let date: String
}

class TravelTalkListViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ChattingRoom>?
    
    private var chatList = [
        ChattingRoom(message: "액션가면 보자", name: "Hue", date: "24.01.12"),
        ChattingRoom(message: "새로 모은 돌이야", name: "Jack", date: "24.01.12"),
        ChattingRoom(message: "알았어... ㅠㅠ", name: "Bran", date: "24.01.11"),
        ChattingRoom(message: "오늘은 학원 가야 해서 안 돼", name: "Den", date: "24.01.10"),
        ChattingRoom(message: "토끼가 생각나는 하루네", name: "내옆의앞자리에개발잘하는친구", date: "24.01.09"),
        ChattingRoom(message: "아닛 주말과제라닛", name: "심심이", date: "24.01.08")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        configureDataSource()
        updateSnapshot()
    }

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        configuration.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let registration: UICollectionView.CellRegistration<UICollectionViewListCell, ChattingRoom> = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            
            content.text = itemIdentifier.name
            content.textProperties.numberOfLines = 1
            content.textProperties.color = .black
            content.textProperties.font = .boldSystemFont(ofSize: 15)
            
            content.secondaryText = itemIdentifier.message
            content.secondaryTextProperties.numberOfLines = 1
            content.secondaryTextProperties.font = .systemFont(ofSize: 14)
            content.secondaryTextProperties.color = .lightGray
            
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 5
            
            content.image = UIImage(systemName: "person.fill")
            content.imageProperties.tintColor = .systemGreen
            
            backgroundConfiguration.backgroundColor = .white
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration = backgroundConfiguration
        }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChattingRoom>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(chatList, toSection: 0)
        dataSource?.apply(snapshot)
    }
}
