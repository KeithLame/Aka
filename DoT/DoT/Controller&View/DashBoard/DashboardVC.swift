//
//  DashboardViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

final class DashboardViewController: BaseViewController<DashboardView> {

    var diffableDataSoure: UICollectionViewDiffableDataSource<DashboardCompositionalLayout, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func configureCollectionView() {
        layoutView.dashboardCollectionView.register(IntroCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
     
        diffableDataSoure = UICollectionViewDiffableDataSource(collectionView: layoutView.dashboardCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? IntroCollectionViewCell else { preconditionFailure() }
            
            return cell
        }
    }
    
    override func configureNavigation() {
        
        navigationItem.leftBarButtonItem = makeLeftBarButtonItem()
        navigationItem.rightBarButtonItem = makeRightBarButtonItem()
    }
}

extension DashboardViewController {
    
    private func update() {
        
        var snapshot = NSDiffableDataSourceSnapshot<DashboardCompositionalLayout, String>()
        snapshot.appendSections([.intro])
        snapshot.appendItems(["0"], toSection: .intro)
        self.diffableDataSoure.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeRightBarButtonItem() -> UIBarButtonItem {
        
        let title = "새로운 여행"
        
        var titleAttr = AttributedString.init(title)
        titleAttr.font = FontManager.getFont(size: .small, scale: .Bold)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        let createTripCustomView = UIButton()
        
        let buttonImage = UIImage.plane.withTintColor(.blackWhite, renderingMode: .alwaysOriginal)
        
        buttonConfiguration.image = buttonImage
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.imagePlacement = .leading
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttr
        buttonConfiguration.baseForegroundColor = .blackWhite
        buttonConfiguration.baseBackgroundColor = .clear
        
        createTripCustomView.configuration = buttonConfiguration
        createTripCustomView.addTarget(self, action: #selector(createTripButtonClicked), for: .touchUpInside)
        
        let createTripBarButton = UIBarButtonItem(customView: createTripCustomView)
        return createTripBarButton
    }
    
    private func makeLeftBarButtonItem() -> UIBarButtonItem {
        
        let symbolImage = UIImage.symbol
        
        let symbolBarButtonItem = UIBarButtonItem(image: symbolImage, style: .plain, target: self, action: nil)
        
        return symbolBarButtonItem
    }
    
    @objc private func createTripButtonClicked() {
        
        let nextVC = CreateTripViewController()
        let naviVC = UINavigationController(rootViewController: nextVC)
        
        present(naviVC, animated: true)
    }
}
