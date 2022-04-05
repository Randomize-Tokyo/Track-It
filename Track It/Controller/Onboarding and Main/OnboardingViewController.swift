//
//  OnboardingViewController.swift
//  Yummie
//
//  Created by Emmanuel Okwara on 30/01/2021.
//
import UIKit
import Firebase

class OnboardingViewController: UIViewController
{
    
    static var storyBoardID = "OnboardingViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] =
    [
        OnboardingSlide(title: "Welcome", description: "Welcome to Track it, the all in one package tracker.", image: #imageLiteral(resourceName: "transparantLogo")),
        OnboardingSlide(title: "Convenience", description: "Keep track of all your packages from major carriers all in one place.", image: #imageLiteral(resourceName: "selectCarrierImage")),
        OnboardingSlide(title: "Get Notified", description: "Know when Know when your package is in transit and arrives. Will help you stay on top of things. Well let you know of any delays and expected delivery day/time.", image: #imageLiteral(resourceName: "notificationIcon"))
    ]
    
    var currentPage = 0
    {
        didSet
        {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1
            {
                nextBtn.setTitle("Get Started", for: .normal)
            }
            else
            {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    
    
    @IBAction func nextBtnClicked(_ sender: UIButton)
    {
        if currentPage == slides.count - 1
        {
            //Final Tab on Page Control
            let storyBoard: UIStoryboard = UIStoryboard(name: "LoginViewController", bundle: nil)
            let addBarcodeViewController = storyBoard.instantiateViewController(withIdentifier: LoginViewController.storyBoardID) as! LoginViewController
            self.navigationController?.pushViewController(addBarcodeViewController, animated: true)
            
            //User Signed out: App tends to retain user login if user did not sign out before deleting the app
            if Auth.auth().currentUser != nil
            {
                do
                   {
                       try Auth.auth().signOut()
                       
                   }
                   catch let error as NSError
                   {
                       print(error.localizedDescription)
                   }
                
                
            }
            
            
            
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched") //Bool
            
            
        }
        else
        {
            //Anything but the last tab on the Page Control
            
            
         currentPage += 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            
        }
    }
    
}

//MARK: - View Did Function and Setup
extension OnboardingViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }
    
    func setup()
    {
        //Set Page Control from # of Slide
        pageControl.numberOfPages = slides.count
        
        //Hide the Back button
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}

//MARK: - UITABLE View Collection Functions
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //Sets the Number of Collection View Cells to be dislayed
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
