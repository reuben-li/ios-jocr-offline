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
    
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"jpn"];
    [tesseract setImage:[UIImage imageNamed:@"ninja.png"]];
    [tesseract recognize];
    
    NSLog(@"%@", [tesseract recognizedText]);
    
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
//    NSString *databaseName = @"jocr2";
 //   NSMutableArray *resultArray = [[NSMutableArray alloc]init];
resultArray = [[NSMutableArray alloc]init];
// Get the path to the documents directory and append the databaseName
//	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDir = [documentPaths objectAtIndex:0];
//	NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];	// Open the database from the users filessytem
    
    
    NSArray *arrayPathComponent=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",@"jocr2.sqlite",nil];
    NSString *databasePath=[NSString pathWithComponents:arrayPathComponent];
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
            }
            
		}
        
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
	[_table1 reloadData];
    
       
}




- (IBAction)find:(id)sender {
    
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
    //   NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    resultArray = [[NSMutableArray alloc]init];
    // Get the path to the documents directory and append the databaseName
//    NSString *databaseName = @"jocr2";
//	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDir = [documentPaths objectAtIndex:0];
//	NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];

    NSArray *arrayPathComponent=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",@"jocr2.sqlite",nil];
    NSString *databasePath=[NSString pathWithComponents:arrayPathComponent];
    
    
    NSLog(databasePath);// Open the database from the users filessytem
  	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSLog(@"database OK");
		// Setup the SQL Statement and compile it for faster access
        NSString *sqls = [NSString stringWithFormat:@"SELECT * FROM data2 WHERE _id MATCH \"%@\"",
                          nameString ];
		const char *sqlStatement = [sqls UTF8String];
		sqlite3_stmt *compiledStatement;
        NSLog(sqls);
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
             NSLog(@"query OK");
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            //    NSLog(aName);
                [resultArray addObject:aName];
         
            }
            
		}
        else
        {
      //  NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
	[_table1 reloadData];
   // NSLog(resultArray[1]);
    
}

- (IBAction)ocr:(id)sender {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
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
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:12];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.text = [resultArray objectAtIndex:indexPath.row];
    return cell;
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
 //   cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = delegate;
    
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}


- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
   // [picker release];
}

- (void) imagePickerController: (UIImagePickerController *) picker
didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    }
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (
                                                 moviePath, nil, nil, nil);
        }
    }
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
   // [picker release];
}

//image cropper
- (UIImage *)cropImage:(UIImage *)oldImage {
    CGSize imageSize = oldImage.size;
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( imageSize.width,
                                                       imageSize.height - 200),
                                           NO,
                                           0.);
    [oldImage drawAtPoint:CGPointMake( 0, -100)
                blendMode:kCGBlendModeCopy
                    alpha:1.];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

@end
