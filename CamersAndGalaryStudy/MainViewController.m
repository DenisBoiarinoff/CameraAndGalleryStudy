//
//  MainViewController.m
//  CamersAndGalaryStudy
//
//  Created by Rhinoda3 on 10.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#define THUMBNAIL_TIME 0

@interface MainViewController () <UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MainViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

	self.dataArray = [[NSMutableArray alloc] init];

	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

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
															  [self addImgFromCmera];
														  }]; // 1

	UIAlertAction *fromGalery = [UIAlertAction actionWithTitle:@"galery"
														  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															  [self addImgFromGalery];
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
	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@""
										  message:@"You want add video from ..."
										  preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *fromCamera = [UIAlertAction actionWithTitle:@"camera"
														 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															 [self addVideoFromCamera];
														 }]; // 1

	UIAlertAction *fromGalery = [UIAlertAction actionWithTitle:@"galery"
														 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															 [self addVideoFromGalery];
														 }]; // 2

	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
													 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
													 }]; // 3

	[alertController addAction:fromCamera];
	[alertController addAction:fromGalery];
	[alertController addAction:cancel];

	[self presentViewController:alertController animated:YES completion:nil];
}

- (void) addImgFromCmera {
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

- (void) addImgFromGalery {
	NSLog(@"Add photo from galery.");
	ipc = [[UIImagePickerController alloc] init];
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

- (void) addVideoFromGalery {
	NSLog(@"Add video from galery.");
	ipc = [UIImagePickerController new];
	ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	ipc.mediaTypes = @[(NSString *)kUTTypeMovie];
	ipc.delegate = self;

	NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
	if (![sourceTypes containsObject:(NSString *)kUTTypeMovie ]) {
		NSLog(@"no video");
	} else {
		ipc.modalPresentationStyle = UIModalPresentationPopover;
		[self presentViewController:ipc animated:YES completion:nil];

		UIPopoverPresentationController *popController = [ipc popoverPresentationController];
		popController.permittedArrowDirections = UIPopoverArrowDirectionAny;

		popController.sourceView = self.view;
		popController.sourceRect = self.addVireoBtn.frame;

		popController.delegate = self;
	}

}

-(void) addVideoFromCamera {
	NSLog(@"add Video from camera.");
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

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	if ([type isEqualToString:(NSString *)kUTTypeVideo]
		|| [type isEqualToString:(NSString *)kUTTypeMovie]) {
		NSURL *urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];
		NSLog(@"%@",urlvideo);

		AVAsset *asset = [AVAsset assetWithURL:urlvideo];
		AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
		CMTime time = CMTimeMake(1, 1);
		CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
		UIImage *thumbnail1 = [UIImage imageWithCGImage:imageRef];
		CGImageRelease(imageRef);

		[self.dataArray addObject:thumbnail1];
		[self.collectionView reloadData];
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		  [self dismissViewControllerAnimated:YES completion:nil];
		  self.imgView.image = [info objectForKey:UIImagePickerControllerOriginalImage];

		  UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
		  [self.dataArray addObject:newImage];

		  NSLog(@"%ld", [self.dataArray count]);
		  [self.collectionView reloadData];

	}

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

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Cell clicked");
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.dataArray count];

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	[cell setBackgroundView:[[UIImageView alloc] initWithImage:[self.dataArray objectAtIndex:indexPath.row]]];
	NSLog(@"Cell");

	// Return the cell
	return cell;

}

@end
