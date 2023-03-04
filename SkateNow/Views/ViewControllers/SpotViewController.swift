import UIKit
import MapKit

class SpotViewController: BottomSheetViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let closeButton = UIButton()
    let spot:Spot
    lazy var viewModel = {
       SpotViewModel()
    }()
    
    private enum SpotVCConstants {
        static let sectionCount = 5
    }
    
    init(spot:Spot) {
        self.spot = spot
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.errorServerHandler = {[weak self] errorMessage in
            guard let self = self else {return}
            self.present(self.createInfoAlert(message: errorMessage, title: Resources.Titles.errorTitle),animated: true)
        }
    }
}

//MARK: - ConfigureVC
extension SpotViewController {
    override func addViews() {
        super.addViews()
        self.containerView.addView(collectionView)
        self.containerView.addView(closeButton)
    }
    
    override func configure() {
        super.configure()

        closeButton.setTitle(Resources.Titles.close, for: .normal)
        closeButton.setTitleColor(UIColor(named: Resources.Colors.mainColor) ?? .systemOrange, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionLayout()
        collectionView.register(TitleSpotCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Identefiers.titleSpotCollectionViewCell)
        collectionView.register(PreferredTypeCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Identefiers.preferredTypeSpotCollectionViewCell)
        collectionView.register(ImageSpotCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Identefiers.imageSpotCollectionViewCell)
        collectionView.register(FullInfoCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Identefiers.fullInfoSpotCollectionViewCell)
        collectionView.register(ButtonsSpotCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Identefiers.buttonsSpotCollectionViewCell)
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
            closeButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10),
            collectionView.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor,constant: 15),
            collectionView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ])
    }
}


//MARK: - Buttons methods
extension SpotViewController {
    @objc private func closeButtonTapped(_ sender:UIButton) {
        self.animateDismissView()
    }
}


//MARK: - Private methods
extension SpotViewController {
    private func createCompositionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout{ [weak self] (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.titleLayoutSection()
            case 1:
                return self?.titleLayoutSection()
            case 2:
                return self?.imageLayoutSection()
            case 3:
                return self?.fullInfoLayoutSection()
            case 4:
                return self?.buttonsLayoutSection()
            default:
                return nil
            }
        }
    }
    
    private func titleLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func imageLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func fullInfoLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func buttonsLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}


//MARK: - CollectionViewMethods
extension SpotViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        SpotVCConstants.sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Identefiers.titleSpotCollectionViewCell, for: indexPath) as? TitleSpotCollectionViewCell else {return UICollectionViewCell()}
            cell.configureCell(text: spot.title ?? "")
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Identefiers.preferredTypeSpotCollectionViewCell, for: indexPath) as? TitleSpotCollectionViewCell else {return UICollectionViewCell()}
            cell.configureCell(text: "Preferred: \(spot.prefferedTransport ?? "")")
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Identefiers.imageSpotCollectionViewCell, for: indexPath) as? ImageSpotCollectionViewCell else {return UICollectionViewCell()}
            cell.showSpinner()
            self.viewModel.loadImage(imageURL: spot.imageURL, cell: cell)
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Identefiers.fullInfoSpotCollectionViewCell, for: indexPath) as? FullInfoCollectionViewCell else {return UICollectionViewCell()}
            cell.configureCell(text: spot.fullInfo ?? "")
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Identefiers.buttonsSpotCollectionViewCell, for: indexPath) as? ButtonsSpotCollectionViewCell else {return UICollectionViewCell()}
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}



//MARK: - ButtonsSpotDelegate
extension SpotViewController:ButtonsSpotCollectionViewCellProtocol {
    func createActivityVC() {
        var shareData = [Any]()
        let message = "Name: \(spot.title ?? "")\n Info: \(spot.fullInfo ?? "")\n Coordinate:\n latitude: \(spot.coordinate.latitude)\n longitude: \(spot.coordinate.longitude)"
        shareData.append(message)
        
        if let image = self.viewModel.image {
            shareData.append(image)
        }
        let activityVC = UIActivityViewController(activityItems: shareData, applicationActivities: nil)
        activityVC.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.print,
                                            UIActivity.ActivityType.saveToCameraRoll,
                                            UIActivity.ActivityType.addToReadingList]
        activityVC.isModalInPresentation = true
        self.present(activityVC,animated: true)
    }
    
    func showRoute() {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        spot.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}
