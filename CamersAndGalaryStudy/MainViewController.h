//
//  MainViewController.h
//  CamersAndGalaryStudy
//
//  Created by Rhinoda3 on 10.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController /*<UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate>*/
{
	UIImagePickerController *ipc;
//	UIPopoverController *popover;
//	UIPopoverPresentationController *popController;
}

@property (strong, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (strong, nonatomic) IBOutlet UIButton *addVireoBtn;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end
