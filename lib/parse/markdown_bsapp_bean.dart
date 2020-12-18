/// appName : "def"
/// desc : "123"
/// iconUrl : "https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/img19.jpg"
/// android : {"pkgName":"def","downloadUrl":"https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4","deeplinkUrl":"https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4","h5Url":"https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4","downloadNum":"2.5亿","size":25000,"version":"1.2.2"}
/// ios : {"pkgName":"def","deeplinkUrl":"https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4","h5Url":"https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4","size":25000,"version":"1.2.2","downloadNum":"2.5亿"}

class MarkdownBsappBean {
  String appName;
  String desc;
  String iconUrl;
  AndroidBean android;
  IosBean ios;

  static MarkdownBsappBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    MarkdownBsappBean markdownBsappBeanBean = MarkdownBsappBean();
    markdownBsappBeanBean.appName = map['appName'];
    markdownBsappBeanBean.desc = map['desc'];
    markdownBsappBeanBean.iconUrl = map['iconUrl'];
    markdownBsappBeanBean.android = AndroidBean.fromMap(map['android']);
    markdownBsappBeanBean.ios = IosBean.fromMap(map['ios']);
    return markdownBsappBeanBean;
  }

  Map toJson() => {
    "appName": appName,
    "desc": desc,
    "iconUrl": iconUrl,
    "android": android,
    "ios": ios,
  };
}

/// pkgName : "def"
/// deeplinkUrl : "https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4"
/// h5Url : "https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4"
/// size : 25000
/// version : "1.2.2"
/// downloadNum : "2.5亿"

class IosBean {
  String pkgName;
  String deeplinkUrl;
  String h5Url;
  int size;
  String version;
  String downloadNum;

  static IosBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    IosBean iosBean = IosBean();
    iosBean.pkgName = map['pkgName'];
    iosBean.deeplinkUrl = map['deeplinkUrl'];
    iosBean.h5Url = map['h5Url'];
    iosBean.size = map['size'];
    iosBean.version = map['version'];
    iosBean.downloadNum = map['downloadNum'];
    return iosBean;
  }

  Map toJson() => {
    "pkgName": pkgName,
    "deeplinkUrl": deeplinkUrl,
    "h5Url": h5Url,
    "size": size,
    "version": version,
    "downloadNum": downloadNum,
  };
}

/// pkgName : "def"
/// downloadUrl : "https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4"
/// deeplinkUrl : "https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4"
/// h5Url : "https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4"
/// downloadNum : "2.5亿"
/// size : 25000
/// version : "1.2.2"

class AndroidBean {
  String pkgName;
  String downloadUrl;
  String deeplinkUrl;
  String h5Url;
  String downloadNum;
  int size;
  String version;

  static AndroidBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AndroidBean androidBean = AndroidBean();
    androidBean.pkgName = map['pkgName'];
    androidBean.downloadUrl = map['downloadUrl'];
    androidBean.deeplinkUrl = map['deeplinkUrl'];
    androidBean.h5Url = map['h5Url'];
    androidBean.downloadNum = map['downloadNum'];
    androidBean.size = map['size'];
    androidBean.version = map['version'];
    return androidBean;
  }

  Map toJson() => {
    "pkgName": pkgName,
    "downloadUrl": downloadUrl,
    "deeplinkUrl": deeplinkUrl,
    "h5Url": h5Url,
    "downloadNum": downloadNum,
    "size": size,
    "version": version,
  };
}