//
//  ViewController.swift
//  CompositionalLayout-DiffableDataSource
//
//  Created by Jinyoung Yoo on 7/20/24.
//

import UIKit
import SnapKit
import Then

class SettingListViewController: UIViewController {
    
    enum Section: CaseIterable {
        case total
        case personal
        case extra
        
        var list: [String] {
            switch self {
            case .total:
                return ["공지사항", "실험실", "버전 정보"]
            case .personal:
                return ["개인/보안", "알림", "채팅", "멀티프로필"]
            case .extra:
                return ["고객센터/도움말"]
            }
        }
        
        var header: String {
            switch self {
            case .total:
                return "전체 설정"
            case .personal:
                return "개인 설정"
            case .extra:
                return "기타"
            }
        }
    }

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        configureDataSource()
        updateSnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)

        configuration.backgroundColor = .black
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let registration: UICollectionView.CellRegistration<UICollectionViewListCell, String> = UICollectionView.CellRegistration { cell, indexPath, text in

            var content = UIListContentConfiguration.valueCell()
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()

            content.text = text
            content.textProperties.color = .white
            content.textProperties.font = .systemFont(ofSize: 15)
            backgroundConfiguration.backgroundColor = .black
            cell.contentConfiguration = content
            cell.backgroundConfiguration = backgroundConfiguration
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            
            var content = UIListContentConfiguration.groupedHeader()
            content.text = Section.allCases[indexPath.section].header
            content.textProperties.color = .lightGray
            content.textProperties.font = .boldSystemFont(ofSize: 17)
            supplementaryView.contentConfiguration = content
        }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewListCell() }
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        self.dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach {
            snapshot.appendItems($0.list, toSection: $0)
        }
        dataSource?.apply(snapshot)
    }

}

