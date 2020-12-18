/// width : "300"
/// height : "400"
/// url : "https://office-1256119282.cos.ap-chengdu.myqcloud.com/office-cn/official-m/static/img/skyw/sky.mp4"
/// title : "abc"
/// desc : "描述"
/// publishTime : "发布时间"
/// createTime : "创建时间"
/// duration : 200

class MarkdownVideoBean {
  String width;
  String height;
  String url;
  String title;
  String desc;
  String publishTime;
  String createTime;
  int duration;

  static MarkdownVideoBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    MarkdownVideoBean markdownVideoBeanBean = MarkdownVideoBean();
    markdownVideoBeanBean.width = map['width'];
    markdownVideoBeanBean.height = map['height'];
    markdownVideoBeanBean.url = map['url'];
    markdownVideoBeanBean.title = map['title'];
    markdownVideoBeanBean.desc = map['desc'];
    markdownVideoBeanBean.publishTime = map['publishTime'];
    markdownVideoBeanBean.createTime = map['createTime'];
    markdownVideoBeanBean.duration = map['duration'];
    return markdownVideoBeanBean;
  }

  Map toJson() => {
    "width": width,
    "height": height,
    "url": url,
    "title": title,
    "desc": desc,
    "publishTime": publishTime,
    "createTime": createTime,
    "duration": duration,
  };
}