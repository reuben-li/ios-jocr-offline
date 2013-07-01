//
//  ViewController.m
//  jocroffline
//
//  Created by reuben on 15/6/13.
//  Copyright (c) 2013 space.works. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


@interface ViewController ()
@end

@implementation ViewController
{
    NSMutableArray *resultArray;
  //  NSArray *theArray;
}

@synthesize searchterm = _searchterm;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)enter:(id)sender {
    self.searchterm = self.textField1.text;
    NSString *nameString = self.searchterm;
    if ([nameString length]==0){
        nameString = @"World";
    }
    

    // Setup the database object
	sqlite3 *database;
    NSString *aName=@"jaja";
	// Init the animals Array
//	animals = [[NSMutableArray alloc] init];
    NSString *databaseName = @"jocr2";
 //   NSMutableArray *resultArray = [[NSMutableArray alloc]init];
resultArray = [[NSMutableArray alloc]init];
    //array to store results
 //   NSMutableArray *result = [NSMutableArray array];
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];	// Open the database from the users filessytem
  	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSLog(@"yes");
		// Setup the SQL Statement and compile it for faster access
        NSString *sqls = [NSString stringWithFormat:@"select _id from data2 where _id MATCH \"%@\"", nameString ];
		const char *sqlStatement = [sqls UTF8String];
		sqlite3_stmt *compiledStatement;
    		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
			aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                 [resultArray addObject:aName];
				//NSString *aDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				//NSString *aImageUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
               //  [result addObject:row];
             }
            
		}
        
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
  //  self.label1.text = aName;
   // NSLog(resultArray[5]);
	[_table1 reloadData];
    
       
}



- (IBAction)ocrbutton:(id)sender {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentModalViewController:imagePicker animated:YES];
   // [picker release];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField1) {
        [theTextField resignFirstResponder];
    }
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [resultArray objectAtIndex:indexPath.row];
    return cell;
}


@end
