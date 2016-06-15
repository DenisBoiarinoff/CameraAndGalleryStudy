//
//  MainViewController.m
//  CamersAndGalaryStudy
//
//  Created by Rhinoda3 on 10.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainViewController.h"
#import "GalleryCollectionViewCell.h"
#import "UIImage+isFromVideo.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#define THUMBNAIL_TIME 0

@interface MainViewController () <UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MainViewController

static NSString * const playIconUrl = @"Play_Icon";
static NSString * const collectionCellNibName = @"GalleryCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

	self.dataArray = [[NSMutableArray alloc] init];

	[self.collectionView registerClass:[GalleryCollectionViewCell class] forCellWithReuseIdentifier:collectionCellNibName];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToGallery:(id)sender {

	bool isVideo;
	NSString *message;
	if ([sender tag] == 11) {
		message = @"You want add photo from ...";
		isVideo = FALSE;
	} else {
		message = @"You want add video from ...";
		isVideo = TRUE;
	}

	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@""
										  message:message
										  preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *fromCamera = [UIAlertAction actionWithTitle:@"camera"
														 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															 [self addFromCmera:isVideo];
														 }]; // 1

	UIAlertAction *fromGalery = [UIAlertAction actionWithTitle:@"galery"
														 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															 [self addFromGalery:isVideo];
														 }]; // 2

	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
													 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
													 }]; // 3

	[alertController addAction:fromCamera];
	[alertController addAction:fromGalery];
	[alertController addAction:cancel];

	[self presentViewController:alertController animated:YES completion:nil];
}

- (void) addFromCmera:(bool)isVideo{
	NSLog(@"add from camera.");
	ipc = [[UIImagePickerController alloc] init];
	ipc.delegate = self;

	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])	{
	  ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
	  [self presentViewController:ipc animated:YES completion:NULL];
	} else {
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

- (void) addFromGalery:(bool)isVideo {

	ipc = [[UIImagePickerController alloc] init];
	ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	ipc.delegate = self;

	NSArray *sourceTypes;

	if (isVideo) {
		ipc.mediaTypes = @[(NSString *)kUTTypeMovie];
		sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
		if (![sourceTypes containsObject:(NSString *)kUTTypeMovie ]) {
			NSLog(@"no video");
			return;
		}
	}

	ipc.modalPresentationStyle = UIModalPresentationPopover;
	[self presentViewController:ipc animated:YES completion:nil];

	UIPopoverPresentationController *popController = [ipc popoverPresentationController];
	popController.permittedArrowDirections = UIPopoverArrowDirectionAny;

	popController.sourceView = self.view;

	if (isVideo) {
		popController.sourceRect = self.addVideoBtn.frame;
	} else {
		popController.sourceRect = self.addPhotoBtn.frame;
	}

	popController.delegate = self;

}

//-(UIImage *)drawBadgeOnImage:(UIImage*)videoImage
//{
//	UIImage *badge =  [UIImage imageNamed:playIconUrl];
//
//	UIGraphicsBeginImageContextWithOptions(videoImage.size, NO, 0.0f);
//	[videoImage drawInRect:CGRectMake(0, 0, videoImage.size.width, videoImage.size.height)];
//	[badge drawInRect:CGRectMake((videoImage.size.width - badge.size.width * 2)/2,
//								 (videoImage.size.height - badge.size.height * 2)/2,
//								 badge.size.width * 2,
//								 badge.size.height * 2)];
//	UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	return resultImage;
//}

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"imagePickerController");
	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	if ([type isEqualToString:(NSString *)kUTTypeVideo]
		|| [type isEqualToString:(NSString *)kUTTypeMovie]) {

		NSURL *urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];

		AVAsset *asset = [AVAsset assetWithURL:urlvideo];
		AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
		imageGenerator.appliesPreferredTrackTransform = true;
		CMTime time = CMTimeMake(1, 1);

		CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
		UIImage *thumbnail1 = [UIImage imageWithCGImage:imageRef];
		CGImageRelease(imageRef);

		thumbnail1.source = @"video";
//		thumbnail1 = [self drawBadgeOnImage:thumbnail1];

		[self.dataArray addObject:thumbnail1];
		[self.collectionView reloadData];
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self dismissViewControllerAnimated:YES completion:nil];

		UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];

		[self.dataArray addObject:newImage];

		[self.collectionView reloadData];

	}

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
	// called when a Popover is dismissed
	NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
	// return YES if the Popover should be dismissed
	// return NO if the Popover should not be dismissed
	return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
		  willRepositionPopoverToRect:(inout CGRect *)rect
							   inView:(inout UIView *__autoreleasing  _Nonnull *)view
{
	// called when the Popover changes positon
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Cell clicked");
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellNibName forIndexPath:indexPath];
	UIImage *img = [self.dataArray objectAtIndex:indexPath.row];
	[cell setBackgroundView:[[UIImageView alloc] initWithImage:[self.dataArray objectAtIndex:indexPath.row]]];
//	[cell.badge setImage:[UIImage imageNamed:playIconUrl]];
	if (![img.source isEqualToString:@"video"]) {
		[cell.badge setHidden:YES];
	} else {
		[cell.badge setHidden:NO];
	}

	// Return the cell
	return cell;

}
@end
