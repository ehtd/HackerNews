//
//  TableController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class TableController: UITableViewController {

    fileprivate let hackerNewsAPI: HackerNewsAPI

    fileprivate var stories = [Story]() {
        didSet {
            tableView.reloadData()
            print("Total stories: \(stories.count)")
        }
    }

    fileprivate let pullToRefresh = UIRefreshControl()
    fileprivate let cellIdentifier = "StoryCell"

    static var colorIndex = 0

    // MARK: Init

    init(type: ContentType) {
        hackerNewsAPI = HackerNewsAPI(for: type)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        hackerNewsAPI = HackerNewsAPI(for: .top)
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
        hackerNewsAPI.topStories(success: { [weak self] (stories) in
            if let strongSelf = self {
                strongSelf.stories = stories
                strongSelf.stopPullToRefresh()
            }
        }) { [weak self] (error) in
            print(error)
            self?.stopPullToRefresh()
        }
    }

    // MARK: TableView Controller data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StoryCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! StoryCell

        self.configureBasicCell(cell, indexPath: indexPath)

        // Seems sometimes the cell didn't update its height. Use to layout again.
        cell.layoutIfNeeded();

        return cell
    }

    func configureBasicCell(_ cell: StoryCell, indexPath: IndexPath) {
        let story = stories[indexPath.row]
        cell.configureCell(title: story.title,
                           author: story.author,
                           storyKey: story.storyId,
                           number: indexPath.row + 1)
        
        cell.configureComments(comments: story.comments)

        cell.launchComments = { [weak self] (key) in
            self?.openWebBrowser(title: "HN comments",
                                 urlString: Constants.hackerNewsBaseURLString + String(describing: story.storyId))
        }
    }
    
    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = stories[indexPath.row]
        if let urlString = story.urlString { // Ask HN stories have this field empty
            openWebBrowser(title: story.title, urlString: urlString)
        }
        else {
            openWebBrowser(title: story.title,
                           urlString: Constants.hackerNewsBaseURLString + String(describing: story.storyId))
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

