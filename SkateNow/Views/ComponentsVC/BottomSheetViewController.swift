import UIKit

class BottomSheetViewController: BaseViewController {

    public lazy var containerView = UIView() // keep contants
    private lazy var dimmedView = UIView() // top backg View
    private var containerViewHeightConstraint:NSLayoutConstraint?
    private var containerViewBottomConstraint:NSLayoutConstraint?
    private var currentContainerHeight:CGFloat = 300
    
    private enum UIConstans {
        static let maxDimmedAlpha:CGFloat = 0.6
        static let defaultHeight:CGFloat = 300
        static let dismissibleeHeight:CGFloat = 200
        static let maximumContainerHeight:CGFloat = UIScreen.main.bounds.height - 45
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateShowDimmedView()
        self.animatePresentContainer()
    }
    
}

extension BottomSheetViewController {
    override func addViews() {
        self.view.addView(dimmedView)
        self.view.addView(containerView)
    }
    
    override func configure() {
        super.configure()
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        
        self.view.backgroundColor = .clear
        dimmedView.isOpaque = false
        dimmedView.backgroundColor = .black
        dimmedView.alpha = UIConstans.maxDimmedAlpha
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: self.view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: UIConstans.defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: UIConstans.defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
}

extension BottomSheetViewController {
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.dimmedView.alpha = UIConstans.maxDimmedAlpha
        })
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false // to imiidiately listen on gesture movement
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    private func animateContainerHeight(_ height:CGFloat) {
        UIView.animate(withDuration: 0.4, animations: {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        })
        currentContainerHeight = height
    }
}

extension BottomSheetViewController {
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: view) // y offset will be minus if the dragging to top
        let isDraggingDown = transition.y > 0
        
        let newHeight = currentContainerHeight - transition.y
        
        switch gesture.state {
        case .changed:
            if newHeight < UIConstans.maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < UIConstans.dismissibleeHeight {
                self.animateDismissView()
            }
            else if newHeight < UIConstans.defaultHeight {
                self.animateContainerHeight(UIConstans.defaultHeight)
            }
            else if newHeight > UIConstans.defaultHeight && !isDraggingDown {
                // if the new height is below max and going up, set to max height at top
                animateContainerHeight(UIConstans.maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    @objc private func handleCloseAction() {
        animateDismissView()
    }
}


@objc extension BottomSheetViewController {
    public func animateDismissView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerViewBottomConstraint?.constant = UIConstans.defaultHeight
            self.view.layoutIfNeeded()
        })
        
        dimmedView.alpha = UIConstans.maxDimmedAlpha
        UIView.animate(withDuration: 0.4, animations: {
            self.dimmedView.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }
}
