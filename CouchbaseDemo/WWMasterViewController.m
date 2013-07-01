//
//  WWMasterViewController.m
//  CouchbaseDemo
//
//  Created by Cash on 13-6-30.
//  Copyright (c) 2013年 imwangwei.cn. All rights reserved.
//

#import "WWMasterViewController.h"
#import "WWDetailViewController.h"

#import <CouchbaseLite/CouchbaseLite.h>
#import <CouchbaseLite/CBLJSON.h>

@interface WWMasterViewController () {
  NSMutableArray *_objects;
}

@property(nonatomic, strong) CBLDatabase *database;

@end

@implementation WWMasterViewController

@synthesize database;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Master", @"Master");
    
    if (!_objects) {
      _objects = [[NSMutableArray alloc] init];
    }
  }
  return self;
}
							
- (void)viewDidLoad
{
  [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
  self.navigationItem.leftBarButtonItem = self.editButtonItem;

  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
  
  CBLQuery *query = [[self.database viewNamed: @"byName"] query];
//  CBLQuery *query = self.database.queryAllDocuments;
  for (CBLQueryRow *row in query.rows) {
    CBLDocument *doc = row.document;
    [_objects insertObject:doc atIndex:0];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
  NSDictionary *contents = @{
                             @"time": [[NSDate date] description],
                             @"name": @"new time"
                             };
  CBLDocument *doc = [self.database untitledDocument];
  NSError *error;
  if (![doc putProperties: contents error:&error]) {
    NSLog(@"%@\n%@", @"Couldn't save the new item", error.localizedDescription);
    return;
  }
  
  [_objects insertObject:doc atIndex:0];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  CBLDocument *doc = _objects[indexPath.row];
  cell.textLabel.text = doc.documentID;
  cell.detailTextLabel.text = [doc propertyForKey:@"time"];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [_objects removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (!self.detailViewController) {
    self.detailViewController = [[WWDetailViewController alloc] initWithNibName:@"WWDetailViewController" bundle:nil];
  }
  CBLDocument *doc = _objects[indexPath.row];
  self.detailViewController.detailItem = doc;
  [self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark - Couchbase Lite

- (void)useDatabase:(CBLDatabase *)aDatabase
{
  NSLog(@"===== %s =====", __FUNCTION__);
  
  self.database = aDatabase;
  
  CBLView *view = [aDatabase viewNamed: @"byName"];
  [view setMapBlock: MAPBLOCK({
    id name = [doc objectForKey: @"name"];
    if (name) emit(name, doc);
  }) version: @"1.0"];
  
  // and a validation function requiring parseable dates:
  [aDatabase defineValidation: @"created_at" asBlock: VALIDATIONBLOCK({
    if (newRevision.isDeleted)
      return YES;
    id date = [newRevision.properties objectForKey: @"created_at"];
    if (date && ! [CBLJSON dateWithJSONObject: date]) {
      context.errorMessage = [@"invalid date " stringByAppendingString: [date description]];
      return NO;
    }
    return YES;
  })];
}

@end
