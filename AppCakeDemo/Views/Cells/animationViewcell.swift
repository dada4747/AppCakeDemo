//
//  animationViewcell.swift
//  AppCakeDemo
//
//  Created by Admin on 10/10/22.
//

import UIKit
import SDWebImage
protocol SaveAnimationProtocol {
    func saveCharacter(model: CharacterRequest.CharacterModel)
}
class animationViewcell: UICollectionViewCell {

    @IBOutlet weak var img_image: RoundedImageView!
    @IBOutlet weak var img_button: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    
    var model : CharacterRequest.CharacterModel?
    var delegate : SaveAnimationProtocol?
    let alert : UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .purple
        loadingIndicator.style = .medium
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loadingIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
          return loadingIndicator
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(alert)
        alert.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        alert.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//
        // Initialization code
    }
    func configureUI(model: CharacterRequest.CharacterModel){
        if CoreDataModel.shared.checkIsAvaibleInCoreData(id: model.id) {
            img_button.image = UIImage(named: "Vector")

        }else{
            img_button.image = UIImage(named: "Vector2")
        }
        self.model = model
        alert.startAnimating();

        NetworkManager.shared.downloadImage(from: model.thumbnail) { image, data, error in
            DispatchQueue.main.async {
                self.img_image.image = image
                self.alert.stopAnimating();

            }
        }
//        self.img_image.sd_setImage(with: url)
        lbl_name.text = model.name
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        print("saved to defaultArray")
        delegate?.saveCharacter(model: model!)
        
//        img_button.image = UIImage(named: "Vector2")
        
    }
}
