import UIKit

class MenuViewController: BaseAccountViewController {
    
    let menuCollectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewLayout())
    
    lazy var viewModel = {
       MenuViewModel()
    }()
    
    private enum UIConstants {
        static let topAnchorMenuCollect = 10.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.showView = {[weak self] viewName in
            switch viewName {
            case Resources.Titles.game:
                break
            case Resources.Titles.study:
                break
            case Resources.Titles.map:
                self?.navigationController?.pushViewController(MapViewController(), animated: true)
                break
            case Resources.Titles.profile:
                self?.navigationController?.pushViewController(ProfileViewController(), animated: true)
                break
            default:
                break
            }
        }
    }
}

//MARK: - Configure VC
extension MenuViewController {
    override func addViews() {
        view.addView(menuCollectionView)
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.menu
        
        menuCollectionView.showsVerticalScrollIndicator = false
        menuCollectionView.backgroundColor = .clear
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.collectionViewLayout = createCompositionLayout()
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Identefiers.menuCollecionViewCell)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topAnchorMenuCollect),
            menuCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            menuCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            menuCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - Private methods
extension MenuViewController {
    private func createCompositionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout{ [weak self] (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.menuLayoutSection()
            default:
                return nil
            }
        }
    }
    
    private func menuLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 15
        
        return section
    }
    
}


//MARK: - CollectionView methods
extension MenuViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.viewModel.cellForItemAt(collectionView: collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelectItemAt(indexPath: indexPath)
    }
    
}
