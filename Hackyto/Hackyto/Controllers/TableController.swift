//
//  TableController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class TableController: UITableViewController {

    let contentResolver = ContentResolver()

    let retriever: RetrieverManager
    var topStories: Array<Int>?
    var detailedStories = [Int: Story]()

    let pullToRefresh = UIRefreshControl()

    let cellIdentifier = "StoryCell"

    static var colorIndex = 0

    let contentType: NewsType
    
    // MARK: Init

    init(type: NewsType) {
        self.retriever = RetrieverManager(type: type)
        self.contentType = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.retriever = RetrieverManager(type: NewsType.top)
        self.contentType = NewsType.top
        super.init(coder: aDecoder)
    }
    
    // MARK: View Controller Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentResolver.start()
        contentResolver
            .onSuccess { (response) in
                print(response)
            }
            .onError { (error) in
                print(error)
            }
            .get(TopContent.SEGMENT)

        self.tableView.register(UINib(nibName: "StoryCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)

        self.retriever.didFinishLoadingTopStories = { [weak self] (storyIDs: Array<Int>?, stories: [Int: Story]) ->() in
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
        
        self.retriever.didFailedLoadingTopStories = { [weak self] in
            if let strongSelf = self {
                strongSelf.stopPullToRefresh()
                print("Failed to download data", terminator: "")
            }
        }

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
        if let story = detailedStories[storyId] {
            cell.configureCell(title: story.title,
                               author: story.author,
                               storyKey: story.storyId,
                               number: indexPath.row + 1)
            
            cell.configureComments(comments: story.comments)
        }

        cell.launchComments = { [weak self] (key) in
            if let strongSelf = self {
                if let story = strongSelf.detailedStories[key] {
                    strongSelf.openWebBrowser(title: "HN comments",
                                              urlString: Constants.hackerNewsBaseURLString + String(describing: story.storyId))
                }
            }
        }
    }
    
    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let topStories = topStories else { return }

        let storyId = topStories[indexPath.row]

        if let story = detailedStories[storyId] {
            if let urlString = story.urlString { // Ask HN stories have this field empty
                openWebBrowser(title: story.title, urlString: urlString)
            }
            else {
                openWebBrowser(title: story.title,
                               urlString: Constants.hackerNewsBaseURLString + String(describing: story.storyId))
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

