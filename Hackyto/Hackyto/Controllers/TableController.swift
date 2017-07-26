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

    fileprivate var stories = [Story]()

    fileprivate let pullToRefresh = UIRefreshControl()
    fileprivate let cellIdentifier = "StoryCell"

    static var colorIndex = 0

    init(type: ContentType) {
        hackerNewsAPI = HackerNewsAPI(for: type)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        hackerNewsAPI = HackerNewsAPI(for: .top)
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        navigationController?.isNavigationBarHidden = true

        addStylesToTableView()
        addPullToRefresh()

        retrieveStories()
    }
}

// MARK: - Styles

extension TableController {
    func addStylesToTableView() {
        view.backgroundColor = ColorFactory.darkGrayColor()
        tableView.backgroundColor = ColorFactory.darkGrayColor()

        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.estimatedRowHeight = 130.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

// MARK: - Pull to Refresh

extension TableController {
    func addPullToRefresh() {
        pullToRefresh.backgroundColor = ColorFactory.colorFromNumber(TableController.colorIndex)
        pullToRefresh.tintColor = UIColor.white
        pullToRefresh.addTarget(self, action: #selector(TableController.retrieveStories), for: UIControlEvents.valueChanged)

        tableView.addSubview(pullToRefresh)
        tableView.contentOffset = CGPoint(x: 0, y: -self.pullToRefresh.frame.size.height)
        pullToRefresh.beginRefreshing()
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
}

// MARK: - Content

extension TableController {
    func retrieveStories() {
        stories = [Story]()
        tableView.reloadData()

        hackerNewsAPI
            .onSuccess { [weak self] (stories) in
                if let strongSelf = self {
                    strongSelf.stories.append(contentsOf: stories)
                    strongSelf.tableView.reloadData()
                    strongSelf.stopPullToRefresh()
                }
            }
            .onError { [weak self] (error) in
                print(error)
                self?.stopPullToRefresh()
            }
            .fetch()
    }
}

// MARK: - UITableViewController delegate / data source

extension TableController {
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
}

// MARK: - Browser

extension TableController {
    func openWebBrowser(title: String?, urlString: String?) {
        if let urlString = urlString {
            let url = URL(string: urlString)

            if let url = url {
                let webViewController = WebViewController(url: url)

                DispatchQueue.main.async(execute: { [weak self] in
                    if let strongSelf = self {
                        strongSelf.present(webViewController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}

// MARK: - Status bar

extension TableController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: Pagination

extension TableController {
    func updateContent(_ scrollView: UIScrollView) {
        let maxY = scrollView.contentSize.height - view.frame.height
        let tableOffsetForRefresh = view.frame.height
        if scrollView.contentOffset.y >= maxY - tableOffsetForRefresh {
            hackerNewsAPI.next()
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            updateContent(scrollView)
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateContent(scrollView)
    }
}
