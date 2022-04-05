//
//  ViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/15/22.
//
import UIKit
import CoreData
import Firebase

//MARK: - Main Class
class HomeViewController: UIViewController
{
    
    static var storyBoardID = "HomeViewController"
    
    //MARK: - Variables and Constants
    var packages = [PackageObject]()
    var filteredPackages: [PackageObject] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    //-------Search Bar Variables
    let searchController = UISearchController(searchResultsController: nil)
    
    //Computed Property for Search Bar
    var isSearchBarEmpty: Bool
    {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    //Used to determine if iser are currently filtering for search results
    var isFiltering: Bool
    {
      return searchController.isActive && !isSearchBarEmpty
    }
    //--------End Search Bar Variables

    
    
    let refreshControl = UIRefreshControl()
    
    
    let database = Firestore.firestore()
   
    
    //Variables
    private var isSideMenuShown:Bool = false
    var hasAlreadyLaunched: Bool!
    
    //IBOUTLETS
    @IBOutlet weak var packageTableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var sideMenuBackView: UIView!
    @IBOutlet weak var leadingConstraintSideMenuView: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UIView!
    
    //IBACTIONS
    @IBAction func settinngsButtonPressed(_ sender: Any)
    {
       showMenuBar()
    }

    @IBAction func tappedOnSideMenueBackView(_ sender: Any)
    {
        hideSideView()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addBarcodeViewController = storyBoard.instantiateViewController(withIdentifier: AddTrakingNumberViewController.storyBoardID) as! AddTrakingNumberViewController
        
        addBarcodeViewController.modalPresentationStyle = .fullScreen
        addBarcodeViewController.launchBarcodeViewController = true
        
        navigationController?.pushViewController(addBarcodeViewController, animated: true)
    }
    
    @IBAction func addBarcodeButtonPressed(_ sender: Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addBarcodeViewController = storyBoard.instantiateViewController(withIdentifier: AddTrakingNumberViewController.storyBoardID) as! AddTrakingNumberViewController
        
        addBarcodeViewController.modalPresentationStyle = .popover
      
        
        navigationController?.pushViewController(addBarcodeViewController, animated: true)
    }
}

//MARK: - View Did Functions
extension HomeViewController
{
    
   

    override func viewWillAppear(_ animated: Bool) {
       print("in the view did appear function")
        
    
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
      
    }
    
   

}

//MARK: - Setup Function
extension HomeViewController
{
    func setup()
    {
        loadTrackingNumber()
        setUpNavigationTitle()
        setUpTableView()
        setupNotificationCenter()
        setupRefreshControl()
        setupSearchBar()
        hideIfNoPackage()
        self.dismissKeyboard() //Dismiss keyboard when not inside the UITextfield
       
    
        
    }
    

}

//MARK: - Table View Functions DataSource and Relevant Functions
extension HomeViewController: UITableViewDataSource
{
    func hideIfNoPackage()
    {
       
        if(packages.count == 0 )
          {
              packageTableView.isHidden = true
            navigationItem.searchController = nil //Hides the search bar
            
          }
            else
            {
              packageTableView.isHidden = false
                navigationItem.searchController = searchController //unhides the search bar
            }
          
    }
    
    
    func setUpTableView()
    {
        registerTableViewCells()
        configureTableView()
    }
    private func registerTableViewCells()
    {
        let textFieldCell = UINib(nibName: PackageTableViewCell.classIdentifier,bundle: nil)
        self.packageTableView.register(textFieldCell,forCellReuseIdentifier: PackageTableViewCell.cellIdentifier)
    }
    
    func configureTableView()
    {
        //Make Table View Look Nice
        packageTableView.showsVerticalScrollIndicator = false
        packageTableView.separatorStyle = .none  //Hides the lines
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isFiltering
        {
           return filteredPackages.count
         }
           
      
        return packages.count
    }

    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Create a represnetation of the cell to be usesd.
        let cell = packageTableView.dequeueReusableCell(withIdentifier: PackageTableViewCell.cellIdentifier) as! PackageTableViewCell
        
        //A Package object is decleared.
        let aPackage: PackageObject
        
        if isFiltering 
        {
            aPackage = filteredPackages[indexPath.row]
        }
        else
        {
            aPackage = packages[indexPath.row]
        }
        
        
       
        cell.carrierNameAndTracking.text = aPackage.packageCarrier! + ": " + aPackage.trackingNumber!
        
        cell.packageDescription.text = aPackage.packageDescription
        cell.logoImage.image = UIImage(named: aPackage.carrierLogoName!.lowercased())
        cell.packageCurrentDescription.text = aPackage.currentDescription! //Good
        cell.circleIndicator.tintColor = UIColor(named:  aPackage.circleIndicatorColor! )

        
        return cell

    }
}

//MARK: - Table View Functions Delgate and Relevant Functions
extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let package = packages[indexPath.row]
            context.delete(package) //remove from context
            packages.remove(at: indexPath.row) //remove from the array
            tableView.deleteRows(at: [indexPath], with: .fade) //remove from the table view
            saveTrackingNumber()
            hideIfNoPackage()
            
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let packageView = storyBoard.instantiateViewController(withIdentifier: PackageViewController.storyBoardID) as! PackageViewController

        //Passing the package to the View Controller
        
        
        //A Package object is decleared.
        let aPackage: PackageObject
        
        if isFiltering
        {
            aPackage = filteredPackages[indexPath.row]
        }
        else
        {
            aPackage = packages[indexPath.row]
        }
        
        packageView.passedPackage = aPackage
        packageView.modalPresentationStyle = .fullScreen
        packageView.modalTransitionStyle = .crossDissolve
        tableView.deselectRow(at: indexPath, animated: true)
        packageView.modalPresentationStyle = .popover
       navigationController?.pushViewController(packageView, animated: true)
    
    }
    
    
    
}

//MARK: - Refresh Contol
extension HomeViewController
{
    func setupRefreshControl()
    {
        registerRefreshControl()
    }
  
    func registerRefreshControl()
    {
        if #available(iOS 10.0, *)
        {
            packageTableView.refreshControl = refreshControl
        } else {
            packageTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data", attributes: nil)
        refreshControl.tintColor = .darkGray
    }
    
    @objc private func refreshData(_ sender: Any)
    {
        // Fetch Weather Data
        
        fetchData()
        refreshControl.endRefreshing()
    
    }
    
    private func fetchData()
    {
        DispatchQueue.main.async //Runs in the background
        {
            for package in self.packages
            {
                
                if package.delivered == false
                {
                    DispatchQueue.main.async
                    {
                        _ = NetWorkManager(packageDetail: package)
                    }
                }
              
               
           }
        }
        
    }
    
}

//MARK: - Navigation Controller  and Side Menu Functions
extension HomeViewController
{
    //Sets the Title for the Navigation Bar
    func setUpNavigationTitle()
    {
        navigationTitle.title = StringLiteral.homeViewControllerTitleName
    }
    
    private func showMenuBar()
    {
        navigationItem.searchController = nil //Hides the search bar
        //self.navigationController?.setNavigationBarHidden(true, animated: true) //hides the navigation bar when the menu bar is pressed.
        //navigationController?.navigationBar.alpha = 0
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.topItem?.title = "" //TODO
        
        
        
        UIView.animate(withDuration: 0.1)
        {
            self.leadingConstraintSideMenuView.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.sideMenuBackView.alpha = 0.1
            self.sideMenuBackView.isHidden = false
            
            UIView.animate(withDuration: 0.1)
            {
                self.leadingConstraintSideMenuView.constant = 0
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.isSideMenuShown = true
               
            }

        }

        self.sideMenuBackView.isHidden = false
        
    }
    
    private func hideSideView()
    {
        navigationItem.searchController = searchController //unhides the search bar
        navigationController?.navigationBar.topItem?.title = StringLiteral.homeViewControllerTitleName
        
        UIView.animate(withDuration: 0.1)
        {
            self.leadingConstraintSideMenuView.constant = 10
            self.view.layoutIfNeeded()
            self.hideIfNoPackage()
        } completion: { (status) in
            self.sideMenuBackView.alpha = 0.0
            UIView.animate(withDuration: 0.1)
            {
                self.leadingConstraintSideMenuView.constant = -280
                self.view.layoutIfNeeded()
                self.hideIfNoPackage()
            } completion: { (status) in
                self.sideMenuBackView.isHidden = true
                self.isSideMenuShown = false
                self.hideIfNoPackage()
            }
        }
    }
}

//MARK: - Notification Canter
extension HomeViewController
{
    func setupNotificationCenter()
    {
        registerNotificationCenter()
    }
    
    func registerNotificationCenter()
    {
    //Obsereves the Notification
    NotificationCenter.default.addObserver(self, selector: #selector(doWhenNotified(_:)), name: Notification.Name(StringLiteral.notificationKey), object: nil)
    }

    public func updateUI()
    {
        loadTrackingNumber()
        hideIfNoPackage()
        packageTableView.reloadData()
        sideMenuBackView.isHidden = true
    }
    
    @objc func doWhenNotified(_ notiofication: NSNotification)
    {
    
    if let dict = notiofication.userInfo as NSDictionary?
    {
        if (dict[StringLiteral.updateHomeViewData] as? String) != nil
      {
        updateUI()
      }
        
        if (dict[StringLiteral.hideHomeViewNavigationBar] as? String) != nil
      {
        
            self.navigationController?.setNavigationBarHidden(false, animated: true)
      }
        
        if (dict[StringLiteral.hideSideMenu] as? String) != nil
      {
        
            hideSideView()
          
            
        
      }
      
    }
    }
    
}

//MARK: - CoreData
extension HomeViewController
{
    func saveTrackingNumber()
    {
        do
        {
            try context.save()
        } catch
        {
            print("Error Saving Context \(error)")
        }
    }
    
     func loadTrackingNumber()
     {
        let request : NSFetchRequest<PackageObject> = PackageObject.fetchRequest()
        do
        {
            packages = try context.fetch(request)
        }
         catch
         {
            print("Error Loading Context \(error)")
        }
    }
    
    
    
    
    
}

//MARK: - UISEARCH BAR
extension HomeViewController: UISearchResultsUpdating
{
    func setupSearchBar()
    {
        
        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Seach Package"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        
        // Scopr Bar
//        searchController.searchBar.scopeButtonTitles = PackageStatus.Category.allCases
//          .map { $0.rawValue }
//        searchController.searchBar.delegate = self

    }
  func updateSearchResults(for searchController: UISearchController)
    
    {
    // TODO
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)

  }
    
    func filterContentForSearchText(_ searchText: String,  status: PackageStatus.Category? = nil)
    {

      filteredPackages = packages.filter
        {
            (package: PackageObject) -> Bool in
            
         
               
                
              
                return package.packageDescription!.lowercased().contains(searchText.lowercased())
            
       
      }

        packageTableView.reloadData()
       
    }

   

}


extension HomeViewController: UISearchBarDelegate
{
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
//    let category = Candy.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
//    filterContentForSearchText(searchBar.text!, category: category)
        let packageStatus = PackageStatus.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, status: packageStatus)
  }
}
