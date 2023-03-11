import UIKit

class TrickViewController: BaseAccountViewController {
    
    let favoriteButton = UIButton()
    let doneTrickButton = UIButton()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    let trickName:String
    let transportType:TransportType
    lazy var viewModel = {
       TrickViewModel(trickName: trickName)
    }()
    var slides:[TrickSlide] = []
    
    private enum UIConstants {
        static let slidesCount = 3
        static let bottomAnchor = 20.0
        static let spaceBetweenBottomButtonAndPageControl = 20.0
        static let spaceBetweenPageControlAndSlide = 10.0
        static let favoriteImageConfigure = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        static let favoriteEmptyImage = UIImage(systemName: Resources.Images.emptyStar,withConfiguration: UIConstants.favoriteImageConfigure)
        static let favoriteFillImage = UIImage(systemName: Resources.Images.starFill,withConfiguration: UIConstants.favoriteImageConfigure)
        static let doneEmptyImage = UIImage(systemName: Resources.Images.square,withConfiguration:UIConstants.doneImageConfigure)
        static let doneCheckImage = UIImage(systemName: Resources.Images.checkedSquare,withConfiguration:UIConstants.doneImageConfigure)
        static let doneImageConfigure = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
    }
    
    init(trickName: String,transportType:TransportType) {
        self.trickName = trickName
        self.transportType = transportType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.loadTrickData(trickName: trickName, transportType: transportType)
        
        self.viewModel.serverErrorHandler = { errorMessage in
            self.present(self.createInfoAlert(message: errorMessage, title: Resources.Titles.errorTitle),animated: true)
        }
        
        self.viewModel.stateHandler = { state in
            switch state {
            case .successFetchData:
                self.configureFields()
            }
        }
    }
    
    override func userDataUpdate() {
        self.viewModel.configureUserFields(user: super.currentUser, doneButton: doneTrickButton, starButton: favoriteButton)
    }
}


//MARK: - Configure VC
extension TrickViewController {
    override func addViews() {
        self.view.addView(scrollView)
        self.view.addView(pageControl)
        self.view.addView(favoriteButton)
        self.view.addView(doneTrickButton)
    }
    
    override func configure() {
        super.configure()
        title = trickName
        
        self.slides = createTrickSlides()
        self.setupSlideScrollView(slides: slides)
    
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .gray
        view.bringSubviewToFront(pageControl)
        
        doneTrickButton.setTitle(Resources.Titles.done, for: .normal)
        doneTrickButton.setTitleColor(.link, for: .normal)
        doneTrickButton.setImage(UIConstants.doneEmptyImage, for: .normal)
        doneTrickButton.tintColor = .link
        doneTrickButton.semanticContentAttribute = .forceRightToLeft
        doneTrickButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        view.bringSubviewToFront(doneTrickButton)
        
        favoriteButton.setImage(UIConstants.favoriteEmptyImage, for: .normal)
        favoriteButton.tintColor = .systemYellow
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        view.bringSubviewToFront(favoriteButton)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            scrollView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            scrollView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: self.view.frame.height),
            scrollView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            favoriteButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            favoriteButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.bottomAnchor),
            doneTrickButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            doneTrickButton.bottomAnchor.constraint(equalTo: favoriteButton.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: favoriteButton.topAnchor, constant: -UIConstants.spaceBetweenBottomButtonAndPageControl)
        ])
    }
}


//MARK: - Private methods
extension TrickViewController {
    private func createTrickSlides() -> [TrickSlide] {
        var trickSlides = [TrickSlide]()
        for _ in 0..<UIConstants.slidesCount {
            let trickSlideView = TrickSlide()
            trickSlides.append(trickSlideView)
        }
        return trickSlides
    }
    
    private func setupSlideScrollView(slides:[TrickSlide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height / 1.5)
            scrollView.addSubview(slides[i])
        }
    }
    
    private func configureFields() {
        self.viewModel.configureViewFields(slides: slides)
    }
    
    @objc private func doneButtonTapped(_ sender:UIButton) {
        if doneTrickButton.imageView?.image == UIConstants.doneEmptyImage {
            self.viewModel.updateUserButtonState(user: super.currentUser, key: PrivateResources.usersDoneTricksKey, isEmpty: true)
            self.doneTrickButton.setImage(UIConstants.doneCheckImage, for: .normal)
        } else {
            self.viewModel.updateUserButtonState(user: super.currentUser, key: PrivateResources.usersDoneTricksKey, isEmpty: false)
            self.doneTrickButton.setImage(UIConstants.doneEmptyImage, for: .normal)
        }
    }
    
    @objc private func favoriteButtonTapped(_ sender:UIButton) {
        if favoriteButton.imageView?.image == UIConstants.favoriteEmptyImage {
            self.viewModel.updateUserButtonState(user: super.currentUser, key: PrivateResources.usersFavoriteTricksKey, isEmpty: true)
            self.favoriteButton.setImage(UIConstants.favoriteFillImage, for: .normal)
        } else {
            self.viewModel.updateUserButtonState(user: super.currentUser, key: PrivateResources.usersFavoriteTricksKey, isEmpty: false)
            self.favoriteButton.setImage(UIConstants.favoriteEmptyImage, for: .normal)
        }
    }
}


//MARK: - ScrollViewDelegete
extension TrickViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maxHorizontOffset:CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontOffset:CGFloat = scrollView.contentOffset.x
        
        let maxVerticalOffset:CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset:CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontOffset:CGFloat = currentHorizontOffset / maxHorizontOffset
        let percentageVerticalOffset:CGFloat = currentVerticalOffset / maxVerticalOffset
        
        let percentOffset:CGPoint = CGPoint(x: percentageHorizontOffset, y: percentageVerticalOffset)
        
        //FIXME: - Hardcode value 0.33 bc we have 3 slides
        if (percentOffset.x > 0 && percentOffset.x <= 0.33) {
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.33-percentOffset.x) / 0.33, y: (0.33-percentOffset.x) / 0.33)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x / 0.33, y: percentOffset.x / 0.33)
        }
    }
}
