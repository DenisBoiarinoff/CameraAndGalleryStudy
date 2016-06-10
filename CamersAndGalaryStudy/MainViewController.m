//
//  MainViewController.m
//  CamersAndGalaryStudy
//
//  Created by Rhinoda3 on 10.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPhotoBtn:(id)sender {

	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@""
										  message:@"You want add photo from ..."
										  preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *fromCamera = [UIAlertAction actionWithTitle:@"camera"
														  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															  [self addFromCmera];
														  }]; // 1

	UIAlertAction *fromGalery = [UIAlertAction actionWithTitle:@"galery"
														  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															  [self addFromGalery];
														  }]; // 2

	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
														  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
														  }]; // 3

	[alertController addAction:fromCamera];
	[alertController addAction:fromGalery];
	[alertController addAction:cancel];

	[self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)addVideoBtn:(id)sender {
}

- (void) addFromCmera {
	NSLog(@"Add from camera.");
	ipc = [[UIImagePickerController alloc] init];
	ipc.delegate = self;
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	  {
		ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentViewController:ipc animated:YES completion:NULL];
	  }
	else
	  {
		UIAlertController *alertController = [UIAlertController
											  alertControllerWithTitle:@""
											  message:@"No camera available."
											  preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *notAvaliable = [UIAlertAction actionWithTitle:@"Okay"
															   style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															   }]; // 1
		[alertController addAction:notAvaliable];

		[self presentViewController:alertController animated:YES completion:nil];
	  }

}

- (void) addFromGalery {
	NSLog(@"Add from galery.");
	ipc= [[UIImagePickerController alloc] init];
	ipc.delegate = self;
	ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

	ipc.modalPresentationStyle = UIModalPresentationPopover;
	[self presentViewController:ipc animated:YES completion:nil];

	UIPopoverPresentationController *popController = [ipc popoverPresentationController];
	popController.permittedArrowDirections = UIPopoverArrowDirectionAny;

	popController.sourceView = self.view;
	popController.sourceRect = self.addPhotoBtn.frame;

	popController.delegate = self;

}


#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissViewControllerAnimated:YES completion:nil];
	self.imgView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {

	// called when a Popover is dismissed
	NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {

	// return YES if the Popover should be dismissed
	// return NO if the Popover should not be dismissed
	return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {

	// called when the Popover changes positon
}

@end
