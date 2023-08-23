
typedef NS_ENUM(NSInteger, mk_gw_serverOperationID) {
    mk_gw_defaultServerOperationID,
    
#pragma mark - Config
    mk_gw_server_taskRebootDeviceOperation,             //重启设备
    mk_gw_server_taskKeyResetTypeOperation,             //配置按键恢复出厂设置类型
    mk_gw_server_taskConfigNetworkStatusReportIntervalOperation,    //配置网络状态上报间隔
    mk_gw_server_taskConfigReconnectTimeoutOperation,           //配置网络重连超时时间
    mk_gw_server_taskConfigOTAHostOperation,                    //OTA
    mk_gw_server_taskConfigNTPServerOperation,                  //配置NTP服务器信息
    mk_gw_server_taskConfigDeviceTimeZoneOperation,             //配置设备的UTC时间
    mk_gw_server_taskConfigCommunicationTimeoutOperation,       //配置通信超时时间
    mk_gw_server_taskConfigIndicatorLightStatusOperation,       //配置指示灯开关
    mk_gw_server_taskResetDeviceOperation,              //恢复出厂设置
    mk_gw_server_taskConfigNpcOTAHostOperation,         //Npc Ota
    mk_gw_server_taskModifyWifiInfosOperation,          //配置wifi网络
    mk_gw_server_taskModifyWifiCertsOperation,          //配置EAP证书
    mk_gw_server_taskModifyWifiNetworkInfoOperation,        //配置Wifi网络参数
    mk_gw_server_taskModifyNetworkTypeOperation,            //配置网络接口类型
    mk_gw_server_taskModifyEthernetNetworkInfoOperation,    //配置Ethernet网络参数
    mk_gw_server_taskModifyMqttInfoOperation,           //配置MQTT参数
    mk_gw_server_taskModifyMqttCertsOperation,          //配置MQTT证书
    mk_gw_server_taskConfigScanSwitchStatusOperation,   //配置扫描开关状态
    mk_gw_server_taskConfigFilterRelationshipsOperation,  //配置过滤逻辑
    mk_gw_server_taskConfigFilterByRSSIOperation,         //配置过滤RSSI
    mk_gw_server_taskConfigFilterByMacAddressOperation,     //配置过滤mac
    mk_gw_server_taskConfigFilterByADVNameOperation,        //配置过滤ADV Name
    mk_gw_server_taskConfigFilterByBeaconOperation,         //配置过滤iBeacon信息
    mk_gw_server_taskConfigFilterByUIDOperation,            //配置过滤UID信息
    mk_gw_server_taskConfigFilterByUrlOperation,            //配置过滤Url信息
    mk_gw_server_taskConfigFilterByTLMOperation,            //配置过滤TLM信息
    mk_gw_server_taskConfigFilterBXPDeviceInfoOperation,    //配置bxp-deviceInfo过滤状态
    mk_gw_server_taskConfigFilterBXPAccOperation,           //配置bxp-acc过滤状态
    mk_gw_server_taskConfigFilterBXPTHOperation,            //配置bxp-th过滤状态
    mk_gw_server_taskConfigFilterBXPButtonOperation,        //配置过滤bxp-button信息
    mk_gw_server_taskConfigFilterByTagOperation,            //配置过滤bxp_tag信息
    mk_gw_server_taskConfigFilterByPirOperation,            //配置过滤PIR信息
    mk_gw_server_taskConfigFilterByOtherDatasOperation,     //配置过滤Other信息
    mk_gw_server_taskConfigDuplicateDataFilterOperation,    //配置扫描重复数据参数
    mk_gw_server_taskConfigDataReportTimeoutOperation,      //配置数据包上报超时时间
    mk_gw_server_taskConfigUploadDataOptionOperation,       //配置扫描数据上报内容选项
    mk_gw_server_taskConfigFilterByPHYOperation,            //配置扫描过滤PHY
    
    mk_gw_server_taskConnectBXPButtonWithMacOperation,      //连接指定mac地址的BXP-Button设备
    
    mk_gw_server_taskDisconnectNormalBleDeviceWithMacOperation, //网关断开指定mac地址的蓝牙设备
    mk_gw_server_taskStartBXPButtonDfuWithMacOperation,         //指定BXP-Button设备DFU升级
    
    mk_gw_server_taskConnectNormalBleDeviceWithMacOperation,    //网关连接指定mac地址的蓝牙设备
    
#pragma mark - Read
    mk_gw_server_taskReadKeyResetTypeOperation,         //读取按键恢复出厂设置类型
    mk_gw_server_taskReadDeviceInfoOperation,           //读取设备信息
    mk_gw_server_taskReadNetworkStatusReportIntervalOperation,  //读取网络状态上报间隔
    mk_gw_server_taskReadNetworkReconnectTimeoutOperation,      //读取网络重连超时时间
    mk_gw_server_taskReadNTPServerOperation,                    //读取NTP服务器信息
    mk_gw_server_taskReadDeviceUTCTimeOperation,                //读取当前UTC时间
    mk_gw_server_taskReadCommunicateTimeoutOperation,           //读取通信超时时间
    mk_gw_server_taskReadIndicatorLightStatusOperation,         //读取指示灯开关
    mk_gw_server_taskReadOtaStatusOperation,                    //读取当前设备OTA状态
    mk_gw_server_taskReadWifiInfosOperation,                    //读取设备当前连接的wifi信息
    mk_gw_server_taskReadWifiNetworkInfosOperation,                 //读取Wifi网络参数
    mk_gw_server_taskReadNetworkTypeOperation,                  //读取网络接口选择
    mk_gw_server_taskReadEthernetNetworkInfosOperation,         //读取读取Ethernet网络参数
    mk_gw_server_taskReadMQTTParamsOperation,                   //读取MQTT服务器信息
    mk_gw_server_taskReadScanSwitchStatusOperation,    //读取扫描开关状态
    mk_gw_server_taskReadFilterRelationshipsOperation,  //读取过滤逻辑
    mk_gw_server_taskReadFilterByRSSIOperation,         //读取过滤RSSI
    mk_gw_server_taskReadFilterByMacOperation,          //读取过滤MAC
    mk_gw_server_taskReadFilterADVNameRSSIOperation,    //读取过滤ADV Name
    mk_gw_server_taskReadFilterByRawDataStatusOperation,    //读取RAW类型过滤开关
    mk_gw_server_taskReadFilterByBeaconOperation,           //读取iBeacon过滤内容
    mk_gw_server_taskReadFilterByUIDOperation,              //读取UID过滤内容
    mk_gw_server_taskReadFilterByUrlOperation,              //读取Url过滤内容
    mk_gw_server_taskReadFilterByTLMOperation,              //读取TLM过滤内容
    mk_gw_server_taskReadFilterBXPDeviceInfoStatusOperation,    //读取bxp-deviceInfo过滤开关
    mk_gw_server_taskReadFilterBXPAccStatusOperation,           //读取bxp-acc过滤开关
    mk_gw_server_taskReadFilterBXPTHStatusOperation,            //读取bxp-th过滤开关
    mk_gw_server_taskReadFilterBXPButtonOperation,              //读取bxp-button过滤内容
    mk_gw_server_taskReadFilterBXPTagOperation,                 //读取bxp-tag过滤内容
    mk_gw_server_taskReadFilterByPirOperation,                  //读取pir过滤内容
    mk_gw_server_taskReadFilterOtherDatasOperation,             //读取过滤Other信息
    mk_gw_server_taskReadDuplicateDataFilterDatasOperation,     //读取扫描重复数据参数
    mk_gw_server_taskReadDataReportTimeoutOperation,            //读取数据上报超时时间
    mk_gw_server_taskReadUploadDataOptionOperation,             //读取扫描数据上报内容选项
    mk_gw_server_taskReadFilterByPHYOperation,                  //读取Phy过滤类型
    
    mk_gw_server_taskReadBXPButtonConnectedDeviceInfoOperation, //读取已连接BXP-Button设备信息
    mk_gw_server_taskReadBXPButtonStatusOperation,              //读取已连接BXP-Button的状态
    mk_gw_server_taskDismissAlarmStatusOperation,               //BXP-Button消警
    
    mk_gw_server_taskReadGatewayBleConnectStatusOperation,      //读取网关蓝牙连接的状态
    
    mk_gw_server_taskReadNormalConnectedDeviceInfoOperation,    //读取蓝牙网关连接的指定设备的服务和特征信息
    mk_gw_server_taskNotifyCharacteristicOperation,             //打开/关闭监听指定特征
    mk_gw_server_taskReadCharacteristicValueOperation,          //读取蓝牙网关连接的指定设备的特征值
    mk_gw_server_taskWriteCharacteristicValueOperation,         //向蓝牙网关连接的指定设备的指定特征写入值
    
    
    mk_gw_server_taskReadAdvertiseBeaconParamsOperation,    //读取iBeacon广播参数
    mk_gw_server_taskConfigAdvertiseBeaconParamsOperation,  //配置iBeacon广播参数
    
};
