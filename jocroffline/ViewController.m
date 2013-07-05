//
//  ViewController.m
//  jocroffline
//
//  Created by reuben on 15/6/13.
//  Copyright (c) 2013 space.works. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "GKImagePicker.h"
#import "GKImageCropViewController.h"
#import "GKImageCropView.h"


//TO FIX

//spaces after ocr text
//seekbar
//zoom crop

int static level = 0;

@interface ViewController()
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
    self.slider.value=0;
    level=self.slider.value;
    NSString *tt = @" ";
    if (level < 0.5) { tt = @"Exact match";}
    else tt = @"Extensive search";
    
    self.label.text= tt;
}




- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting the string
    NSString *term=[prefs stringForKey:@"stringVal"];
    term = [term stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.textField1.text=term;
    NSLog(@"2");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stringVal"];
    
    //prevent null pointer query at start
    if (term !=nil) {
    [self query: term];
    }
    
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
        nameString = @" ";
    }
    
    [self query: nameString];
         
}

- (void)query:(NSString*)term{

    sqlite3 *database;
    NSString *aName=@" ";
    
    resultArray = [[NSMutableArray alloc]init];
    NSArray *arrayPathComponent=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",@"jocr2.sqlite",nil];
    NSString *databasePath=[NSString pathWithComponents:arrayPathComponent];
  	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
    NSString *sqls;
        
        
		// Setup the SQL Statement and compile it for faster access
        if (level < 0.5)
        {
            sqls = [NSString stringWithFormat:@"select _id from data2 where _id MATCH \"%@\"", term ];
            const char *sqlStatement = [sqls UTF8String];
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    // Read the data from the result row
                    aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                    [resultArray addObject:aName];
                }
                
            }
            // Release the compiled statement from memory
            sqlite3_finalize(compiledStatement);
        }
		else
        {
            NSRegularExpression *regex = [[NSRegularExpression alloc]
                                           initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
            // Assuming you have some NSString `myString`.
            NSUInteger matches = [regex numberOfMatchesInString:term options:0
                                                        range:NSMakeRange(0, [term length])];
            if (matches > 0) {
            // `myString` contains at least one English letter.
                NSArray * words = [term componentsSeparatedByString:@" "];
            //    NSMutableArray * mutableWords = [NSMutableArray new];
                for (NSString * word in words){
                    if ([word length] > 0 && [word characterAtIndex:0] == '#'){
                        NSString * editedWord = [word substringFromIndex:1];
              //          [mutableWords addObject:editedWord];
                        sqls = [NSString stringWithFormat:@"select _id from data2 where _id MATCH \"%@\"", editedWord ];
                        const char *sqlStatement = [sqls UTF8String];
                        sqlite3_stmt *compiledStatement;
                        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
                        {
                            // Loop through the results and add them to the feeds array
                            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                            {
                                // Read the data from the result row
                                aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                                [resultArray addObject:aName];
                            }
                            
                        }
                        // Release the compiled statement from memory
                        sqlite3_finalize(compiledStatement);
                    }
                }
            }
            //perform japanese separation
            else
            {
                int num = [term length];
                
                if (num>3)
                {
                    for (int i=0; i<num-2; i++)
                    {
                        //NSRange end = [term rangeOfString:@";"];
                        NSString *shortString =[term substringWithRange:NSMakeRange(i, 3)];
                        sqls = [NSString stringWithFormat:@"select _id from data2 where _id MATCH \"%@\"", shortString];
                        const char *sqlStatement = [sqls UTF8String];
                        sqlite3_stmt *compiledStatement;
                        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
                        {
                            // Loop through the results and add them to the feeds array
                            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                            {
                                // Read the data from the result row
                                aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                                [resultArray addObject:aName];
                            }
                            
                        }
                        // Release the compiled statement from memory
                        sqlite3_finalize(compiledStatement);
                    }

                }
                
                if (num > 2)
                {
                    for (int i=0; i<num-1; i++)
                    {
                    //NSRange end = [term rangeOfString:@";"];
                    NSString *shortString =[term substringWithRange:NSMakeRange(i, 2)];
                    sqls = [NSString stringWithFormat:@"select _id from data2 where _id MATCH \"%@\"", shortString];
                        const char *sqlStatement = [sqls UTF8String];
                        sqlite3_stmt *compiledStatement;
                        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
                        {
                            // Loop through the results and add them to the feeds array
                            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                            {
                                // Read the data from the result row
                                aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                                [resultArray addObject:aName];
                            }
                            
                        }
                        // Release the compiled statement from memory
                        sqlite3_finalize(compiledStatement);
                    }
                }
                else
                {
                NSString *shortString =[term substringWithRange:NSMakeRange(0, 1)];
                sqls = [NSString stringWithFormat:@"select _id from data2 where _id MATCH \"%@\"", shortString];
                    const char *sqlStatement = [sqls UTF8String];
                    sqlite3_stmt *compiledStatement;
                    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
                    {
                        // Loop through the results and add them to the feeds array
                        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                        {
                            // Read the data from the result row
                            aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                            [resultArray addObject:aName];
                        }
                        
                    }
                    // Release the compiled statement from memory
                    sqlite3_finalize(compiledStatement);
                shortString =[term substringWithRange:NSMakeRange(1, 1)];
                sqls = [NSString stringWithFormat:@"select _id from data2 where _id MATCH \"%@\"", shortString];
                    sqlStatement = [sqls UTF8String];
                    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
                    {
                        // Loop through the results and add them to the feeds array
                        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                        {
                            // Read the data from the result row
                            aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                            [resultArray addObject:aName];
                        }
                        
                    }
                    // Release the compiled statement from memory
                    sqlite3_finalize(compiledStatement);
                    
                }
            }
            
            
            //sqls = [NSString stringWithFormat:@"select _id from data2 where _id MATCH \"%@\"", term ];
        }

        
	}
	sqlite3_close(database);
	[_table1 reloadData];
   
}


- (IBAction)find:(id)sender {
    
    self.searchterm = self.textField1.text;
    NSString *nameString = self.searchterm;
    if ([nameString length]==0){
        nameString = @" ";
    }
    
    [self query: nameString];	// Init the animals Array
    
    if ([self.textField1 canResignFirstResponder]) [self.textField1 resignFirstResponder];
}

- (IBAction)ocr:(id)sender {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
    
    
  
}

- (IBAction)sliderchange:(id)sender {
    level = self.slider.value;
    NSString *tt = @" ";
    if (level < 0.5) { tt = @"Exact match";}
    else tt = @"Extensive search";
    
    self.label.text= tt;
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

    
//    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    self.imagePicker = [[GKImagePicker alloc] init];
   // self.imagePicker.cropSize = CGSizeMake(300, 100.);
    self.imagePicker.delegate = self;
	self.imagePicker.resizeableCropArea = YES;
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
           return YES;
}



@end
