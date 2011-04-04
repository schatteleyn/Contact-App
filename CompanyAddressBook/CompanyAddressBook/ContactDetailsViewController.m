//
//  ContactDetailsViewController.m
//  CompanyAddressBook
//
//  Created by Nicolas VERINAUD on 31/03/11.
//  Copyright 2011 SUPINFO. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "ContactMapViewController.h"
#import "Contact.h"

@interface ContactDetailsViewController ()

@property(nonatomic, retain) UILabel *firstNameLabel;
@property(nonatomic, retain) UILabel *lastNameLabel;
@property(nonatomic, retain) UILabel *categoryLabel;
@property(nonatomic, retain) UIButton *phoneNumberBtn;
@property(nonatomic, retain) UIButton *emailBtn;
@property(nonatomic, retain) UIButton *addressBtn;

@end



@implementation ContactDetailsViewController

@synthesize contactToDisplay, firstNameLabel, lastNameLabel, categoryLabel, phoneNumberBtn, emailBtn, addressBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[firstNameLabel release];
    [lastNameLabel release];
    [categoryLabel release];
    [phoneNumberBtn release];
    [emailBtn release];
    [addressBtn release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    firstNameLabel.text = [contactToDisplay firstName];
    lastNameLabel.text = [contactToDisplay lastName];
    categoryLabel.text = [contactToDisplay category];
    [emailBtn setTitle:[contactToDisplay email] forState:UIControlStateNormal];
    [phoneNumberBtn setTitle:[contactToDisplay phoneNumber] forState:UIControlStateNormal];

    [addressBtn setTitle:[contactToDisplay address] forState:UIControlStateNormal];
    
    //be sure the device is configured to send mails 
    emailBtn.enabled = [MFMailComposeViewController canSendMail];
}

- (void)viewDidUnload
{
    self.firstNameLabel = nil;
	self.lastNameLabel = nil;
	self.categoryLabel = nil;
	self.phoneNumberBtn = nil,
	self.emailBtn = nil;
	self.addressBtn = nil;
    [super viewDidUnload];
}

- (IBAction)sendAnEmail:(id)sender 
{
    //different solutions, use openURL:@"mailto:" on [UIApplication sharedApplication]
    //or use messageUI framework (I'll implement this one)
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    //we need a delegate for our mailcomposer. 
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:@"Business mail"];
    [mailComposer setToRecipients:[NSArray arrayWithObject:[self.contactToDisplay email]]];
    [self presentModalViewController:mailComposer animated:YES];
    [mailComposer release];
}

//conform to the protocol
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)callOrText:(id)sender 
{
    //we will use action sheet to get user's choice (call/text/cancel)
    UIActionSheet *whatToDoActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", nil];
    [whatToDoActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [whatToDoActionSheet showInView:self.view];
    [whatToDoActionSheet release];
}

- (IBAction)showMap:(id)sender 
{
    // show the map
    ContactMapViewController *mapViewController = [[ContactMapViewController alloc]init];
    mapViewController.contacts = [[NSMutableArray alloc] initWithObjects:self.contactToDisplay, nil];
    //mapViewController.address = self.contactToDisplay.address;
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //call button pressed
        //when this button is pressed we ask user if he's sure of his choice because we'll send application in background
        //alertview
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Leave App" message:@"You are about to leave this App to perform a phone call, are you sure ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Perform Call", nil];
        [alert show];
        [alert release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //we perform call
        NSLog(@"call");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[contactToDisplay phoneNumber]]]];
        //call won't work on simulator
    }
}
@end
