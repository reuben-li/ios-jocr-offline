//
//  ViewController.h
//  jocroffline
//
//  Created by reuben on 15/6/13.
//  Copyright (c) 2013 space.works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tesseract.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "GKImagePicker.h"


@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, GKImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (copy,nonatomic) NSString *searchterm;
@property (copy,nonatomic) NSArray *resultArray;
@property (copy,nonatomic) NSArray *theArray;
@property (weak, nonatomic) IBOutlet UITableView *table1;
@property (nonatomic, copy) NSArray *mediaTypes;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)enter:(id)sender;
- (IBAction)ocrbutton:(id)sender;

- (IBAction)find:(id)sender;
- (IBAction)ocr:(id)sender;
- (IBAction)sliderchange:(id)sender;

@end


