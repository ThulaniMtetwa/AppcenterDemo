//
//  SearchTableViewController.m
//  AppCenterDemo
//
//  Created by NPW iOS on 2018/08/06.
//  Copyright © 2018 NPW iOS. All rights reserved.
//

#import "SearchTableViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Artist.h"
@import AppCenterAnalytics;




@interface SearchTableViewController ()
{

}
@property(nonatomic,strong) NSMutableArray * tableData;
@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method called for UISearchBarDelegate
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    [MSAnalytics trackEvent:@"searchBar textDidChange" withProperties:@{ @"NSString" : searchText}];
    
    NSString *query = [NSString stringWithFormat:@"https://itune.apple.com/search?country=za&term=%@&limit=30",searchText];
    
    NSString * escapedUrlString = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
    
    NSURLSession * urlSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [urlSession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        self.tableData = [self parseJsonData:data];
                                                        [MSAnalytics trackEvent:[NSString stringWithFormat:@"Searched for artist query : %@",escapedUrlString]];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.tableView reloadData];
                                                        });
                                                    }
                                                }];
    [task resume];
    
    
    
}


-(NSMutableArray *)parseJsonData:(NSData *)data{
    NSMutableArray * catalog = [[NSMutableArray alloc]init];
    
    @try {
        NSError *e = nil;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
        
        for(NSDictionary * obj in jsonResult[@"results"]){
            Artist * artist = [[Artist alloc]init];
            
            artist.trackName = [obj valueForKey:@"trackName"];
            artist.previewUrlString = [obj valueForKey:@"previewUrl"];
            
            [catalog addObject:artist];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
    return catalog;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
     if (cell == nil)
     {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     // Configure the cell
     Artist *artist = [self.tableData objectAtIndex:indexPath.row];
     cell.textLabel.text =artist.trackName;
     return cell;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Artist *artist = [self.tableData objectAtIndex:indexPath.row];
    
    NSURL *trackPreviewURL = [NSURL URLWithString:artist.previewUrlString];
    AVPlayerViewController * _moviePlayer1 = [[AVPlayerViewController alloc] init];
    _moviePlayer1.player = [AVPlayer playerWithURL:trackPreviewURL];
    
    [self presentViewController:_moviePlayer1 animated:YES completion:^{
        [_moviePlayer1.player play];
    }];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
