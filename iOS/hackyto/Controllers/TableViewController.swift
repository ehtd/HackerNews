//
//  TableViewController.swift
//  hackyto
//
//  Created by Ernesto Torres on 8/8/17.
//  Copyright © 2017 Ernesto Torres. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {

    fileprivate let api = IOEHackerNewsAPI();

    fileprivate var stories = [IOEStory]() {
        didSet {
            tableView.reloadData()
        }
    }

    fileprivate let pullToRefresh = UIRefreshControl()
    fileprivate let cellIdentifier = "StoryCell"

    static var colorIndex = 0

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

extension TableViewController {
    func addStylesToTableView() {
        view.backgroundColor = UIColor.backgroundColor()
        tableView.backgroundColor = UIColor.backgroundColor()

        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.estimatedRowHeight = 130.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

// MARK: - Pull to Refresh

extension TableViewController {
    func addPullToRefresh() {
        pullToRefresh.backgroundColor = UIColor.fromNumber(TableViewController.colorIndex)
        pullToRefresh.tintColor = UIColor.white
        pullToRefresh.addTarget(self, action: #selector(TableViewController.retrieveStories), for: UIControlEvents.valueChanged)

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
                TableViewController.colorIndex += 1
                strongSelf.pullToRefresh.backgroundColor = UIColor.fromNumber(TableViewController.colorIndex)
            }
        }
    }
}

// MARK: - Content

extension TableViewController {
    func retrieveStories() {
        if let dataSource: IOSObjectArray = api?.fetch() {
            var items: [IOEStory] = [IOEStory]()
            for i in 0..<dataSource.length() {
                if let story = dataSource.object(at: UInt(i)) as? IOEStory {
                    items.append(story)
                }
            }

            stories = items
        }
        else {
            // TODO: Empty
        }

        stopPullToRefresh()
    }
}

// MARK: - UITableViewController delegate / data source

extension TableViewController {
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
        cell.configureCell(title: story.getTitle(),
                           author: "author",
                           storyKey: indexPath.row + 1,
                           number: indexPath.row + 1)

        cell.configureComments(comments: [])

        cell.launchComments = { [weak self] (key) in
            self?.openWebBrowser(title: "HN comments",
                                 urlString: "https://news.ycombinator.com/item?id=" + String(describing: "10483024"))
        }
    }
}

// MARK: - Browser

extension TableViewController {
    func openWebBrowser(title: String?, urlString: String?) {
        if let urlString = urlString {
            let url = URL(string: urlString)

            if let url = url {
                let webViewController = SFSafariViewController(url: url)

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

extension TableViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
