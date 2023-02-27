import Foundation
import UIKit

final class MenuViewModel:NSObject {
    
    let menuContent:[MenuCellOption] = [MenuCellOption(title: Resources.Titles.game, image: UIImage(systemName: Resources.Images.game,withConfiguration: UIImage.SymbolConfiguration(scale: .large))),MenuCellOption(title: Resources.Titles.study, image: UIImage(systemName: Resources.Images.study,withConfiguration: UIImage.SymbolConfiguration(scale: .large))),MenuCellOption(title: Resources.Titles.map, image: UIImage(systemName: Resources.Images.map,withConfiguration: UIImage.SymbolConfiguration(scale: .large))),MenuCellOption(title: Resources.Titles.profile, image: UIImage(systemName: Resources.Images.person,withConfiguration: UIImage.SymbolConfiguration(scale: .large)))]
    
    var showView: ((String) -> Void)?
    
    public func numberOfSections() -> Int {
        1
    }
    
    public func numberOfItemsInSection() -> Int {
        self.menuContent.count
    }
    
    public func cellForItemAt(collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Identefiers.menuCollecionViewCell, for: indexPath) as? MenuCollectionViewCell else {return UICollectionViewCell()}
        cell.setup(with: self.menuContent[indexPath.row])
        return cell
    }
    
    public func didSelectItemAt(indexPath: IndexPath) {
        self.showView?(self.menuContent[indexPath.row].title)
    }
}
