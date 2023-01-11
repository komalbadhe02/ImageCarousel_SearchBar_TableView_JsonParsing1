//
//  HomeVC.swift
//  Komal_Badhe_TEST_DEMO
//
//  Created by Komal Badhe on 11/01/23.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var listTblView: UITableView!
    @IBOutlet weak var scrollViewContainerView: UIView!
    @IBOutlet weak var scrollViewObj: UIScrollView!

    var arrCategories: [ProductCategory] = processJSONData(filename: "Products.json")

    @objc var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    @objc var pageControl : UIPageControl = UIPageControl();
    var categoryCount : Int = 0
    var searching = false
    var selected: String?
    var arrProducts : [Product] = []
    var searchedRecords: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpScrollView()
        configurePageControl()
        configureScrollViewPages()
        initSearchBar()
        initTblView()
    }
    
    // function for setup properties of scroll view
    
    func setUpScrollView()  {
        scrollViewObj.delegate = self
        scrollViewObj.isPagingEnabled = true
        
        scrollViewObj.showsVerticalScrollIndicator = false;
        scrollViewObj.showsHorizontalScrollIndicator = false
        
        scrollViewObj.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250)
        scrollViewObj.bounces = false
    }
    
    // function for confugure scrollview
    
    func configureScrollViewPages()  {
        categoryCount = arrCategories.count
        
        // Add images on scrollview
        for index in 0..<categoryCount {
            
            let subView = UIImageView();
            subView.backgroundColor = UIColor.darkGray
            if let imgName = arrCategories[index].image {
                subView.image = UIImage(named: imgName);
            }

          
            frame.origin.x = self.scrollViewObj.frame.size.width * CGFloat(index)
            frame.size = self.scrollViewObj.frame.size
            
            subView.frame = frame
            self.scrollViewObj .addSubview(subView)
            
        }
        
        self.scrollViewObj.contentSize = CGSize(width:self.scrollViewObj.frame.size.width * CGFloat(categoryCount),height: self.scrollViewObj.frame.size.height)
        
        self.scrollViewContainerView.addSubview(pageControl)
    }
    
    // customize page control
    @objc func configurePageControl() {

        self.pageControl.numberOfPages = arrCategories.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        
        pageControl.frame = CGRect(x: self.scrollViewObj.frame.size.width/2-100, y: scrollViewObj.frame.size.height - 50, width:200 , height: 50)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    
    
    // function to change while clicking on Page Control
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollViewObj.frame.size.width
        scrollViewObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
        reloadTableData()
    }

    
    // function for customize search bar
     
    func initSearchBar()  {
        self.searchBar.delegate = self
        // Change the Tint Color
        self.searchBar.tintColor = UIColor.black
        // Show/Hide Cancel Button
        self.searchBar.showsCancelButton = true
        let searchTextField = self.searchBar.searchTextField
        searchTextField.textColor = UIColor.black
        searchTextField.clearButtonMode = .never
        self.searchBar.keyboardAppearance = .dark
    }
    
    // function for setup products tableview
    
    func initTblView()  {
        listTblView.register(ProductTVC.nib, forCellReuseIdentifier: ProductTVC.identifier)
        listTblView.allowsSelection = false
        self.listTblView.delegate = self
        self.listTblView.dataSource = self
        self.listTblView.separatorStyle = .none
        self.listTblView.tintColor = UIColor.white
        
        reloadTableData()
    }
    
   
    // function called when page changed for reloading table data
    func reloadTableData()  {
        let currentPageNo = pageControl.currentPage
        if let products = arrCategories[currentPageNo].products  {
            arrProducts = products
        }
        listTblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: - Delegate methods for Scrollview
extension HomeVC: UIScrollViewDelegate {
    // delegated called when scroll ends scrolling
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        reloadTableData()
    }
}

// MARK: - Delegate & datasources methods for UITableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    // delegate for set number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedRecords.count
        } else {
            return arrProducts.count
        }
    }
    
    
    // delegate for attach data to cell of table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = listTblView.dequeueReusableCell(withIdentifier: ProductTVC.identifier, for: indexPath) as? ProductTVC else { fatalError("xib does not exists") }
        
        let currentPageNo = pageControl.currentPage
        cell.productIconImgView.image = UIImage(named: arrCategories[currentPageNo].image ?? "")
        
        if searching {
            cell.productNameLbl.text = searchedRecords[indexPath.row].name
        } else {
            cell.productNameLbl.text = arrProducts[indexPath.row].name
        }
            return cell
        }
   
    
    // delegate for row height of table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - Delegate methods for UISearch Bar

extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  
        searchedRecords = arrProducts.filter { ($0.name )?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased()
        }
        searching = true
        listTblView.reloadData()
    }
    
    
    // delegate shows the behaviour of cancel button of search Bar
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.searchBar.searchTextField.endEditing(true)
        listTblView.reloadData()
    }
}
