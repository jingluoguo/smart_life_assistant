import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_life_assistant/data/function_calling/tiktok_function.dart';
import 'package:smart_life_assistant/data/function_calling/weather_function.dart';

class FunctionCallService {
  static const String _tag = "FunctionCallService";

  static final FunctionCallService _instance = FunctionCallService._();

  FunctionCallService._();

  factory FunctionCallService.getInstance() {
    return _instance;
  }

  final List<Map<String, dynamic>> tools = [
    ...WeatherFunction.getInstance().weatherTools,
    ...TikTokFunction.getInstance().tiktokTools,
  ];

  final apiUrl =
      "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions";
  final apiKey = "sk-9a65c355846e407292f7fcd77220b6d7";
  final model = "qwen3-max";

  final Dio _dio = Dio();

  void handleFunctionCall({required String text}) async {
    var messages = [];
    messages.add({
      'role': "system",
      "content": "不要假设或猜测传入函数的参数值。如果用户的描述不明确，请要求用户提供必要信息。",
    });
    messages.add({"role": "user", "content": text});

    debugPrint('$_tag 开始调用模型');
    Response response = await _dio.post(
      apiUrl,
      data: {'model': model, 'messages': messages, 'tools': tools},
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
    );
    debugPrint('$_tag 第一次调用模型的请求参数：$messages');
    debugPrint('$_tag 第一次调用模型的回答结果：${response.data['choices'][0]['message']}');
    messages.add(response.data['choices'][0]['message']);
    var toolCalls = response.data['choices'][0]['message']['tool_calls'];
    if (toolCalls != null && toolCalls.length > 0) {
      parseFunctionCall(
        response.data['choices'][0]['message']['tool_calls'][0]['function'],
        messages,
      );
    } else {
      debugPrint('$_tag 没合适的处理方法：${response.data}');
    }
  }

  void parseFunctionCall(Map toolCall, List messages) async {
    var callName = toolCall['name'];
    Response? response;
    if (callName == 'getRealTimeWeatherInfo') {
      var arguments = toolCall['arguments'];
      var args = jsonDecode(arguments);
      var content = await WeatherFunction.getInstance().getRealTimeWeatherInfo(
        args['lng'],
        args['lat'],
      );
      messages.add({'role': 'tool', 'content': content});
      response = await _dio.post(
        apiUrl,
        data: {'model': model, 'messages': messages, 'tools': tools},
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
    } else if (callName == 'getNextHoursWeatherInfo') {
      var arguments = toolCall['arguments'];
      var args = jsonDecode(arguments);
      var content = await WeatherFunction.getInstance().getNextHoursWeatherInfo(
        args['lng'],
        args['lat'],
        args['hours'],
      );
      messages.add({'role': 'tool', 'content': content});
      response = await _dio.post(
        apiUrl,
        data: {'model': model, 'messages': messages, 'tools': tools},
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
    } else if (callName == 'getEveryDayWeatherInfo') {
      var arguments = toolCall['arguments'];
      var args = jsonDecode(arguments);
      var content = await WeatherFunction.getInstance().getEveryDayWeatherInfo(
        args['lng'],
        args['lat'],
        args['days'],
      );
      messages.add({'role': 'tool', 'content': content});
      response = await _dio.post(
        apiUrl,
        data: {'model': model, 'messages': messages, 'tools': tools},
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
    } else if (callName == 'parseTiktokShareUrl') {
      var arguments = toolCall['arguments'];
      var args = jsonDecode(arguments);
      var content = await TikTokFunction.getInstance().parseTiktokShareUrl(
        args['shareText']
      );
      messages.add({'role': 'tool', 'content': content.toString()});
      response = await _dio.post(
        apiUrl,
        data: {'model': model, 'messages': messages, 'tools': tools},
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
    }
    debugPrint('$_tag 第二次调用模型的请求参数：$messages');
    debugPrint('$_tag 第二次调用模型的回答结果：${response?.data['choices'][0]['message']}');
  }
}
