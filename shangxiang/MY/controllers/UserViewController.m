//
//  UserViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "UserViewController.h"
#import "UIImageView+WebCache.h"
#import "CropImageContentView.h"
#import "UserHomeTownObject.h"
#import "MyRequestManager.h"
#import "ASIFormDataRequest.h"
#import "LoginRequestManager.h"
#import "LFFGPhotoAlbumView.h"

#define TAG_ACTIONSHEET_Image   4123//修改头像actionSheet
#define TAG_ACTIONSHEET_Gender  4124//男女
#define TAG_ACTIONSHEET 523

@interface UserViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CropImageContenViewProtocol>
{
    UIScrollView* viewMain;
    UIImageView* _viewAvatar;//头像
    UITextField* _hintMobile;//账号
    UITextField* _hintRealname;//姓名
    UILabel* _hintRegion;//地区
    UILabel* _hintSexy;//性别
}

@property (nonatomic, strong) CropImageContentView *cropImageContentView;
@property (nonatomic, strong) UIImage *imageSource;

@property (nonatomic, strong) UIView *pickerBackground; ///< 选择器背景，全屏，透明
@property (nonatomic, strong) UIView *pickerContainer; ///< 选择器容器，只占据下半边
@property (nonatomic, strong) UIPickerView *hometownPicker; ///< 城市选择
@property (nonatomic, strong) UIButton *pickerConfirmBtn; ///< 选择器确认按钮

@property (nonatomic, strong) UserHomeTownObject* homeObj;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;


@end

@implementation UserViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    [self setupDismissKeyboard];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem rsBarButtonItemWithTitle:@"保存" image:nil heightLightImage:nil disableImage:nil target:self action:nil];
    [self setRightBarButtonItem:rightItem];
    
    viewMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [viewMain setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    viewMain.showsHorizontalScrollIndicator = NO;
    viewMain.showsVerticalScrollIndicator = NO;
    viewMain.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    
    CGRect frame = CGRectZero;
    float fltViewWidth = self.view.width;
    float fltCellHeight = 44;
    float fltMargin = 20;
    float fltMinMargin = 10;
    float fltLabelWidth = fltViewWidth - fltMargin * 2;
    float fltHintMargin = 70;
    float fltHintWidth = fltViewWidth - fltMargin - fltHintMargin;
    float fltBegin = fltMargin;
    
    UIImage* imgArrow = [UIImage imageForKey:@"arrow_right"];
    UIImage* imgAvatar = [UIImage imageForKey:@"avatar_null"];
    imgAvatar = [imgAvatar imageByResizeToSize:CGSizeMake(imgAvatar.size.width / 1.5, imgAvatar.size.height / 1.5)];
    
    float fltUserCellHeight = imgAvatar.size.height + fltMinMargin * 2;
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltUserCellHeight);
    UIButton* buttonAvatar = [[UIButton alloc] initWithFrame:frame];
    [buttonAvatar setTag:0];
    [buttonAvatar setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonAvatar addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    UIView* viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonAvatar addSubview:viewTemp];
    
    frame.origin = CGPointMake(0, fltUserCellHeight);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonAvatar addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltUserCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    UIImageView* viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonAvatar addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, fltMinMargin);
    frame.size = imgAvatar.size;
    _viewAvatar = [[UIImageView alloc] initWithFrame:frame];
    _viewAvatar.image = imgAvatar;
    _viewAvatar.layer.borderWidth = 1;
    _viewAvatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewAvatar.clipsToBounds = YES;
    _viewAvatar.layer.cornerRadius = _viewAvatar.width/2;
    [buttonAvatar addSubview:_viewAvatar];
    
    frame.origin = CGPointMake(fltHintMargin, 0);
    frame.size = CGSizeMake(fltHintWidth, fltUserCellHeight);
    UILabel* labelAvatar = [[UILabel alloc] initWithFrame:frame];
    labelAvatar.text = @"修改头像";
    labelAvatar.font = [UIFont systemFontOfSize:15];
    labelAvatar.textColor = UIColorFromRGB(COLOR_FONT_FORM_HINT);
    [buttonAvatar addSubview:labelAvatar];
    
    [viewMain addSubview:buttonAvatar];
    
    fltBegin += fltUserCellHeight + fltMargin;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonMobile = [[UIButton alloc] initWithFrame:frame];
    [buttonMobile setTag:1];
    [buttonMobile setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonMobile addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonMobile addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelMobile = [[UILabel alloc] initWithFrame:frame];
    labelMobile.text = @"昵称";
    labelMobile.font = [UIFont systemFontOfSize:15];
    labelMobile.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonMobile addSubview:labelMobile];
    
    frame.origin = CGPointMake(fltHintMargin, 0);
    frame.size = CGSizeMake(fltHintWidth, fltCellHeight);
    _hintMobile = [[UITextField alloc] initWithFrame:frame];
    _hintMobile.text = @"未填写";
    _hintMobile.font = [UIFont systemFontOfSize:15];
    _hintMobile.textColor = UIColorFromRGB(COLOR_FONT_FORM_HINT);
    [buttonMobile addSubview:_hintMobile];
    
    [viewMain addSubview:buttonMobile];

    
    fltBegin += fltCellHeight;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonRealname = [[UIButton alloc] initWithFrame:frame];
    [buttonRealname setTag:3];
    [buttonRealname setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonRealname addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonRealname addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonRealname addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelRealname = [[UILabel alloc] initWithFrame:frame];
    labelRealname.text = @"姓名";
    labelRealname.font = [UIFont systemFontOfSize:15];
    labelRealname.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonRealname addSubview:labelRealname];
    
    frame.origin = CGPointMake(fltHintMargin, 0);
    frame.size = CGSizeMake(fltHintWidth, fltCellHeight);
    _hintRealname = [[UITextField alloc] initWithFrame:frame];
    _hintRealname.text = @"未填写";
    _hintRealname.font = [UIFont systemFontOfSize:15];
    _hintRealname.textColor = UIColorFromRGB(COLOR_FONT_FORM_HINT);
    [buttonRealname addSubview:_hintRealname];
    
    UIView* tempView = [[UIView alloc] initWithFrame:CGRectMake(0, buttonRealname.height - 0.5, self.view.width, 0.5)];
    [tempView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [buttonRealname addSubview:tempView];
    
    [viewMain addSubview:buttonRealname];
    
    fltBegin += fltCellHeight + fltMargin;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonRegion = [[UIButton alloc] initWithFrame:frame];
    [buttonRegion setTag:4];
    [buttonRegion setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonRegion addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonRegion addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonRegion addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelRegion = [[UILabel alloc] initWithFrame:frame];
    labelRegion.text = @"地区";
    labelRegion.font = [UIFont systemFontOfSize:15];
    labelRegion.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonRegion addSubview:labelRegion];
    
    frame.origin = CGPointMake(fltHintMargin, 0);
    frame.size = CGSizeMake(fltHintWidth, fltCellHeight);
    _hintRegion = [[UILabel alloc] initWithFrame:frame];
    _hintRegion.text = @"未填写";
    _hintRegion.font = [UIFont systemFontOfSize:15];
    _hintRegion.textColor = UIColorFromRGB(COLOR_FONT_FORM_HINT);
    [buttonRegion addSubview:_hintRegion];
    
    [viewMain addSubview:buttonRegion];
    
    fltBegin += fltCellHeight;
    
    frame.origin = CGPointMake(0, fltBegin);
    frame.size = CGSizeMake(fltViewWidth, fltCellHeight);
    UIButton* buttonSexy = [[UIButton alloc] initWithFrame:frame];
    [buttonSexy setTag:5];
    [buttonSexy setBackgroundColor:UIColorFromRGB(COLOR_BG_HIGHLIGHT)];
    [buttonSexy addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonSexy addSubview:viewTemp];
    
    frame.origin = CGPointMake(0, fltCellHeight);
    frame.size = CGSizeMake(fltViewWidth, HEIGHT_LINE);
    viewTemp = [[UIView alloc] initWithFrame:frame];
    viewTemp.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
    [buttonSexy addSubview:viewTemp];
    
    frame.origin = CGPointMake(fltViewWidth - fltMinMargin - imgArrow.size.width, (fltCellHeight - imgArrow.size.height) / 2);
    frame.size = imgArrow.size;
    viewArrow = [[UIImageView alloc] initWithFrame:frame];
    viewArrow.image = imgArrow;
    [buttonSexy addSubview:viewArrow];
    
    frame.origin = CGPointMake(fltMargin, 0);
    frame.size = CGSizeMake(fltLabelWidth, fltCellHeight);
    UILabel* labelSexy = [[UILabel alloc] initWithFrame:frame];
    labelSexy.text = @"性别";
    labelSexy.font = [UIFont systemFontOfSize:15];
    labelSexy.textColor = UIColorFromRGB(COLOR_FONT_NORMAL);
    [buttonSexy addSubview:labelSexy];
    
    frame.origin = CGPointMake(fltHintMargin, 0);
    frame.size = CGSizeMake(fltHintWidth, fltCellHeight);
    _hintSexy = [[UILabel alloc] initWithFrame:frame];
    _hintSexy.text = @"男";
    _hintSexy.font = [UIFont systemFontOfSize:15];
    _hintSexy.textColor = UIColorFromRGB(COLOR_FONT_FORM_HINT);
    [buttonSexy addSubview:_hintSexy];
    
    [viewMain setContentSize:CGSizeMake(buttonAvatar.width, MAX(buttonAvatar.bottom, viewMain.height + 1))];
    
    [viewMain addSubview:buttonSexy];
    [self.view addSubview:viewMain];
    
    [self updateUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUserInfo
{
    if(USEROPERATIONHELP.currentUser && USEROPERATIONHELP.currentUser.isLogined)
    {
        [_viewAvatar sd_setImageWithURL:[NSURL URLWithString:USEROPERATIONHELP.currentUser.headUrl] placeholderImage:[UIImage imageForKey:@"avatar_null"]];
        [_hintMobile setText:USEROPERATIONHELP.currentUser.nickName];
        [_hintRealname setText:USEROPERATIONHELP.currentUser.trueName];
        [_hintRegion setText:USEROPERATIONHELP.currentUser.area];
        if(USEROPERATIONHELP.currentUser.gender == 0)
        {
            [_hintSexy setText:@"未知"];
        }
        else if(USEROPERATIONHELP.currentUser.gender == 1)
        {
            [_hintSexy setText:@"男"];
        }
        else if(USEROPERATIONHELP.currentUser.gender == 2)
        {
            [_hintSexy setText:@"女"];
        }
    }
}

- (void)goTarget:(UIButton*)button
{
    BaseViewController* vcTarget;
    switch (button.tag) {
        case 0:
        {
            //修改头像
            [self editAvatar];
        }
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
        {
            //城市:
            [self editCity];
        }
            break;
        case 5:
        {
            //性别
            [self editGender];
        }
            break;
        default:
            vcTarget = nil;
            break;
    }
    if (nil != vcTarget)
    {
        [self.navigationController pushViewController:vcTarget animated:YES];
    }
}

#pragma mark Action

/// 编辑头像
- (void)editAvatar
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择手机中的照片",@"查看大图",nil];
    actionsheet.tag = TAG_ACTIONSHEET_Image;
    [actionsheet showInView:APPDELEGATE.window];
}

/// 编辑性别
- (void)editGender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionsheet.tag = TAG_ACTIONSHEET_Gender;
    [actionsheet showInView:APPDELEGATE.window];
}

/// 编辑城市
- (void)editCity {
    [self setupPickerView];
    [self enterPicker:_hometownPicker];
}

#pragma mark SheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == TAG_ACTIONSHEET_Image)
    {
        if(buttonIndex == 0)
        {
            [self choosePhoto:UIImagePickerControllerSourceTypeCamera];
        }
        else if(buttonIndex == 1)
        {
            [self choosePhoto:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else if(buttonIndex == 2 && USEROPERATIONHELP.currentUser.headUrl)
        {
            NSMutableArray *infos = @[].mutableCopy;
            
            UIImageView *image = _viewAvatar;
            LFFGPhotoAlbumPageInfo *info = [LFFGPhotoAlbumPageInfo new];
            info.thumbView = image;
            info.thumbSize = image.size;
            info.largeURL = USEROPERATIONHELP.currentUser.headBigUrl;
            NSLog(@"%@",info.largeURL);
            //info.largeSize = photo.largeSize;
            [infos addObject:info];

            LFFGPhotoAlbumView *albumView = [LFFGPhotoAlbumView new];
            albumView.pageInfos = infos;
            [albumView showFromImageView:_viewAvatar toContainer:self.view.window];
        }
    }
    else if(actionSheet.tag == TAG_ACTIONSHEET_Gender)
    {
        if(buttonIndex < 2) {
            [self showChrysanthemumHUD:YES];
            __weak typeof(self) _self = self;
            //修改性别
            NSInteger gender =  buttonIndex == 0 ? 1 : 2;
            [MyRequestManager changUserInfo:USEROPERATIONHELP.currentUser.userId nickName:USEROPERATIONHELP.currentUser.nickName trueName:USEROPERATIONHELP.currentUser.trueName area:USEROPERATIONHELP.currentUser.area sex:gender successBlock:^(id obj) {
                [_self removeAllHUDViews:YES];
                USEROPERATIONHELP.currentUser.gender = gender;
                [_self updateUserInfo];
            } failed:^(id error) {
                [_self removeAllHUDViews:NO];
                [_self dealWithError:error];
            }];
        }
    }
//    else if(actionSheet.tag == TAG_ACTIONSHEET && buttonIndex == 0)
//    {
//        USEROPERATIONHELP.currentUser.isLogined = NO;
//        [UserGlobalSetting setCurrentUser:nil];
//        USEROPERATIONHELP.currentUser = nil;
//        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:AppUserLogoutNotification object:nil];
//        [self goBack];
//    }
}

- (void)setupPickerView
{
    if (_pickerBackground != nil) return;
    
    self.hometownPicker = [[UIPickerView alloc] init];
    self.hometownPicker.delegate = self;
    self.hometownPicker.showsSelectionIndicator = YES;
    self.provinces =[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hometown" ofType:@"plist"]];
    
    self.homeObj = [[UserHomeTownObject alloc] init];
    if (self.provinces.count>0) {
        if (![self.homeObj.provinceName isEqualToString:@""] || self.homeObj.provinceName != nil) {
            int provinceNumber = 0;
            int cityNumber = 0;
            self.cities = [[self.provinces objectAtIndex:provinceNumber] objectForKey:@"cities"];
            if (self.cities.count>0) {
                if (![self.homeObj.city isEqualToString:@""] || self.homeObj.city != nil) {
                    for (int i=0; i<self.cities.count; i++) {
                        NSString *cityName = [[self.cities objectAtIndex:i] objectForKey:@"cityName"];
                        if ([self.homeObj.city isEqualToString:cityName]) {
                            cityNumber = i;
                            break;
                        }
                    }
                }
            }
            [self.hometownPicker selectRow:provinceNumber inComponent:0 animated:YES];
            [self.hometownPicker selectRow:cityNumber inComponent:1 animated:YES];
        }
        else
        {
            self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];
        }
    }
    
    if(!self.homeObj.provinceName)
    {
        self.homeObj.provinceName = [[self.provinces objectAtIndex:0] objectForKey:@"provinceName"];
        self.homeObj.city = [[self.cities objectAtIndex:0] objectForKey:@"cityName"];
    }
    

    CGFloat barHeight = 40;
    _pickerBackground = [UIView new];
    _pickerBackground.frame = self.view.bounds;
    _pickerBackground.backgroundColor = [UIColor clearColor];
    _hometownPicker.top = barHeight;

    _hometownPicker.backgroundColor = [UIColor whiteColor];
    
    _pickerContainer = [UIView new];
    _pickerContainer.size = CGSizeMake(_hometownPicker.width, _hometownPicker.height + barHeight);
    _pickerContainer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    _pickerConfirmBtn = [UIButton new];
    _pickerConfirmBtn.size = CGSizeMake(60, barHeight);
    [_pickerConfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_pickerConfirmBtn setTitleColor:UIColorFromRGB(0x007aff) forState:UIControlStateNormal];
    [_pickerConfirmBtn setTitleColor:UIColorFromRGBA(0x007aff, 0.5) forState:UIControlStateHighlighted];
    _pickerConfirmBtn.right = _pickerContainer.width;
    [_pickerConfirmBtn addTarget:self action:@selector(confirmPicker) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_pickerContainer addSubview:_pickerConfirmBtn];
    [_pickerBackground addSubview:_pickerContainer];
    
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endPicker)];
    [_pickerBackground addGestureRecognizer:g];
}

- (void)enterPicker:(UIView *)picker {
    _pickerBackground.backgroundColor = [UIColor clearColor];
    _pickerContainer.top = _pickerBackground.height;
    [_hometownPicker removeFromSuperview];
    
    [_pickerContainer addSubview:picker];
    [self.view addSubview:_pickerBackground];
    UIViewAnimationOptions op = UIViewAnimationOptionBeginFromCurrentState;
    op |= (7 << 16);
    [UIView animateWithDuration:0.3 delay:0 options:op animations:^{
        _pickerContainer.bottom = _pickerBackground.height;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endPicker)];
        [_pickerBackground addGestureRecognizer:g];
    }];
}

- (void)endPicker
{
    _pickerBackground.gestureRecognizers = nil;
    UIViewAnimationOptions op = UIViewAnimationOptionBeginFromCurrentState;
    op |= (7 << 16);
    [UIView animateWithDuration:0.3 delay:0 options:op animations:^{
        _pickerBackground.backgroundColor = [UIColor clearColor];
        _pickerContainer.top = _pickerBackground.height;
    } completion:^(BOOL finished) {
        [_pickerBackground removeFromSuperview];
    }];
}

- (void)confirmPicker {
    [self showChrysanthemumHUD:YES];
    __weak typeof(self) _self =self;
    
    //修改地区
    NSString* provinceCity = [NSString stringWithFormat:@"%@-%@",self.homeObj.provinceName,self.homeObj.city];
    [MyRequestManager changUserInfo:USEROPERATIONHELP.currentUser.userId nickName:USEROPERATIONHELP.currentUser.nickName trueName:USEROPERATIONHELP.currentUser.trueName area:provinceCity sex:USEROPERATIONHELP.currentUser.gender successBlock:^(id obj) {
        [_self removeAllHUDViews:YES];
        USEROPERATIONHELP.currentUser.area = provinceCity;
        [_self updateUserInfo];
    } failed:^(id error) {
        [_self removeAllHUDViews:NO];
        [_self dealWithError:error];
    }];
    [self endPicker];
}

#pragma mark PickerDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual:self.hometownPicker]) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.hometownPicker]) {
        switch (component) {
            case 0:
                return [self.provinces count];
                break;
            case 1:
                return [self.cities count];
                break;
            default:
                return 0;
                break;
        }
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:self.hometownPicker]) {
        switch (component) {
            case 0:
                return [[self.provinces objectAtIndex:row] objectForKey:@"provinceName"];
                break;
            case 1:
                return [[self.cities objectAtIndex:row] objectForKey:@"cityName"];
                break;
            default:
                return @"";
                break;
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.hometownPicker]) {
        switch (component) {
            case 0:
                self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.hometownPicker selectRow:0 inComponent:1 animated:YES];
                [self.hometownPicker reloadComponent:1];
                //此处仍要给cityCode赋值，不然如果用户不对component1进行选择则无法赋值便无法正常上传
                self.homeObj.city = [[self.cities objectAtIndex:0] objectForKey:@"cityName"];
                self.homeObj.provinceName = [[self.provinces objectAtIndex:row] objectForKey:@"provinceName"];
                break;
            case 1:
                self.homeObj.city = [[self.cities objectAtIndex:row] objectForKey:@"cityName"];
                //  self.provinceT.text = self.homeObj.transHomeToString;
                //在此处存储城市id号,但是当用户不选择该component时，此id便无法上传
                break;
            default:
                break;
        }
    }
}

#pragma imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* clipedImage = nil;
    if(image)
    {
        clipedImage = [UIImage compressImageIfNeed:image];
    }
    // 获得照片详细信息
    NSDictionary *media = [info objectForKey:UIImagePickerControllerMediaMetadata];
    if (media != nil) {
    }
    
    [picker dismissViewControllerAnimated:NO completion:^{
        self.cropImageContentView = [[CropImageContentView alloc] initWithFrame:[[UIScreen mainScreen] bounds] image:nil];
        self.cropImageContentView.delegate = self;
        if(self.cropImageContentView) {
            self.imageSource = clipedImage;
            [self.cropImageContentView setCropedImage:clipedImage];
            [APPDELEGATE.window addSubview:self.cropImageContentView];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)choosePhoto:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable: sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{}];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"访问图片库失败" message:@"设备不允许访问图片库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)didCancelOperation {
    [UIView animateWithDuration:0.3 animations:^{
        [self.cropImageContentView removeFromSuperview];
    }];
}

-(void)didConfirmOperation {
    UIImage* image = [self.cropImageContentView cropImage];
    if(!image) return;
    NSMutableData* imageData = [NSMutableData dataWithData:UIImagePNGRepresentation(image)];
    
    //修改头像
    [self showChrysanthemumHUD:YES];
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://app.shangxiang.com/hfupload.php"]];

    [request addPostValue:USEROPERATIONHELP.currentUser.userId forKey:@"mid"];
    [request addPostValue:@"1" forKey:@"uploadimage"];
    [request addData:imageData withFileName:[NSString stringWithFormat:@"%@.png",USEROPERATIONHELP.currentUser.userId] andContentType:@"image/png" forKey:@"uploadedfile"];
    [request setRequestMethod:@"POST"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
    [request startAsynchronous];

    [UIView animateWithDuration:0.3 animations:^{
        [self.cropImageContentView removeFromSuperview];
    }];
    
}

//执行成功
- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    //获取头文件
    [self removeAllHUDViews:NO];
    NSData* responseData = [request responseData];
    
    if(!responseData || responseData.length == 0) return;
    
    NSDictionary* dictionary = [((NSData*)responseData) jsonValueDecoded];
    if(dictionary)
    {
        if([dictionary objectForKey:@"code"])
        {
            //自己网站
            if([[dictionary objectForKey:@"code"] isEqualToString:@"succeed"])
            {
                NSString* filePath = [dictionary stringForKey:@"filepath" withDefault:@""];
                USEROPERATIONHELP.currentUser.headUrl = filePath;
                [self updateUserInfo];
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:AppUserLoginNotification object:nil];
            }
            else
            {
                ExError* exError = [ExError errorWithCode:[dictionary objectForKey:@"code"] errorMessage:[dictionary objectForKey:@"msg"]];
                [self dealWithError:exError];
            }
        }
    }
}
    

//执行失败
- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    [self removeAllHUDViews:NO];
    NSData* responseData = [request responseData];
    
    if(!responseData || responseData.length == 0) return;
    
    NSDictionary* dictionary = [((NSData*)responseData) jsonValueDecoded];
    if(dictionary)
    {
        if([dictionary objectForKey:@"code"])
        {
            //自己网站
            if(![[dictionary objectForKey:@"code"] isEqualToString:@"succeed"])
            {
                ExError* exError = [ExError errorWithCode:[dictionary objectForKey:@"code"] errorMessage:[dictionary objectForKey:@"msg"]];
                [self dealWithError:exError];
            }
        }
    }
}


- (void)setupDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    
    __weak UIViewController *weakSelf = self;
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification  object:nil queue:mainQuene usingBlock:^(NSNotification *note)
    {
        [weakSelf.view addGestureRecognizer:singleTapGR];
    }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQuene usingBlock:^(NSNotification *note)
    {
        //修改姓名
        __weak typeof(self) _self = self;
        NSString* nickName = _hintMobile.text;
        NSString* trueName = _hintRealname.text;
        [MyRequestManager changUserInfo:USEROPERATIONHELP.currentUser.userId nickName:_hintMobile.text trueName:_hintRealname.text area:USEROPERATIONHELP.currentUser.area sex:USEROPERATIONHELP.currentUser.gender successBlock:^(id obj) {
            [_self removeAllHUDViews:YES];
            USEROPERATIONHELP.currentUser.nickName = nickName;
            USEROPERATIONHELP.currentUser.trueName = trueName;
            [_self updateUserInfo];
        } failed:^(id error) {
            [_self removeAllHUDViews:NO];
            [_self dealWithError:error];
        }];
        [weakSelf.view removeGestureRecognizer:singleTapGR];
    }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

//- (void)closeButtonclicked
//{
//    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出登录",nil];
//    actionsheet.tag = TAG_ACTIONSHEET;
//    [actionsheet showInView:APPDELEGATE.window];
//}


@end
