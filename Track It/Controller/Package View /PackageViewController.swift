//
//  PackageViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/18/22.
//
import UIKit
import MapKit
import CoreData
import CoreLocation

//MARK: - Main Class
class PackageViewController: UIViewController
{
    //MARK: - Variables and Constants
    static var storyBoardID = "PackageViewController"
    
    var passedPackage:PackageObject?
    private let refreshControl = UIRefreshControl()
    var pacakges = [PackageObject]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //IBOUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var longerDescriptionLabel: UILabel!
    @IBOutlet weak var longDescriptionView: UIView!
    @IBOutlet weak var longDescriptiopnlayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var estimatedDeliverDateLabel: UILabel!
    //Navigation Items
    @IBOutlet weak var navigationBarLogo: UIImageView!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var geatButton: UIButton!
    @IBOutlet weak var websiteLogo: UIImageView!
    //Table View
    @IBOutlet weak var packgeTableViewController: UITableView!

    //IBACTION: BackButton
    @IBAction func backButtonPressed(_ sender: Any)
    {
        //Dissmisses the current view controller.
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: Any)
    {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editBarcodeViewController = storyBoard.instantiateViewController(withIdentifier: EditTrackingNumberViewController.storyBoardID) as! EditTrackingNumberViewController
        
        editBarcodeViewController.indexPassed = getCurrentIndexofPackageObject(passedPackage: passedPackage)
    getCurrentIndexofPackageObject(passedPackage: passedPackage)
        editBarcodeViewController.passedPackage = passedPackage
        
        navigationController?.pushViewController(editBarcodeViewController, animated: true)
        
    }

    func getCurrentIndexofPackageObject(passedPackage: PackageObject?)-> Int
    {
        for (index, element) in pacakges.enumerated()
        {
            if passedPackage == element
            {
                print("Item \(index): \(element)")
                print(index)
                return index
            }
         
        }
        return 5
    }

}

//MARK: - View Did Load, Appear, Disappear and Appear Functions
extension PackageViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialSetup() //These items can only be populated after the view has loaded
       
       
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
       
       
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true // Hides the Navigation Bar
    }
    

}

//MARK: - Setup Function
extension PackageViewController
{
    func initialSetup()
    {
     registerNotificationCenter() //Notification Center
     setupRefreshControl()  //Refresh Control
     setUpTableView() //Table View Setuo
     setupTrargetforLabel() //Setup Target for Labels
     populateDataFromDataObject() //Populate the UI from the Data Object
        loadTrackingNumber() //Load Tracking Numbers into Array
   
       
    }
}

//MARK: - Functions to set UI Items
extension PackageViewController
{
    
    func setMapViewLocation()
    {
    
        var address = passedPackage?.lastLocation
        
        print("Address \(address)")
        print("Lsst Location\(passedPackage?.lastLocation)")
    
        let geocoder = CLGeocoder()
        
        if address == nil
        {
            address = "Albany,NY"
        }
            geocoder.geocodeAddressString(address!)
            {
                placemarks, error in
                let placemark = placemarks?.first
                var lat = placemark?.location?.coordinate.latitude
                var lon = placemark?.location?.coordinate.longitude
             
                
                if lat == nil || lon == nil
                {
                    lat = 39.999733
                    lon = -98.6785034
                    
                }
               let center = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

                self.mapView.setRegion(region, animated: true)
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                self.mapView.addAnnotation(annotation)
                
            }
       
      
    }
    
     func setLastupdated()
     {
         
         lastUpdated.text = passedPackage?.lastUpdated
     }
     
    func setDeliveryDate()
    {
        let data: DataManager = DataManager(package: passedPackage!)
        estimatedDeliverDateLabel.text = data.isThereAnDeliveryDateAvailabe()
    }
   
    
}
//MARK: - Functions Responsible for populating and updating the User interface
extension PackageViewController
{
    func populateDataFromDataObject()
    {
        setupPage()
        setErrorMessageView() //Hides text that indicates to the user the tracking number is invalid
        setTransitStatus()
        setMapViewLocation()
        setLastupdated()
        setDeliveryDate()
    }
    
   
    
    func   setupPage()
    {
        navigationBarLogo.image =  UIImage(named: (passedPackage?.carrierLogoName?.lowercased())!) //populates carrier image in the navigation bar
        trackingNumberLabel.text = passedPackage?.trackingNumber //populates the tracking numnber in the navigation bar
        websiteLogo.image = UIImage(named: (passedPackage?.carrierLogoName?.lowercased())!) //sets the image that users can click on to take them to the carriers webite.
        
    }
    
    func setErrorMessageView()
    {
        if passedPackage?.isValidTrackingNumber == false
        {
            
        }
        else
        {
            longDescriptiopnlayoutConstraint.constant = 0 //Hides it essentially.
        }
    }
    
    func setTransitStatus()
    {
        let data: DataManager = DataManager(package: passedPackage!)
        currentDescription.adjustsFontSizeToFitWidth =  true
        currentDescription.minimumScaleFactor = 0.2
        
        if passedPackage?.isValidTrackingNumber == false
        {
            currentDescription.text = "Awaiting updates from the carrier"
            longerDescriptionLabel.text = "Please ensure that the tracking number is accutate. In the mean while we will periodically check for updates from the carrier. Youll be notifed of any changes."
        }
        else
        {
            currentDescription.text = data.getMostRecentStatusTypeDescriptionReadableText()
            currentImage.image = UIImage(systemName: data.getBestImage())
            longDescriptionView.backgroundColor = data.getDescriptionBackgroundColor()
            
          
            
        }
        
    }
    
}

//MARK: - User Input Validation and Textfiled Fundtion
extension PackageViewController
{
    func setupTrargetforLabel()
    {
        addTargetforCarrierImage()
        addTargetforCarrierLabel()
    }
    func addTargetforCarrierImage()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PackageViewController.imageTapped))

            // add it to the image view;
        websiteLogo.addGestureRecognizer(tapGesture)
            // make sure imageView can be interacted with by user
        websiteLogo.isUserInteractionEnabled = true
        
       
        
    }
    
    func addTargetforCarrierLabel()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PackageViewController.LabelTapped))

        //Target for label.
        trackingNumberLabel.addGestureRecognizer(tapGesture)
        trackingNumberLabel.isUserInteractionEnabled = true
        
        
    }
    
    @objc func imageTapped()
    {
        print("Image Tapped")
        let _ = WebSiteRequest(packageDetail: passedPackage!)
    }
    
    @objc func LabelTapped()
    {
        UIPasteboard.general.string = passedPackage?.trackingNumber
        
    }
}

//MARK: - Table View Functions DataSource and Relevant Functions
extension PackageViewController: UITableViewDataSource
{
    func setUpTableView()
    {
        registerTableViewCells()
        configureTableView()
    }
    
    private func registerTableViewCells()
    {
        let textFieldCell = UINib(nibName: ActivityTableViewCell.classIdentifier,bundle: nil)
        self.packgeTableViewController.register(textFieldCell,forCellReuseIdentifier: ActivityTableViewCell.cellIdentifier)
    }
    
    func configureTableView()
    {
        //Makes The table View look nice
        packgeTableViewController.showsVerticalScrollIndicator = false
        packgeTableViewController.separatorStyle = .none  //Hides the lines
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if passedPackage?.isValidTrackingNumber == false
        {
            return 0
        }
        let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPackage?.testData)!)
        let count = (trackingData?.trackResponse.shipment[0].package[0].activity?.count)
        return count!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        //Create Cell First
        let cell = packgeTableViewController.dequeueReusableCell(withIdentifier: ActivityTableViewCell.cellIdentifier) as! ActivityTableViewCell
        
        //Set Data Here
        let data: DataManager = DataManager(package: passedPackage!)
        cell.descriptionLabel.text = data.getDescriptionLabelForCell(indexPath: indexPath)
        cell.locationLabel.text = data.getLocationLabelForCel(indexPath: indexPath)
        cell.dateLabel.text = data.getDateForCell(indexPath: indexPath)
        cell.timeLabel.text = data.getTimeForCell(indexPath: indexPath)
    
        return cell
    }
    
}

//MARK: - Table View Functions DataSource and Relevant Functions
extension PackageViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
        //return 110 //Origina. Return
    }
}

//MARK: - Refresh Contol
extension PackageViewController
{
    func setupRefreshControl()
    {
        registerRefreshControl()
    }
    
    func registerRefreshControl()
    {
        if #available(iOS 10.0, *)
        {
            packgeTableViewController.refreshControl = refreshControl
        } else
        {
            packgeTableViewController.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        refreshControl.attributedTitle = NSAttributedString(string: "updating package", attributes: nil)
        
//        //Package Package is a valid tracking number
//        if ((passedPackage?.isValidTrackingNumber) == true)
//        {
//            refreshControl.attributedTitle = NSAttributedString(string: "refreshing data", attributes: nil)
//        }
//        else
//        {
//            refreshControl.attributedTitle = NSAttributedString(string: "😟 No Data 😕", attributes: nil)
//        }
//
        refreshControl.tintColor = .darkGray
    }
    
    @objc private func refreshData(_ sender: Any)
    {

        if passedPackage?.delivered == false
        {
            DispatchQueue.main.async
            {
                _ = NetWorkManager(packageDetail: self.passedPackage!) //Tracking Number update
                self.postBarcodeNotification(code: StringLiteral.updateHomeViewData) //Updates the Home Screen View
                self.postBarcodeNotification(code: StringLiteral.refreshPackageActivityScreen) //Updates the PAckage View
                self.refreshControl.endRefreshing() //Removes the Reresh control Animation
                self.packgeTableViewController.reloadData() //Reload the table view for the current View Controller
           }
        }
        else
        {

            self.refreshControl.endRefreshing()

        }

        
    }
}

//MARK: - Notification Canter
extension PackageViewController
{
    ///- Function allows the view controller to respond to notification requests.
    func registerNotificationCenter()
    {
    //Obsereves the Notification
    NotificationCenter.default.addObserver(self, selector: #selector(doWhenNotified(_:)), name: Notification.Name(StringLiteral.notificationKey), object: nil)
    }
    
    func postBarcodeNotification(code: String)
    {
        var info = [String: String]()
        info[code.description] = code.description //Notification to post
        NotificationCenter.default.post(name: Notification.Name(rawValue: StringLiteral.notificationKey), object: nil, userInfo: info)
    }
    
    @objc func doWhenNotified(_ notiofication: NSNotification)
    {
      
        if let dict = notiofication.userInfo as NSDictionary?
        {
            if let dict = notiofication.userInfo as NSDictionary?
            {
                if (dict[StringLiteral.refreshPackageActivityScreen] as? String) != nil
              {
              initialSetup()
              }
            }
        }
    }
    
}

//MARK: - CoreData
extension PackageViewController
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
            pacakges = try context.fetch(request)
        }
         catch
         {
            print("Error Loading Context \(error)")
        }
    }
}


