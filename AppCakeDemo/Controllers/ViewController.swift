//
//  ViewController.swift
//  AppCakeDemo
//
//  Created by Admin on 10/10/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBOutlet weak var lbl_title: UILabel!
    //MARK: - Varibles
    var array : [String] = ["Characters", "Animation", "Saved"]
    var selectedIndex : Int = 0
    var viewModel = CharacterViewModel()
    var limit : Int = 1
    let footerViewReuseIdentifier = "RefreshFooterView"
    var isLoading : Bool = false
    var footerView : CustomFooterView?
    //MARK: -
    let alert : UIAlertController = {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .purple
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor).isActive = true
        return alert
    }()
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        present(alert, animated: true, completion: nil)
        loadData(type: "C", limit: 1)
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView1.layoutIfNeeded()
        collectionView2.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView1.reloadData()
        collectionView2.reloadData()
    }
    
    //MARK: - Methods
    func setUpCollectionView(){
        collectionView1.delegate = self
        collectionView1.dataSource = self
        // register...
        collectionView1.register(UINib.init(nibName: "categoryCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        collectionView2.delegate = self
        collectionView2.dataSource = self
        // register...
        collectionView2.register(UINib.init(nibName: "animationViewcell", bundle: nil), forCellWithReuseIdentifier: "animationViewcell")
        collectionView2.register(UINib.init(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
    }
    func loadData(type: String, limit: Int){
        
        if type == "C" {
            viewModel.requestCharacters(limit: limit)
            reloadData()
        } else if type == "A" {
            viewModel.requestAnimations(limit: limit)
            reloadData()
        }else {
            viewModel.requestSaved(limit: limit)
            reloadData()
        }
    }
    func reloadData(){
        viewModel.reloadList = {
            DispatchQueue.main.async {
                self.collectionView2.reloadData()
                self.dismiss(animated: true)
            }
        }
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1 {
            let width = (collectionView1.frame.size.width/2) - 5
            return CGSize(width: width, height: 49)
            
        }else if collectionView == collectionView2  {
            let itemsize = (self.collectionView2.frame.size.width / 2) - 5.5
            return CGSize(width: itemsize, height: 218)
        }else{
            return CGSize (width: 0, height: 0)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1{
            return array.count
        }else {
            return viewModel.arrayOfList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! categoryCell
            
            if selectedIndex == indexPath.row {
                cell.setupView(isSelect: true)
            } else {
                cell.setupView(isSelect: false)
            }
            cell.lbl_title.text = array[indexPath.row]
            return cell
            
        } else {
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animationViewcell", for: indexPath as IndexPath) as! animationViewcell
            cell.img_image.image = UIImage(named: "placeholder")
            cell.configureUI(model: viewModel.arrayOfList[indexPath.row])
            cell.delegate = self
            cell.selectedBackgroundView = nil
//            cell.selectionStyle = .none

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView1 {
            selectedIndex = indexPath.row
            self.viewModel.arrayOfList.removeAll()

            if selectedIndex == 0 {
                limit = 1
                present(alert, animated: true, completion: nil)
                self.loadData(type: "C",limit: limit)
            } else if selectedIndex == 1 {
                limit = 1
                present(alert, animated: true, completion: nil)
                self.loadData(type: "A",limit: limit)
            }else {
                limit = 1
                present(alert, animated: true, completion: nil)
                self.loadData(type: "S",limit: limit)
            }
            self.collectionView1.reloadData()
            self.lbl_title.text = array[indexPath.row]
            DispatchQueue.main.async {
                self.collectionView2.resetScrollPositionToTop()
            }
        } else {
//            present(alert, animated: true, completion: nil)
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.model = viewModel.arrayOfList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: false)
//            SDWebImageDownloader.shared.downloadImage(with: URL.init(string: imageUrl)!) { imag, data, err, bool in
//                if err == nil {
//
//                    vc.image = imag
//                    self.navigationController?.pushViewController(vc, animated: false)
//                    self.dismiss(animated: true)
//                }
//            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.collectionView1 {
            return CGSize.zero
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == self.collectionView2 {
            if isLoading {
                return CGSize.zero
            }
            return CGSize(width: collectionView.bounds.size.width, height: 40)
        }
        else {
            return CGSize.zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == self.collectionView2 {
            
            if kind == UICollectionView.elementKindSectionFooter {
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
                self.footerView = aFooterView
                self.footerView?.backgroundColor = UIColor.clear
                return aFooterView
            } else {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
                return headerView
            }
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if collectionView == self.collectionView2 {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.footerView?.prepareInitialAnimation()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if collectionView == self.collectionView2 {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.footerView?.stopAnimate()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
//        print("pullRation:\(pullRatio)")
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
//        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0 {
            guard let footerView = self.footerView, footerView.isAnimatingFinal else {
                return
            }
            self.isLoading = true
            self.footerView?.startAnimate()
            self.limit += 1
            if self.selectedIndex == 0 {
                self.loadData(type: "C",limit: self.limit)
            } else if self.selectedIndex == 1 {
                self.loadData(type: "A",limit: self.limit)
            }else {
                self.loadData(type: "S", limit: self.limit)
            }
            self.isLoading = false
        }
    }
}
extension ViewController : SaveAnimationProtocol {
    func saveCharacter(model: CharacterRequest.CharacterModel) {
        CoreDataModel.shared.checkAndDelete(model: model)
        if self.selectedIndex == 2 {
            self.loadData(type: "S", limit: self.limit)
        } else {
            DispatchQueue.main.async {
                self.collectionView2.reloadData()
        }    }
    }
}
