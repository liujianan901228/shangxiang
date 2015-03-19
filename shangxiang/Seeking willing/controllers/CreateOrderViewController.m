//
//  CreateOrderViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "UIImageView+WebCache.h"
#import "CommonTextFiled.h"
#import "ListTempleManager.h"
#import "GradeInfoObject.h"
#import "UserBirthdayObject.h"
#import "PayInfoViewController.h"


NSString *const RegexStringPhone = @"(\(\\d{3,4}\\)|\\d{3,4}-|\\s)?\\d{8}";

@interface CreateOrderViewController ()<UITextFieldDelegate,UIPickerViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) CommonTextFiled* commonTextFiled;
@property (nonatomic, strong) UITextField* fieldTimeDesirer;
@property (nonatomic, strong) UITextField* fieldTypeDesirer;
@property (nonatomic, strong) UITextField* fieldPositionDesirer;
@property (nonatomic, strong) UITextField* fieldPhoneDesirer;
@property (nonatomic, strong) UITextField* fieldOtherDesirer;
@property (nonatomic, strong) NSMutableArray* gradeInfoArray;
@property (nonatomic, strong) NSMutableArray* choiceInfoArray;

@property (nonatomic, strong) UIView *pickerBackground; ///< 选择器背景，全屏，透明
@property (nonatomic, strong) UIView *pickerContainer; ///< 选择器容器，只占据下半边
@property (nonatomic, strong) UIPickerView *hometownPicker; ///< 城市选择
@property (nonatomic, strong) UIPickerView *typePicker;//香烛类型
@property (nonatomic, strong) UIPickerView *choicePicker;//精选类型
@property (nonatomic, strong) UIDatePicker *birthdayPicker; ///< 生日选择
@property (nonatomic, strong) UIButton *pickerConfirmBtn; ///< 选择器确认按钮
@property (nonatomic, strong) UserHomeTownObject* homeObj;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) UserBirthdayObject* birthObj;
@property (nonatomic, strong) NSDate* birthDate;
@property (nonatomic, strong) GradeInfoObject* gradeInfoObject;
@property (nonatomic, strong) NSString* choice;//精选暂存
@property (nonatomic, strong) NSDate* minDate;

@end

@implementation CreateOrderViewController

- (instancetype)init
{
    if(self = [super init])
    {
        _gradeInfoArray = [NSMutableArray array];
        _choiceInfoArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"填写订单";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    [self setupForDismissKeyboard];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setScrollEnabled:YES];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_scrollView];
    
    NSTimeInterval  interval = 24*60*60;
    _minDate = [[NSDate alloc] initWithTimeIntervalSinceNow:interval];
    
    [self initWithTempleInfo];
    [self setupPickerView];
    [self requestGradeInfo:nil];
    [self requestChoiceInfo:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithTempleInfo
{
    UIImageView* viewHall = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    [viewHall setClipsToBounds:YES];
    [viewHall setContentMode:UIViewContentModeScaleAspectFill];
    [viewHall sd_setImageWithURL:[NSURL URLWithString:_templeObject.templeSmallUrl] placeholderImage:[UIImage imageForKey:@"img_not_available"]];
    [_scrollView addSubview:viewHall];
    
    
    UIImageView* viewMaster = [[UIImageView alloc] initWithFrame:CGRectMake(viewHall.right + 10, 20, 50, 50)];
    [viewMaster setClipsToBounds:YES];
    [viewMaster setContentMode:UIViewContentModeScaleAspectFill];
    [viewMaster sd_setImageWithURL:[NSURL URLWithString:_templeObject.attacheSmallUrl] placeholderImage:[UIImage imageForKey:@"img_not_available"]];
    [_scrollView addSubview:viewMaster];
    
    UILabel* labelHall = [[UILabel alloc] initWithFrame:CGRectMake(viewMaster.right + 10, viewMaster.top +  10, self.view.width - viewMaster.right - 10, 15)];
    [labelHall setFont:[UIFont systemFontOfSize:12.0f]];
    [labelHall setNumberOfLines:1];
    [labelHall setText:[NSString stringWithFormat:@"%@ (%@)",_templeObject.templeName,_templeObject.templeProvince]];
    [labelHall setLineBreakMode:NSLineBreakByTruncatingTail];
    [_scrollView addSubview:labelHall];
    
    UILabel* labelMaster = [[UILabel alloc] initWithFrame:CGRectMake(viewMaster.right + 10, labelHall.bottom + 3, 150, 10)];
    [labelMaster setFont:[UIFont systemFontOfSize:10.0f]];
    [labelMaster setNumberOfLines:1];
    [labelMaster setText:_templeObject.buddhistName];
    [labelMaster setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [labelMaster setLineBreakMode:NSLineBreakByTruncatingTail];
    [_scrollView addSubview:labelMaster];
    
    UIButton* wishTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 20, 40, 60, 30)];
    [wishTypeButton setTitleColor:UIColorFromRGB(0xa9a9a9) forState:UIControlStateNormal];
    [wishTypeButton setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_GRAY)];
    [wishTypeButton setTitle:[LUtility getWishTitle:self.wishType] forState:UIControlStateNormal];
    [wishTypeButton setEnabled:NO];
    [wishTypeButton.layer setCornerRadius:3];
    [wishTypeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_scrollView addSubview:wishTypeButton];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, viewMaster.bottom + 10, self.view.width, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [_scrollView addSubview:line];
    
    
    UILabel* labelContentTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, line.bottom + 10, 100, 20)];
    [labelContentTitle setText:@"填写内容:"];
    [labelContentTitle setFont:[UIFont systemFontOfSize:14]];
    [labelContentTitle setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [_scrollView addSubview:labelContentTitle];
    
    UIButton* buttonSelectContent = [[UIButton alloc] initWithFrame:CGRectMake(0, line.bottom + 10, 60, 30)];
    buttonSelectContent.right = wishTypeButton.right;
    [buttonSelectContent setTitle:@"精选" forState:UIControlStateNormal];
    [buttonSelectContent.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [buttonSelectContent setTitleColor:UIColorFromRGB(COLOR_FONT_FORM_HINT) forState:UIControlStateNormal];
    [buttonSelectContent setBackgroundColor:[UIColor clearColor]];
    [buttonSelectContent addTarget:self action:@selector(editChoice) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buttonSelectContent];
    
    _commonTextFiled = [[CommonTextFiled alloc] initWithFrame:CGRectMake(20, labelContentTitle.bottom + 5, self.view.width - 40, 80)];
    [_commonTextFiled setMaxInputCount:100];
    [_commonTextFiled setTextPlaceHolder:@"请输入求愿内容"];
    [_scrollView addSubview:_commonTextFiled];
    
    UILabel* labelOtherDesirer = [[UILabel alloc] initWithFrame:CGRectMake(20, _commonTextFiled.bottom + 10, 100, 20)];
    [labelOtherDesirer setText:@"求愿人："];
    [labelOtherDesirer setFont:[UIFont systemFontOfSize:14]];
    [labelOtherDesirer setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [_scrollView addSubview:labelOtherDesirer];
    
    _fieldOtherDesirer = [[UITextField alloc] initWithFrame:CGRectMake(20, labelOtherDesirer.bottom + 5, 130, 35)];
    [_fieldOtherDesirer setKeyboardType:UIKeyboardTypeDefault];
    [_fieldOtherDesirer setAutocapitalizationType:NO];
    [_fieldOtherDesirer setReturnKeyType:UIReturnKeyDone];
    [_fieldOtherDesirer setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_fieldOtherDesirer setLeftViewMode:UITextFieldViewModeAlways];
    [_fieldOtherDesirer setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)]];
    [_fieldOtherDesirer setRightView:_fieldOtherDesirer.leftView];
    [_fieldOtherDesirer setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_INPUT)];
    [_fieldOtherDesirer setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_fieldOtherDesirer setFont:[UIFont systemFontOfSize:14.0f]];
    [_fieldOtherDesirer.layer setCornerRadius:5.0f];
    [_fieldOtherDesirer setText:USEROPERATIONHELP.currentUser.nickName];
    [_fieldOtherDesirer.layer setMasksToBounds:YES];
    [_fieldOtherDesirer.layer setBorderWidth:HEIGHT_LINE];
    [_fieldOtherDesirer.layer setBorderColor:[UIColorFromRGB(COLOR_LINE_NORMAL) CGColor]];
    [_fieldOtherDesirer setDelegate:self];
    [_scrollView addSubview:_fieldOtherDesirer];
    
    
    UILabel* labelPhoneDesirer = [[UILabel alloc] initWithFrame:CGRectMake(_scrollView.width - 20 - _fieldOtherDesirer.width, _commonTextFiled.bottom + 10, 100, 20)];
    [labelPhoneDesirer setText:@"手机："];
    [labelPhoneDesirer setFont:[UIFont systemFontOfSize:14]];
    [labelPhoneDesirer setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [_scrollView addSubview:labelPhoneDesirer];
    
    _fieldPhoneDesirer = [[UITextField alloc] initWithFrame:CGRectMake(labelPhoneDesirer.left, labelPhoneDesirer.bottom + 5, 130, 35)];
    [_fieldPhoneDesirer setKeyboardType:UIKeyboardTypeNumberPad];
    [_fieldPhoneDesirer setAutocapitalizationType:NO];
    [_fieldPhoneDesirer setReturnKeyType:UIReturnKeyDone];
    [_fieldPhoneDesirer setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_fieldPhoneDesirer setLeftViewMode:UITextFieldViewModeAlways];
    [_fieldPhoneDesirer setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)]];
    [_fieldPhoneDesirer setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_INPUT)];
    [_fieldPhoneDesirer setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_fieldPhoneDesirer setFont:[UIFont systemFontOfSize:14.0f]];
    [_fieldPhoneDesirer.layer setCornerRadius:5.0f];
    if(USEROPERATIONHELP.currentUser.mobile) [_fieldPhoneDesirer setText:USEROPERATIONHELP.currentUser.mobile];
    else [_fieldPhoneDesirer setPlaceholder:@"请输入"];
    [_fieldPhoneDesirer.layer setMasksToBounds:YES];
    [_fieldPhoneDesirer.layer setBorderWidth:HEIGHT_LINE];
    [_fieldPhoneDesirer.layer setBorderColor:[UIColorFromRGB(COLOR_LINE_NORMAL) CGColor]];
    [_fieldPhoneDesirer setDelegate:self];
    [_scrollView addSubview:_fieldPhoneDesirer];
    
    UILabel* labelTypeDesirer = [[UILabel alloc] initWithFrame:CGRectMake(20, _fieldOtherDesirer.bottom + 10, 100, 20)];
    [labelTypeDesirer setText:@"香烛类型："];
    [labelTypeDesirer setFont:[UIFont systemFontOfSize:14]];
    [labelTypeDesirer setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [_scrollView addSubview:labelTypeDesirer];
    
    
    _fieldTypeDesirer = [[UITextField alloc] initWithFrame:CGRectMake(20, labelTypeDesirer.bottom + 5, 130, 35)];
    [_fieldTypeDesirer setKeyboardType:UIKeyboardTypeDefault];
    [_fieldTypeDesirer setAutocapitalizationType:NO];
    [_fieldTypeDesirer setReturnKeyType:UIReturnKeyDone];
    [_fieldTypeDesirer setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_fieldTypeDesirer setLeftViewMode:UITextFieldViewModeAlways];
    [_fieldTypeDesirer setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)]];
    [_fieldTypeDesirer setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_INPUT)];
    [_fieldTypeDesirer setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_fieldTypeDesirer setFont:[UIFont systemFontOfSize:14.0f]];
    [_fieldTypeDesirer.layer setCornerRadius:5.0f];
    [_fieldTypeDesirer setPlaceholder:@"请输入"];
    [_fieldTypeDesirer.layer setMasksToBounds:YES];
    [_fieldTypeDesirer.layer setBorderWidth:HEIGHT_LINE];
    [_fieldTypeDesirer.layer setBorderColor:[UIColorFromRGB(COLOR_LINE_NORMAL) CGColor]];
    [_fieldTypeDesirer setDelegate:self];
    [_scrollView addSubview:_fieldTypeDesirer];
    
    UILabel* labelTimeDesirer = [[UILabel alloc] initWithFrame:CGRectMake(_scrollView.width - 20 - _fieldOtherDesirer.width, _fieldOtherDesirer.bottom + 10, 100, 20)];
    [labelTimeDesirer setText:@"预约日期："];
    [labelTimeDesirer setFont:[UIFont systemFontOfSize:14]];
    [labelTimeDesirer setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [_scrollView addSubview:labelTimeDesirer];
    
    
    _fieldTimeDesirer = [[UITextField alloc] initWithFrame:CGRectMake(_scrollView.width - 20 - _fieldOtherDesirer.width, labelTypeDesirer.bottom + 5, 130, 35)];
    [_fieldTimeDesirer setKeyboardType:UIKeyboardTypeDefault];
    [_fieldTimeDesirer setAutocapitalizationType:NO];
    [_fieldTimeDesirer setReturnKeyType:UIReturnKeyDone];
    [_fieldTimeDesirer setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_fieldTimeDesirer setLeftViewMode:UITextFieldViewModeAlways];
    [_fieldTimeDesirer setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)]];
    [_fieldTimeDesirer setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_INPUT)];
    [_fieldTimeDesirer setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_fieldTimeDesirer setFont:[UIFont systemFontOfSize:14.0f]];
    [_fieldTimeDesirer.layer setCornerRadius:5.0f];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_minDate];
    [_fieldTimeDesirer setText:dateString];
    [_fieldTimeDesirer.layer setMasksToBounds:YES];
    [_fieldTimeDesirer.layer setBorderWidth:HEIGHT_LINE];
    [_fieldTimeDesirer.layer setBorderColor:[UIColorFromRGB(COLOR_LINE_NORMAL) CGColor]];
    [_fieldTimeDesirer setDelegate:self];
    [_scrollView addSubview:_fieldTimeDesirer];
    
    
    UILabel* labelPositionDesirer = [[UILabel alloc] initWithFrame:CGRectMake(20, _fieldTypeDesirer.bottom + 10, 100, 20)];
    [labelPositionDesirer setText:@"我的位置："];
    [labelPositionDesirer setFont:[UIFont systemFontOfSize:14]];
    [labelPositionDesirer setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [_scrollView addSubview:labelPositionDesirer];
    
    
    _fieldPositionDesirer = [[UITextField alloc] initWithFrame:CGRectMake(20, labelPositionDesirer.bottom + 5, 130, 35)];
    [_fieldPositionDesirer setKeyboardType:UIKeyboardTypeDefault];
    [_fieldPositionDesirer setAutocapitalizationType:NO];
    [_fieldPositionDesirer setReturnKeyType:UIReturnKeyDone];
    [_fieldPositionDesirer setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_fieldPositionDesirer setLeftViewMode:UITextFieldViewModeAlways];
    [_fieldPositionDesirer setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)]];
    [_fieldPositionDesirer setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_INPUT)];
    [_fieldPositionDesirer setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_fieldPositionDesirer setFont:[UIFont systemFontOfSize:14.0f]];
    [_fieldPositionDesirer.layer setCornerRadius:5.0f];
    if(USEROPERATIONHELP.currentUser.area) [_fieldPositionDesirer setText:USEROPERATIONHELP.currentUser.area];
    else [_fieldPositionDesirer setPlaceholder:@"请输入"];
    [_fieldPositionDesirer.layer setMasksToBounds:YES];
    [_fieldPositionDesirer.layer setBorderWidth:HEIGHT_LINE];
    [_fieldPositionDesirer.layer setBorderColor:[UIColorFromRGB(COLOR_LINE_NORMAL) CGColor]];
    [_fieldPositionDesirer setDelegate:self];
    [_scrollView addSubview:_fieldPositionDesirer];
    
    
    UIButton* buttonSubmitCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, _fieldPositionDesirer.bottom + 20, self.view.width - 40, 40)];
    [buttonSubmitCreateOrder setTitle:@"提交" forState:UIControlStateNormal];
    [buttonSubmitCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonSubmitCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
    [buttonSubmitCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
    [buttonSubmitCreateOrder addTarget:self action:@selector(submitCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buttonSubmitCreateOrder];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, MAX(buttonSubmitCreateOrder.bottom, _scrollView.height + 1))];
}

- (void)submitCreateOrder
{
    //一项一项判断
    NSString* content = [_commonTextFiled getContentText];
    if(!content || content.length == 0)
    {
        [self showTimedHUD:YES message:@"祈福内容不能为空"];
        return;
    }
    else if(content.length > _commonTextFiled.maxInputCount)
    {
        [self showTimedHUD:YES message:@"祈福内容长度超过限制"];
        return;
    }
    
    if(_fieldOtherDesirer.text.length == 0)
    {
        [self showTimedHUD:YES message:@"求愿人姓名不能为空"];
        return;
    }
    
    NSString* iphoneNumber = _fieldPhoneDesirer.text;
    if(![LUtility isMobileNumber:iphoneNumber])
    {
        [self showTimedHUD:YES message:@"手机号格式不正确"];
        return;
    }
    
    if(_fieldTypeDesirer.text.length == 0)
    {
        [self showTimedHUD:YES message:@"香烛类型不能为空"];
        return;
    }
    
    if(_fieldTimeDesirer.text.length == 0)
    {
        [self showTimedHUD:YES message:@"预约日期不能为空"];
        return;
    }
    
    if(_fieldPositionDesirer.text.length == 0)
    {
        [self showTimedHUD:YES message:@"我的位置不能为空"];
        return;
    }
    
    
    __weak typeof(self) weakSelf = self;
    [weakSelf showChrysanthemumHUD:YES];
    [ListTempleManager postOrderInfo:self.wishType wishText:[_commonTextFiled getContentText] wishName:_fieldOtherDesirer.text wishGrade:self.gradeInfoObject.gradeVal buddhaDate:self.birthObj.transBirthDayToString wishPlace:_fieldPositionDesirer.text tid:self.templeObject.templeId aid:self.templeObject.attacheId userId:USEROPERATIONHELP.currentUser.userId mobile:iphoneNumber alsoWish:0 orderId:nil successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        long long orderId = [obj longLongForKey:@"orderid" withDefault:0];
        
        PayInfoViewController* payInfoViewController = [[PayInfoViewController alloc] init];
        payInfoViewController.orderId = [NSString stringWithFormat:@"%lld",orderId];
        payInfoViewController.price = weakSelf.gradeInfoObject.gradePrice;
        payInfoViewController.productName = weakSelf.gradeInfoObject.gradeName;
        [weakSelf.navigationController pushViewController:payInfoViewController animated:YES];
        
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    if(textField == _fieldTypeDesirer)
    {
        if(!self.gradeInfoArray || self.gradeInfoArray.count == 0)
        {
            typeof(self) weakSelf = self;
            [self requestGradeInfo:^(BOOL success) {
                if(success)
                {
                    //成功或者失败
                    [weakSelf editWishGradeType];
                }
            }];
        }
        else
        {
            [self editWishGradeType];
            return NO;
        }
        //请求香烛类型去
        return NO;
    }
    else if(textField == _fieldTimeDesirer)
    {
        [self editBirty];
        return NO;
    }
    else if(textField == _fieldPositionDesirer)
    {
        [self editCity];
        return NO;
    }
    return YES;
}

- (void)requestGradeInfo:(void(^)(BOOL success)) block
{
    typeof(self) weakSelf = self;
    [weakSelf showChrysanthemumHUD:YES];
    [ListTempleManager getGradeInfo:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        if(!self.gradeInfoArray || self.gradeInfoArray.count == 0)
        {
            weakSelf.gradeInfoArray = obj;
            if(block)
            {
                block(YES);
            }
        }
        //显示数据
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
        if(block)
        {
            block(NO);
        }
    }];
}

- (void)requestChoiceInfo:(void(^)(BOOL success)) block
{
    typeof(self) weakSelf = self;
    [weakSelf showChrysanthemumHUD:YES];
    [ListTempleManager getChoiceInfo:self.wishType successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        if(!self.choiceInfoArray || self.choiceInfoArray.count == 0)
        {
            weakSelf.choiceInfoArray = obj;
            if(block)
            {
                block(YES);
            }
        }
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
        if(block)
        {
            block(NO);
        }
    }];
}

/// 编辑城市
- (void)editCity {
    [self setupPickerView];
    [self enterPicker:_hometownPicker];
}


//编辑精选
- (void)editChoice
{
    if(!self.choiceInfoArray || self.choiceInfoArray.count == 0)
    {
        typeof(self) weakSelf = self;
        [self requestChoiceInfo:^(BOOL success) {
            if(success)
            {
                //成功或者失败
                [weakSelf setupPickerView];
                [weakSelf enterPicker:_choicePicker];
            }
        }];
    }
    else
    {
        [self setupPickerView];
        [self enterPicker:_choicePicker];
    }
}

//编辑香烛类型
- (void)editWishGradeType
{
    [self setupPickerView];
    [self enterPicker:_typePicker];
}

/// 编辑生日
- (void)editBirty {
    [self setupPickerView];
    
    [self birthdayPickerValueChange:_birthdayPicker];
    [self enterPicker:_birthdayPicker];
}

- (void)setupPickerView
{
    if (_pickerBackground != nil) return;
    
    self.birthdayPicker =[[UIDatePicker alloc] init];
    [self.birthdayPicker setDatePickerMode:UIDatePickerModeDate];
    self.birthdayPicker.locale = [NSLocale currentLocale];
    
    self.birthdayPicker.minimumDate = _minDate;

    self.birthObj = [[UserBirthdayObject alloc] init];
    self.birthObj.year = [NSNumber numberWithInteger:_minDate.year];
    self.birthObj.month = [NSNumber numberWithInteger:_minDate.month];
    self.birthObj.day = [NSNumber numberWithInteger:_minDate.day];

    [self.birthdayPicker addTarget:self action:@selector(birthdayPickerValueChange:) forControlEvents:UIControlEventValueChanged];
    
    
    _typePicker = [[UIPickerView alloc] init];
    _typePicker.delegate = self;
    _typePicker.showsSelectionIndicator = YES;
    
    _choicePicker = [[UIPickerView alloc] init];
    _choicePicker.delegate = self;
    _choicePicker.showsSelectionIndicator = YES;
    
    self.hometownPicker = [[UIPickerView alloc] init];
    self.hometownPicker.delegate = self;
    self.hometownPicker.showsSelectionIndicator = YES;
    self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hometown" ofType:@"plist"]];
    
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
    
    if(!self.homeObj.provinceName) {
        self.homeObj.provinceName = [[self.provinces objectAtIndex:0] objectForKey:@"provinceName"];
        self.homeObj.city = [[self.cities objectAtIndex:0] objectForKey:@"cityName"];
    }

    
    CGFloat barHeight = 40;
    _pickerBackground = [UIView new];
    _pickerBackground.frame = _scrollView.bounds;
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

-(void)birthdayPickerValueChange:(UIDatePicker *)paramDatePicker
{
    if ([paramDatePicker isEqual:self.birthdayPicker]) {
        self.birthDate = paramDatePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:self.birthDate];
        NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
        self.birthObj.year = @([dateArray[0] integerValue]);
        self.birthObj.month = @([dateArray[1] integerValue]);
        self.birthObj.day = @([dateArray[2] integerValue]);
        _fieldTimeDesirer.text = self.birthObj.transBirthDayToString;
    }
}

- (void)enterPicker:(UIView *)picker {
    _pickerBackground.backgroundColor = [UIColor clearColor];
    _pickerContainer.top = _pickerBackground.height;
    [_hometownPicker removeFromSuperview];
    [_birthdayPicker removeFromSuperview];
    [_choicePicker removeFromSuperview];
    [_typePicker removeFromSuperview];
    
    [_pickerContainer addSubview:picker];
    picker.top = _pickerConfirmBtn.bottom;
    
    [_scrollView addSubview:_pickerBackground];
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

- (void)confirmPicker
{
    if (_birthdayPicker.superview)
    {
        ///生日
        if(self.birthObj.transBirthDayToString)
        {
            [_fieldTimeDesirer setText:self.birthObj.transBirthDayToString];
        }

    }
    else if(_hometownPicker.superview)
    {
        //地区
        if(self.homeObj.provinceName)
        {
            [_fieldPositionDesirer setText:[NSString stringWithFormat:@"%@ - %@",self.homeObj.provinceName,self.homeObj.city]];
        }
    }
    else if(_typePicker.superview)
    {
        //香烛类型
        if(!self.gradeInfoObject.gradeName)
        {
            GradeInfoObject* infoObject = [self.gradeInfoArray objectAtIndex:0];
            self.gradeInfoObject = infoObject;
        }
        NSString* typeText = [NSString stringWithFormat:@"%@       %zd",self.gradeInfoObject.gradeName,self.gradeInfoObject.gradePrice];
        NSMutableAttributedString* typeStringText = [[NSMutableAttributedString alloc] initWithString:typeText];
        [typeStringText setAttributeKey:NSForegroundColorAttributeName value:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT) range:[typeText rangeOfString:[NSString stringWithFormat:@"%zd",self.gradeInfoObject.gradePrice]]];
        [_fieldTypeDesirer setAttributedText:typeStringText];
    }
    else if(_choicePicker.superview)
    {
        //精选
        if(!self.choice)
        {
           self.choice = [self.choiceInfoArray objectAtIndex:0];
        }
         [_commonTextFiled insertMessage:self.choice];
    }
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
    else if([pickerView isEqual:self.typePicker])
    {
        return [self.gradeInfoArray count];
    }
    else if([pickerView isEqual:self.choicePicker])
    {
        return [self.choiceInfoArray count];
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
    else if([pickerView isEqual:self.typePicker])
    {
        if(self.gradeInfoArray && self.gradeInfoArray.count > 0)
        {
            GradeInfoObject* infoObject = [self.gradeInfoArray objectAtIndex:row];
            return [NSString stringWithFormat:@"%@              %zd",infoObject.gradeName,infoObject.gradePrice];
        }
    }
    else if([pickerView isEqual:self.choicePicker])
    {
        if(self.choiceInfoArray && self.choiceInfoArray.count > 0)
        {
            return [self.choiceInfoArray objectAtIndex:row];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.hometownPicker]) {
        switch (component)
        {
            case 0:
                self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.hometownPicker selectRow:0 inComponent:1 animated:YES];
                [self.hometownPicker reloadComponent:1];
                //此处仍要给cityCode赋值，不然如果用户不对component1进行选择则无法赋值便无法正常上传
                self.homeObj.city = [[self.cities objectAtIndex:0] objectForKey:@"cityName"];
                self.homeObj.provinceName = [[self.provinces objectAtIndex:row] objectForKey:@"provinceName"];
                // self.provinceT.text = self.homeObj.transHomeToString;
                // self.provinceT.text = [[self.provinces objectAtIndex:row] objectForKey:@"province"];
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
    else if([pickerView isEqual:self.typePicker])
    {
        GradeInfoObject* infoObject = [self.gradeInfoArray objectAtIndex:row];
        self.gradeInfoObject = infoObject;
    }
    else if([pickerView isEqual:self.choicePicker])
    {
        self.choice = [self.choiceInfoArray objectAtIndex:row];
    }
}


@end
