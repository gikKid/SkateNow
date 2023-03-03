import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    
    private enum UIConstants {
        static let backgroundWidth = 100.0
    }

    override func loadView() {
        view = UIView()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray5
        backgroundView.layer.opacity = 0.8
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10
        view.addView(backgroundView)
        
        spinner.color = .darkGray
        spinner.startAnimating()
        backgroundView.addView(spinner)
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: UIConstants.backgroundWidth),
            backgroundView.heightAnchor.constraint(equalTo: backgroundView.widthAnchor),
            spinner.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
    }
}
