//
//  DetailViewController.swift
//  AppCakeDemo
//
//  Created by Admin on 10/10/22.
//

import UIKit
import SDWebImage
class DetailViewController: UIViewController {
    
    @IBOutlet weak var img_savebtn: UIImageView!
    @IBOutlet weak var img_animation: RoundedImageView!
    
    @IBOutlet weak var mainView: RoundedView!
    @IBOutlet weak var lbl_name: UILabel!
    let loader : UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .purple
        loadingIndicator.style = .medium
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loadingIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
          return loadingIndicator
    }()
    let alert : UIAlertController = {
        let alert = UIAlertController(title: "nil", message: "Saved Successfully", preferredStyle: .actionSheet)
        
        return alert
    }()
    var  model : CharacterRequest.CharacterModel?
    var image : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.addSubview(loader)
        loader.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true

        setData()

        checkSaved()
    }
    
    func setData(){
        loader.startAnimating()
        let url = model!.thumbnail_animated
        NetworkManager.shared.downloadImage(from: url) { image, data, error in
            let image = UIImage.sd_image(withGIFData: data)
            DispatchQueue.main.async {
                self.img_animation.image = image
                self.image = image
                self.loader.stopAnimating()
            }
        }
        lbl_name.text = model?.name
    }
    func checkSaved(){
        if CoreDataModel.shared.checkIsAvaibleInCoreData(id: model!.id) {
            img_savebtn.image = UIImage(named: "Vector")

        }else{
            img_savebtn.image = UIImage(named: "Vector2")
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        guard let inputImage = image else { return }
        UIImageWriteToSavedPhotosAlbum(inputImage, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alertContorller = UIAlertController.init(title: nil, message: "Saved Successfully", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
        })
        alertContorller.addAction(okAction)
        self.present(alertContorller, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        CoreDataModel.shared.checkAndDelete(model: model!)
        DispatchQueue.main.async {
            self.checkSaved()
        }
    }
}

