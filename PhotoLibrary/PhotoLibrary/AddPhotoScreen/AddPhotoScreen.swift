
import UIKit

class AddPhotoScreen: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private var imageView: UIImageView!
    private var addButton: UIButton!
    private var seeButton: UIButton!
    private var infoLabel = UILabel()
    private var imageURLArray: [URL] = []
    private var imageArray: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton = UIButton()
        seeButton = UIButton()
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .black
        
        setupUI()
        addButton(button: addButton)
        addButton(button: seeButton)
    }
    
    @objc private func onAddButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func onSeeButton() {
        transitToAllPhotos()
    }
    
    private func setupUI() {
        imageView = UIImageView()
        
        let width: CGFloat = view.bounds.width
        let height: CGFloat = view.bounds.height / 2
        imageView.frame = CGRect(x: view.bounds.midX - width / 2 / 3,
                                 y: view.bounds.midY - height / 1.5 / 3,
                                 width: width / 3,
                                 height: height / 3)
        imageView.image = UIImage(named: "addphoto")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        infoLabel.font = UIFont(name: "AbrilFatface-Regular", size:20)
        infoLabel.textColor = .systemPink
        infoLabel.textAlignment = .center
        infoLabel.alpha = 0
        view.addSubview(infoLabel)
    }
    
    private func addButton(button: UIButton) {
        let width: CGFloat = 150
        let height: CGFloat = 45
        if button == addButton {
            button.frame = CGRect(x: view.bounds.midX - width / 2 - 100,
                                  y: view.bounds.maxY - width,
                                  width: width,
                                  height: height)
            button.titleLabel?.font = UIFont(name: "AbrilFatface-Regular", size:20)
            button.setTitle("ADD PHOTO", for: .normal)
            button.addTarget(self, action: #selector(onAddButton), for: .touchUpInside)
        } else {
            button.frame = CGRect(x: view.bounds.midX - width / 2 + 100,
                                  y: view.bounds.maxY - width,
                                  width: width,
                                  height: height)
            button.titleLabel?.font = UIFont(name: "AbrilFatface-Regular", size:20)
            button.setTitle("ALL PHOTOS", for: .normal)
            button.addTarget(self, action: #selector(onSeeButton), for: .touchUpInside)
        }
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = height / 2
        view.addSubview(button)
    }
    
    private func transitToAllPhotos() {
        let storyboard = UIStoryboard.init(name: "GalleryScreen", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as! GalleryScreen
        navigationController?.pushViewController(vc, animated: true)
        vc.arrayFromPicker = imageURLArray
        vc.arrayFromPickerImage = imageArray
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.frame = CGRect(x: view.bounds.midX - view.bounds.width / 2,
                                 y: view.bounds.midY - view.bounds.height / 3,
                                 width: view.bounds.width,
                                 height: view.bounds.height / 2)
        imageView.contentMode = .scaleAspectFit
        let image = info[.originalImage] as! UIImage
        let imageurl = info[.referenceURL] as! URL
        
        if imageURLArray.contains(imageurl) {
            infoLabel.frame = imageView.frame.offsetBy(dx: 0, dy: view.bounds.height / 2)
            infoLabel.frame.size = CGSize(width: view.bounds.width, height: 50)
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.infoLabel.alpha = 1
                self.infoLabel.text = "YOU ALREADY ADD THIS IMAGE"
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 2) {
                    self.infoLabel.alpha = 0
                }
            }
        } else {
            imageURLArray.append(info[.referenceURL] as! URL)
            imageArray.append(image)
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
}
