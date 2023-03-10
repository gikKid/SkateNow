import UIKit

class StudyListViewController: BaseAccountViewController {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    lazy var viewModel = {
      StudyViewModel()
    }()
    
    private enum UIConstants {
        static let defaultCountCells = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.stateHandler = { state in
            switch state {
            case .fetching:
                self.refreshCollection()
            case .failureFetch:
                self.present(self.createInfoAlert(message: "Failure to fetch data", title: Resources.Titles.errorTitle), animated: true)
            case .successFetch:
                self.refreshCollection()
            case .filterSearch:
                self.refreshCollection()
            }
        }
        
        self.viewModel.errorServerHandler = { errorMessage in
            self.present(self.createInfoAlert(message: errorMessage, title: Resources.Titles.errorTitle), animated: true)
        }
    }
    
    override func userDataUpdate() {
        self.viewModel.fetchData(super.currentUser)
    }
}


//MARK: - Configure VC
extension StudyListViewController {
    override func addViews() {
        self.view.addView(collectionView)
        self.view.addView(searchBar)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = false
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionLayout()
        collectionView.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Identefiers.studyCollectionViewCell)
        collectionView.keyboardDismissMode = .onDrag
        
        refreshControl.tintColor = UIColor(named: Resources.Colors.mainColor)
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - Private methods
extension StudyListViewController {
    private func createCompositionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout{ [weak self] (_, _) -> NSCollectionLayoutSection? in
            return self?.layoutSection()
        }
    }
    
    private func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 15
        return section
    }
    
    private func refreshCollection() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func refreshContent() {
        self.searchBar.text?.removeAll()
        self.viewModel.fetchData(super.currentUser)
    }
}



//MARK: - CollectionMethods
extension StudyListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel.numberOfItemsInSection() == 0 && self.viewModel.state != .filterSearch) ? UIConstants.defaultCountCells : self.viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Identefiers.studyCollectionViewCell, for: indexPath) as? StudyCollectionViewCell else {return UICollectionViewCell()}
        switch self.viewModel.state {
        case .fetching:
            cell.setShimmer()
        case .successFetch:
            let cellModel = self.viewModel.getCellModel(indexPath)
            cell.configureCell(cellModel)
        case .filterSearch:
            let cellModel = self.viewModel.getCellModel(indexPath)
            cell.configureCell(cellModel)
        default:
            break
        }
        return cell
    }
}

//MARK: - SearchBarDelegate
extension StudyListViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.sortSearch(text: searchText)
    }
}
