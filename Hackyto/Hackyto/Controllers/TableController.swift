//
//  TableController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class TableController: UITableViewController {

    let retriever: RetrieverManager
    var topStories: Array<Int>?
    var detailedStories = [Int: NSDictionary]()

    let pullToRefresh = UIRefreshControl()

    let cellIdentifier = "StoryCell"

    static var colorIndex = 0

    let contentType: RetrieverManager.NewsType
    
    // MARK: Init

    init(type: RetrieverManager.NewsType) {
        self.retriever = RetrieverManager(type: type)
        self.contentType = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.retriever = RetrieverManager(type: RetrieverManager.NewsType.top)
        self.contentType = RetrieverManager.NewsType.top
        super.init(coder: aDecoder)
    }
    
    // MARK: View Controller Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "StoryCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)

        self.retriever.didFinishLoadingTopStories = didFinishLoadingTopStories
        self.retriever.didFailedLoadingTopStories = didFailedLoading

        addStylesToTableView()
        addPullToRefresh()

        retrieveStories()
    }
    
    // MARK: Styles Configuration

    func addStylesToTableView() {
        self.view.backgroundColor = ColorFactory.darkGrayColor()
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = ColorFactory.darkGrayColor()

        self.setNeedsStatusBarAppearanceUpdate()
        self.tableView.separatorColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.estimatedRowHeight = 130.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: Pull to Refresh

    func addPullToRefresh() {
        self.pullToRefresh.backgroundColor = ColorFactory.colorFromNumber(TableController.colorIndex)
        self.pullToRefresh.tintColor = UIColor.white
        self.pullToRefresh.addTarget(self, action: #selector(TableController.retrieveStories), for: UIControlEvents.valueChanged)

        self.tableView.addSubview(pullToRefresh)
        self.tableView.contentOffset = CGPoint(x: 0, y: -self.pullToRefresh.frame.size.height)
        self.pullToRefresh.beginRefreshing()
    }

    func stopPullToRefresh() {
        let delayTime = DispatchTime.now() + Double(Int64(0.05 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            if let strongSelf = self {
                strongSelf.pullToRefresh.endRefreshing()
                strongSelf.updatePullToRefreshColor()
            }
        }
    }

    func updatePullToRefreshColor() {
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            if let strongSelf = self {
                TableController.colorIndex += 1
                strongSelf.pullToRefresh.backgroundColor = ColorFactory.colorFromNumber(TableController.colorIndex)
            }
        }
    }

    func retrieveStories() {
        self.retriever.retrieve()
    }

    // MARK: TableView Controller data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailedStories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StoryCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! StoryCell

        self.configureBasicCell(cell, indexPath: indexPath)

        // Seems sometimes the cell didn't update its height. Use to layout again.
        cell.layoutIfNeeded();

        return cell
    }

    func configureBasicCell(_ cell: StoryCell, indexPath: IndexPath) {
        guard let topStories = topStories else { return }

        let storyId = topStories[indexPath.row]
        let story = detailedStories[storyId]

        if let titleObject: AnyObject = story?.object(forKey: "title") as AnyObject? {
            if let authorObject: AnyObject = story?.object(forKey: "by") as AnyObject? {
                cell.configureCell(title: String(describing: titleObject), author: String(describing: authorObject), storyKey: storyId, number: indexPath.row + 1)
            }
            else {
                cell.configureCell(title: String(describing: titleObject), author: "", storyKey: storyId, number: indexPath.row + 1)
            }
        }

        if let kids = story?.object(forKey: "kids") as? NSArray {
            cell.configureComments(comments: kids)
        }

        cell.launchComments = openStoryComments
    }
    
    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let topStories = topStories else { return }

        let storyId = topStories[indexPath.row]

        let story = detailedStories[storyId]

        var url = story?.object(forKey: "url") as? String
        let title = story?.object(forKey: "title") as? String
        let keyNumber = story?.object(forKey: "id") as? NSNumber

        if url == nil { // Ask HN stories have this field empty
            if let key = keyNumber?.intValue {
                url = Constants.hackerNewsBaseURLString + String(key)
            }
        }

        self.openWebBrowser(title: title, urlString: url)
        
    }

    // MARK: Open Comments Closure
    
    var openStoryComments: ((_ key: Int) -> ()) {
        get {
            return { [weak self] (key: Int) ->() in
                if let strongSelf = self {
                    
                    let story = strongSelf.detailedStories[key]

                    let url = Constants.hackerNewsBaseURLString + String(key)
                    let title = story?.object(forKey: "title") as? String
                    let hnComments = "HN comments"
                    
                    if let title = title {
                        strongSelf.openWebBrowser(title: title + " - " + hnComments, urlString: url)
                    } else {
                        strongSelf.openWebBrowser(title: hnComments, urlString: url)
                    }
                }
            }
        }
    }
    
    // MARK: Retrieved data Closures
    
    var didFinishLoadingTopStories: ((_ storyIDs: Array<Int>?, _ stories: [Int: NSDictionary]) ->()) {
        get {
            return { [weak self] (storyIDs: Array<Int>?, stories: [Int: NSDictionary]) ->() in
                if let strongSelf = self {
                    strongSelf.topStories = storyIDs
                    strongSelf.detailedStories = stories
                    strongSelf.stopPullToRefresh()

                    print("All data is ready")
                    print("Total stories: \(strongSelf.detailedStories.count)")
                    strongSelf.tableView.reloadData()
                    
                    // For some reason, the first displayed rows may not have
                    // the correct sizing. Reload them.
                    strongSelf.tableView.reloadSections(IndexSet(integersIn: NSMakeRange(0, strongSelf.tableView.numberOfSections).toRange()!), with: .none)
                }
            }
        }
    }
    
    var didFailedLoading: (() ->()) {
        get {
            return { [weak self] in
                if let strongSelf = self {
                    strongSelf.stopPullToRefresh()
                    print("Failed to download data", terminator: "")
                }
            }
        }
    }
    
    // MARK: Helper Methods
    
    func openWebBrowser(title: String?, urlString: String?) {
        if let urlString = urlString {
            let url = URL(string: urlString)

            if let url = url {
                let request:URLRequest = URLRequest(url: url)

                let webViewController = SVModalWebViewController(urlRequest: request)
                webViewController?.barsTintColor = ColorFactory.darkGrayColor()
                
                DispatchQueue.main.async(execute: { [weak self] in
                    if let strongSelf = self {
                        strongSelf.present(webViewController!, animated: true, completion: nil)
                    }
                })
            }
        }
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

