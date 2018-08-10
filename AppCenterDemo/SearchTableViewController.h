//
//  SearchTableViewController.h
//  AppCenterDemo
//
//  Created by NPW iOS on 2018/08/06.
//  Copyright © 2018 NPW iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate>

@property (nonatomic, assign) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
