import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_life_assistant/data/core/dio_util.dart';

class TikTokFunction {
  static const String tag = "TikTokFunction";

  static final TikTokFunction _instance = TikTokFunction._();

  TikTokFunction._();

  factory TikTokFunction.getInstance() {
    return _instance;
  }

  final List<Map<String, dynamic>> tiktokTools = [
    {
      "type": "function",
      "function": {
        "name": "parseTiktokShareUrl",
        "description": "从抖音的分享文本链接中提取无水印视频链接",
        "parameters": {
          "type": "object",
          "properties": {
            "shareText": {"type": "string", "description": "分享文本链接"},
          },
        },
        "required": ["shareText"],
      },
    },
  ];

  // 请求头定义
  final headers = {
    'User-Agent':
        'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1',
  };

  Future<Map<String, String>> parseTiktokShareUrl(String shareText) async {
    // 从分享文本中提取无水印视频链接
    final urlRegex = RegExp(
      r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+',
    );
    final urls =
        urlRegex.allMatches(shareText).map((match) => match.group(0)).toList();

    if (urls.isEmpty) {
      return {'error': '未找到有效的分享链接'};
    }

    var shareUrl = urls[0]!;
    var shareResponse = await DioUtil.getInstance().get(
      shareUrl,
      headers: headers,
    );
    final redirectedUrl = shareResponse.realUri.toString();
    final videoId = redirectedUrl
        .split('?')[0]
        .split('/')
        .lastWhere((part) => part.isNotEmpty);
    shareUrl = 'https://www.iesdouyin.com/share/video/$videoId';

    // 获取视频页面内容
    final response = await http.get(Uri.parse(shareUrl), headers: headers);
    if (response.statusCode != 200) {
      return {'error': '请求失败: ${response.statusCode}'};
    }

    // 使用正则表达式提取JSON数据
    final pattern = RegExp(
      r'window\._ROUTER_DATA\s*=\s*(.*?)</script>',
      dotAll: true,
    );
    final match = pattern.firstMatch(response.body);

    if (match == null || match.group(1) == null) {
      return {'error': '从HTML中解析视频信息失败'};
    }

    // 解析JSON数据
    final jsonData = json.decode(match.group(1)!.trim());
    const videoIdPageKey = 'video_(id)/page';
    const noteIdPageKey = 'note_(id)/page';

    dynamic originalVideoInfo;
    if (jsonData['loaderData'][videoIdPageKey] != null) {
      originalVideoInfo =
          jsonData['loaderData'][videoIdPageKey]['videoInfoRes'];
    } else if (jsonData['loaderData'][noteIdPageKey] != null) {
      originalVideoInfo = jsonData['loaderData'][noteIdPageKey]['videoInfoRes'];
    } else {
      return {'error': '无法从JSON中解析视频或图集信息'};
    }

    if (originalVideoInfo['item_list'] == null ||
        originalVideoInfo['item_list'].isEmpty) {
      return {'error': '无法从JSON中解析视频或图集信息'};
    }

    final data = originalVideoInfo['item_list'][0];
    // 获取视频信息
    String videoUrl = data['video']['play_addr']['url_list'][0].replaceAll(
      'playwm',
      'play',
    );
    String desc = data['desc']?.toString().trim() ?? 'douyin_$videoId';

    // 替换文件名中的非法字符
    desc = desc.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

    return {'url': videoUrl, 'title': desc, 'video_id': videoId};
  }
}
