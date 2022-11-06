
import UIKit

class GalleryScreen: UIViewController {
    
    var arrayFromPicker: [URL] = []
    var arrayFromPickerImage: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .init(hexString: "#F2E7D5")
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
        
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.itemSize = CGSize(width: view.bounds.width / 3 - 7,
                                     height: view.bounds.width / 3 - 7)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layoutFlow)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .init(hexString: "#393E46")
        
        view.addSubview(collectionView)
    }
}

extension GalleryScreen: UICollectionViewDelegate & UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayFromPickerImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageView = UIImageView()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        imageView.image = arrayFromPickerImage[indexPath.item]
        imageView.frame.size = CGSize(width: cell.bounds.width,
                                      height: cell.bounds.height)
        imageView.contentMode = .scaleToFill
        cell.contentView.addSubview(imageView)
        return cell
    }
}
