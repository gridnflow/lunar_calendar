import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FortuneService {
  static const String _countKey = 'gemini_daily_count';
  static const String _dateKey = 'gemini_daily_date';
  static const int _dailyLimit = 1200;

  final String _apiKey;
  FortuneService({String apiKey = ''}) : _apiKey = apiKey;

  Future<String> getTodayFortune({
    required String yearPillar,
    required String monthPillar,
    required String dayPillar,
    required String lunarDate,
    String? sajuYear,
    String? sajuMonth,
    String? sajuDay,
    String? sajuHour,
  }) async {
    if (_apiKey.isNotEmpty && await _canUseGemini()) {
      try {
        final result = await _getGeminiFortune(
          yearPillar: yearPillar,
          monthPillar: monthPillar,
          dayPillar: dayPillar,
          lunarDate: lunarDate,
          sajuYear: sajuYear,
          sajuMonth: sajuMonth,
          sajuDay: sajuDay,
          sajuHour: sajuHour,
        );
        await _incrementCount();
        return result;
      } catch (_) {
        // Fall through to local
      }
    }
    return _getLocalFortune(dayPillar: dayPillar, monthPillar: monthPillar);
  }

  Future<bool> _canUseGemini() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayString();
    final savedDate = prefs.getString(_dateKey) ?? '';
    if (savedDate != today) {
      await prefs.setString(_dateKey, today);
      await prefs.setInt(_countKey, 0);
      return true;
    }
    final count = prefs.getInt(_countKey) ?? 0;
    return count < _dailyLimit;
  }

  Future<void> _incrementCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_countKey) ?? 0;
    await prefs.setInt(_countKey, count + 1);
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<String> _getGeminiFortune({
    required String yearPillar,
    required String monthPillar,
    required String dayPillar,
    required String lunarDate,
    String? sajuYear,
    String? sajuMonth,
    String? sajuDay,
    String? sajuHour,
  }) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );

    final sajuInfo = (sajuYear != null && sajuYear.isNotEmpty)
        ? '사주: 년주=$sajuYear, 월주=$sajuMonth, 일주=$sajuDay'
            '${sajuHour != null && sajuHour.isNotEmpty ? ", 시주=$sajuHour" : ""}'
        : '';

    final prompt = '''
오늘의 운세를 한국어로 알려주세요.

오늘 날짜: $lunarDate
오늘의 연주: $yearPillar
오늘의 월주: $monthPillar
오늘의 일주: $dayPillar
${sajuInfo.isNotEmpty ? sajuInfo : ''}

다음 항목별로 간결하게 2~3문장씩 작성해주세요:
- 총운
- 재물운
- 연애운
- 건강운

따뜻하고 긍정적인 톤으로, 실용적인 조언을 포함해주세요.
''';

    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? _getLocalFortune(dayPillar: dayPillar, monthPillar: monthPillar);
  }

  String _getLocalFortune({
    required String dayPillar,
    required String monthPillar,
  }) {
    final index = (dayPillar.hashCode ^ monthPillar.hashCode).abs() % _localFortunes.length;
    return _localFortunes[index];
  }

  static const List<String> _localFortunes = [
    '**총운** 오늘은 새로운 시작에 좋은 날입니다. 미루던 일을 시작해보세요.\n\n**재물운** 불필요한 지출을 자제하면 좋겠습니다. 계획적인 소비가 필요한 날입니다.\n\n**연애운** 가까운 사람에게 먼저 다가가면 좋은 결과가 있을 것입니다.\n\n**건강운** 충분한 수면과 규칙적인 식사로 컨디션을 유지하세요.',
    '**총운** 오늘은 인내가 필요한 날입니다. 서두르지 말고 차분하게 행동하세요.\n\n**재물운** 예상치 못한 소득의 기회가 있을 수 있습니다. 주변을 잘 살펴보세요.\n\n**연애운** 솔직한 대화가 관계를 더욱 깊게 만들어 줄 것입니다.\n\n**건강운** 가벼운 운동이 스트레스 해소에 도움이 됩니다.',
    '**총운** 오늘은 협력과 소통이 중요한 날입니다. 혼자보다 함께 할 때 더 큰 성과가 있습니다.\n\n**재물운** 투자보다는 저축에 집중하는 것이 유리합니다.\n\n**연애운** 상대방의 입장에서 생각해보는 하루가 되세요.\n\n**건강운** 과로를 피하고 적절한 휴식을 취하세요.',
    '**총운** 창의적인 아이디어가 빛을 발하는 날입니다. 자신감을 가지고 표현해보세요.\n\n**재물운** 작은 돈도 소중히 여기는 자세가 큰 재물을 부릅니다.\n\n**연애운** 뜻밖의 만남에서 좋은 인연이 시작될 수 있습니다.\n\n**건강운** 물을 충분히 마시고 스트레칭을 자주 해주세요.',
    '**총운** 오늘은 감사한 마음으로 주변을 돌아보는 날입니다. 작은 것에서 행복을 찾아보세요.\n\n**재물운** 신중한 판단이 필요한 날입니다. 큰 결정은 미루는 것이 좋습니다.\n\n**연애운** 진심 어린 표현이 마음을 움직입니다.\n\n**건강운** 무리한 다이어트보다 균형 잡힌 식사가 중요합니다.',
    '**총운** 오늘은 계획한 일들이 순조롭게 진행되는 날입니다. 적극적으로 움직여 보세요.\n\n**재물운** 재물운이 상승하는 날입니다. 중요한 계약이나 거래에 좋은 날입니다.\n\n**연애운** 진지한 대화를 통해 관계가 한 단계 발전할 수 있습니다.\n\n**건강운** 오늘은 몸 상태가 좋습니다. 운동을 시작하기 좋은 날입니다.',
    '**총운** 변화와 도전을 두려워하지 마세요. 오늘의 용기가 내일의 성공을 만듭니다.\n\n**재물운** 지출보다 수입에 집중하는 날입니다. 부업이나 추가 소득을 고려해보세요.\n\n**연애운** 기다림보다 먼저 다가가는 것이 좋은 결과를 가져옵니다.\n\n**건강운** 정신 건강에 신경 쓰는 날입니다. 명상이나 독서를 추천합니다.',
    '**총운** 오늘은 주변 사람들과의 관계에서 에너지를 얻는 날입니다. 소통을 즐겨보세요.\n\n**재물운** 분산 투자보다 안정적인 자산 관리가 유리합니다.\n\n**연애운** 작은 배려와 관심이 큰 감동을 줄 수 있습니다.\n\n**건강운** 오늘은 소화기 건강에 주의하세요. 과식을 피하세요.',
    '**총운** 집중력이 높아지는 날입니다. 중요한 업무나 공부에 집중하기 좋습니다.\n\n**재물운** 충동구매를 자제하면 월말에 여유 자금이 생길 것입니다.\n\n**연애운** 오늘은 자신을 사랑하는 시간을 가져보세요. 자기 사랑이 먼저입니다.\n\n**건강운** 규칙적인 생활 패턴이 건강의 기본입니다.',
    '**총운** 좋은 소식이 기다리고 있는 날입니다. 긍정적인 마음으로 하루를 시작하세요.\n\n**재물운** 오늘은 재물운이 평범합니다. 현상 유지에 집중하세요.\n\n**연애운** 감정 표현에 솔직해지는 날입니다. 마음을 전해보세요.\n\n**건강운** 야외 활동이 기분 전환에 도움이 됩니다.',
  ];
}
