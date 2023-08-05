//
//  MKGWMqttServerController.m
//  MKGatewayThree_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKGWMqttServerController.h"

#import <MessageUI/MessageUI.h>

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertView.h"

#import "MKGWImportServerController.h"

#import "MKGWExcelDataManager.h"

#import "MKGWDeviceModeManager.h"
#import "MKGWDeviceModel.h"

#import "MKGWMQTTDataManager.h"

#import "MKGWMqttServerModel.h"

#import "MKGWMqttServerConfigFooterView.h"

@interface MKGWMqttServerController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKGWMqttServerConfigFooterViewDelegate,
MFMailComposeViewControllerDelegate,
MKGWImportServerControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *sectionHeaderList;

@property (nonatomic, strong)MKGWMqttServerModel *dataModel;

@property (nonatomic, strong)MKGWMqttServerConfigFooterView *sslParamsView;

@property (nonatomic, strong)MKGWMqttServerConfigFooterViewModel *sslParamsModel;

@property (nonatomic, strong)UIView *footerView;

@end

@implementation MKGWMqttServerController

- (void)dealloc {
    NSLog(@"MKGWMqttServerController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUpdateCerts:)
                                                 name:MKGWReceiveDeviceUpdateMqttCertsResultNotification
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MKTextFieldCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *header = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    header.headerModel = self.sectionHeaderList[section];
    return header;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionHeaderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //host
        self.dataModel.host = value;
        MKTextFieldCellModel *cellModel = self.section0List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Port
        self.dataModel.port = value;
        MKTextFieldCellModel *cellModel = self.section0List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //clientID
        self.dataModel.clientID = value;
        MKTextFieldCellModel *cellModel = self.section0List[2];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Subscribe
        self.dataModel.subscribeTopic = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 4) {
        //Publish
        self.dataModel.publishTopic = value;
        MKTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKGWMqttServerConfigFooterViewDelegate
/// 用户改变了开关状态
/// @param isOn isOn
/// @param statusID 0:cleanSession   1:ssl    2:lwtStatus  3:lwtRetain
- (void)gw_mqtt_serverForDevice_switchStatusChanged:(BOOL)isOn statusID:(NSInteger)statusID {
    if (statusID == 0) {
        //cleanSession
        self.dataModel.cleanSession = isOn;
        self.sslParamsModel.cleanSession = isOn;
        return;
    }
    if (statusID == 1) {
        //ssl
        self.dataModel.sslIsOn = isOn;
        self.sslParamsModel.sslIsOn = isOn;
        //动态刷新footer
        [self setupSSLViewFrames];
        self.sslParamsView.dataModel = self.sslParamsModel;
        return;
    }
    if (statusID == 2) {
        //lwtStatus
        self.dataModel.lwtStatus = isOn;
        self.sslParamsModel.lwtStatus = isOn;
        return;
    }
    if (statusID == 3) {
        //lwtRetain
        self.dataModel.lwtRetain = isOn;
        self.sslParamsModel.lwtRetain = isOn;
        return;
    }
}

/// 输入框内容发生了改变
/// @param text 最新的输入框内容
/// @param textID 0:keepAlive    1:userName     2:password    3:deviceID   4:ntpURL  5:lwtTopic   6:lwtPayload 7:ssl host   8:ssl port         9:CA File Path     10:Client Key File           11:Client Cert  File
- (void)gw_mqtt_serverForDevice_textFieldValueChanged:(NSString *)text textID:(NSInteger)textID {
    if (textID == 0) {
        //keepAlive
        self.dataModel.keepAlive = text;
        self.sslParamsModel.keepAlive = text;
        return;
    }
    if (textID == 1) {
        //userName
        self.dataModel.userName = text;
        self.sslParamsModel.userName = text;
        return;
    }
    if (textID == 2) {
        //password
        self.dataModel.password = text;
        self.sslParamsModel.password = text;
        return;
    }
    if (textID == 5) {
        //LWT Topic
        self.dataModel.lwtTopic = text;
        self.sslParamsModel.lwtTopic = text;
        return;
    }
    if (textID == 6) {
        //LWT Payload
        self.dataModel.lwtPayload = text;
        self.sslParamsModel.lwtPayload = text;
        return;
    }
    if (textID == 7) {
        //CA File Path
        self.dataModel.caFilePath = text;
        self.sslParamsModel.caFilePath = text;
        return;
    }
    if (textID == 8) {
        //Client Key File
        self.dataModel.clientKeyPath = text;
        self.sslParamsModel.clientKeyPath = text;
        return;
    }
    if (textID == 9) {
        //Client Cert  File
        self.dataModel.clientCertPath = text;
        self.sslParamsModel.clientCertPath = text;
        return;
    }
}

- (void)gw_mqtt_serverForDevice_qosChanged:(NSInteger)qos qosID:(NSInteger)qosID{
    if (qosID == 0) {
        //qos
        self.dataModel.qos = qos;
        self.sslParamsModel.qos = qos;
        return;
    }
    if (qosID == 1) {
        //lwtQos
        self.dataModel.lwtQos = qos;
        self.sslParamsModel.lwtQos = qos;
        return;
    }
}

/// 用户选择了加密方式
/// @param certificate 0:CA signed server certificate     1:CA certificate     2:Self signed certificates
- (void)gw_mqtt_serverForDevice_certificateChanged:(NSInteger)certificate {
    self.dataModel.certificate = certificate;
    self.sslParamsModel.certificate = certificate;
    //动态刷新footer
    [self setupSSLViewFrames];
    self.sslParamsView.dataModel = self.sslParamsModel;
}

/// 底部按钮
/// @param index 0:Export Demo File   1:Import Config File
- (void)gw_mqtt_serverForDevice_bottomButtonPressed:(NSInteger)index {
    if (index == 0) {
        //Export Demo File
        [self exportServerConfig];
        return;;
    }
    if (index == 1) {
        //Import Config File
        MKGWImportServerController *vc = [[MKGWImportServerController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 2) {
        //Clear All Configurations
        [self showClearAlertView];
        return;
    }
}

#pragma mark - MKGWImportServerControllerDelegate
- (void)gw_selectedServerParams:(NSString *)fileName {
    [MKGWExcelDataManager parseDeviceExcel:fileName
                                   sucBlock:^(NSDictionary * _Nonnull returnData) {
        MKGWMqttServerModel *model = [MKGWMqttServerModel mk_modelWithJSON:returnData];
        [self.dataModel updateValue:model];
        [self.section0List removeAllObjects];
        [self.section1List removeAllObjects];
        [self.sectionHeaderList removeAllObjects];
        [self loadSectionDatas];
    }
                                failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - note
- (void)receiveUpdateCerts:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKGWDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    [[MKHudManager share] hide];
    self.leftButton.enabled = YES;
    NSInteger result = [user[@"data"][@"result_code"] integerValue];
    if (result == 1) {
        [self.view showCentralToast:@"setup succeed!"];
        [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
        return;
    }
    [self.view showCentralToast:@"setup failed"];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    NSString *errorMsg = [self.dataModel checkParams];
    if (ValidStr(errorMsg)) {
        [self.view showCentralToast:errorMsg];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    self.leftButton.enabled = NO;
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        //先判断是否下载证书
        if ((self.dataModel.connectMode == 2 || self.dataModel.connectMode == 3) && !(!ValidStr(self.dataModel.caFilePath) && !ValidStr(self.dataModel.clientKeyPath) && !ValidStr(self.dataModel.clientCertPath))) {
            //需要下载证书
            return;
        }
        //不需要证书
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup succeed!"];
        [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
        self.leftButton.enabled = YES;
    }];
}

#pragma mark - private method
- (void)exportServerConfig {
//    NSString *errorMsg = [self.dataModel checkParams];
//    if (ValidStr(errorMsg)) {
//        [self.view showCentralToast:errorMsg];
//        return;
//    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKGWExcelDataManager exportDeviceExcel:self.dataModel
                                    sucBlock:^{
        [[MKHudManager share] hide];
        [self sharedExcel];
    }
                                 failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)sharedExcel {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"Settings for device.xlsx"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self.view showCentralToast:@"File not exist"];
        return;
    }
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    if (!ValidData(data)) {
        [self.view showCentralToast:@"Load file error"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:data
                           mimeType:@"application/xlsx"
                           fileName:@"Settings for device.xlsx"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)showClearAlertView {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"NO" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"YES" handler:^{
        @strongify(self);
        [self clearAllParams];
    }];
    NSString *msg = @"Please confirm whether to delete all configurations in this page?";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_gw_needDismissAlert"];
}

- (void)clearAllParams {
    MKGWMqttServerModel *model = [[MKGWMqttServerModel alloc] init];
    model.cleanSession = YES;
    model.lwtStatus = YES;
    model.lwtQos = 1;
    
    [self.dataModel updateValue:model];
    [self.section0List removeAllObjects];
    [self.section1List removeAllObjects];
    [self.sectionHeaderList removeAllObjects];
    [self loadSectionDatas];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    [self loadSectionHeaderDatas];
    [self loadFooterViewDatas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Host";
    cellModel1.textPlaceholder = @"1-64 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.host;
    cellModel1.maxLength = 64;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Port";
    cellModel2.textPlaceholder = @"1-65535";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.port;
    cellModel2.maxLength = 5;
    [self.section0List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Client Id";
    cellModel3.textPlaceholder = @"1-64 Characters";
    cellModel3.textFieldType = mk_normal;
    cellModel3.textFieldValue = self.dataModel.clientID;
    cellModel3.maxLength = 64;
    [self.section0List addObject:cellModel3];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 3;
    cellModel1.msg = @"Subscribe";
    cellModel1.textPlaceholder = @"1-128 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.subscribeTopic;
    cellModel1.maxLength = 128;
    [self.section1List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 4;
    cellModel2.msg = @"Publish";
    cellModel2.textPlaceholder = @"1-128 Characters";
    cellModel2.textFieldType = mk_normal;
    cellModel2.textFieldValue = self.dataModel.publishTopic;
    cellModel2.maxLength = 128;
    cellModel2.noteMsg = @"Note: Input your topics to communicate with the device or set the topics to empty.";
    [self.section1List addObject:cellModel2];
}

- (void)loadSectionHeaderDatas {
    MKTableSectionLineHeaderModel *section0Model = [[MKTableSectionLineHeaderModel alloc] init];
    section0Model.contentColor = RGBCOLOR(242, 242, 242);
    section0Model.text = @"Broker Setting";
    [self.sectionHeaderList addObject:section0Model];
    
    MKTableSectionLineHeaderModel *section0Mode2 = [[MKTableSectionLineHeaderModel alloc] init];
    section0Mode2.contentColor = RGBCOLOR(242, 242, 242);
    section0Mode2.text = @"Topics";
    [self.sectionHeaderList addObject:section0Mode2];
}

- (void)loadFooterViewDatas {
    self.sslParamsModel.cleanSession = self.dataModel.cleanSession;
    self.sslParamsModel.qos = self.dataModel.qos;
    self.sslParamsModel.keepAlive = self.dataModel.keepAlive;
    self.sslParamsModel.userName = self.dataModel.userName;
    self.sslParamsModel.password = self.dataModel.password;
    self.sslParamsModel.sslIsOn = self.dataModel.sslIsOn;
    self.sslParamsModel.certificate = self.dataModel.certificate;
    self.sslParamsModel.caFilePath = self.dataModel.caFilePath;
    self.sslParamsModel.clientKeyPath = self.dataModel.clientKeyPath;
    self.sslParamsModel.clientCertPath = self.dataModel.clientCertPath;
    self.sslParamsModel.lwtStatus = self.dataModel.lwtStatus;
    self.sslParamsModel.lwtRetain = self.dataModel.lwtRetain;
    self.sslParamsModel.lwtQos = self.dataModel.lwtQos;
    self.sslParamsModel.lwtTopic = self.dataModel.lwtTopic;
    self.sslParamsModel.lwtPayload = self.dataModel.lwtPayload;
    
    //动态布局底部footer
    [self setupSSLViewFrames];
    
    self.sslParamsView.dataModel = self.sslParamsModel;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"MQTT settings";
    [self.rightButton setImage:LOADICON(@"MKGatewayThree", @"MKGWMqttServerController", @"gw_saveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

- (void)setupSSLViewFrames {
    if (self.sslParamsView.superview) {
        [self.sslParamsView removeFromSuperview];
    }

    CGFloat height = [self.sslParamsView fetchHeightWithSSLStatus:self.dataModel.sslIsOn
                                                       CAFileName:self.dataModel.caFilePath
                                                    clientKeyName:self.dataModel.clientKeyPath
                                                   clientCertName:self.dataModel.clientCertPath
                                                      certificate:self.dataModel.certificate];
    
    [self.footerView addSubview:self.sslParamsView];
    self.footerView.frame = CGRectMake(0, 0, kViewWidth, height + 70.f);
    self.sslParamsView.frame = CGRectMake(0, 0, kViewWidth, height);
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - getter

- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (MKGWMqttServerModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKGWMqttServerModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray *)sectionHeaderList {
    if (!_sectionHeaderList) {
        _sectionHeaderList = [NSMutableArray array];
    }
    return _sectionHeaderList;
}

- (MKGWMqttServerConfigFooterView *)sslParamsView {
    if (!_sslParamsView) {
        _sslParamsView = [[MKGWMqttServerConfigFooterView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 380.f)];
        _sslParamsView.delegate = self;
    }
    return _sslParamsView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 500.f)];
        _footerView.backgroundColor = COLOR_WHITE_MACROS;
        [_footerView addSubview:self.sslParamsView];
    }
    return _footerView;
}

- (MKGWMqttServerConfigFooterViewModel *)sslParamsModel {
    if (!_sslParamsModel) {
        _sslParamsModel = [[MKGWMqttServerConfigFooterViewModel alloc] init];
    }
    return _sslParamsModel;
}

@end
