//
//  ContactDetailsViewController.h
//  CompanyAddressBook
//
//  Created by Nicolas VERINAUD on 31/03/11.
//  Copyright 2011 SUPINFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Contact;

@interface ContactDetailsViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
	// Model
	Contact *contactToDisplay;
	
	// Views
    IBOutlet UILabel *firstNameLabel;
    IBOutlet UILabel *lastNameLabel;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UIButton *phoneNumberBtn;
    IBOutlet UIButton *emailBtn;
    IBOutlet UIButton *addressBtn;
}

@property (nonatomic,retain) Contact *contactToDisplay;

- (IBAction)sendAnEmail:(id)sender;
- (IBAction)callOrText:(id)sender;
- (IBAction)showMap:(id)sender;

@end
