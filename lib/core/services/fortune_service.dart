import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FortuneService {
  final String _apiKey;

  /// In-memory cache: languageCode → fortuneText (cleared on new day)
  final Map<String, String> _memCache = {};
  String _cacheDate = '';

  FortuneService({String apiKey = ''}) : _apiKey = apiKey;

  String _cacheKey(String languageCode) =>
      'fortune_${_todayString()}_$languageCode';

  Future<String> getTodayFortune({
    required String yearPillar,
    required String monthPillar,
    required String dayPillar,
    required String lunarDate,
    String? sajuYear,
    String? sajuMonth,
    String? sajuDay,
    String? sajuHour,
    String languageCode = 'ko',
  }) async {
    final today = _todayString();

    // Clear in-memory cache on new day
    if (_cacheDate != today) {
      _memCache.clear();
      _cacheDate = today;
    }

    // 1. In-memory cache hit
    if (_memCache.containsKey(languageCode)) {
      return _memCache[languageCode]!;
    }

    // 2. Persistent cache hit (survived app restart)
    final prefs = await SharedPreferences.getInstance();
    final persisted = prefs.getString(_cacheKey(languageCode));
    if (persisted != null) {
      _memCache[languageCode] = persisted;
      return persisted;
    }

    // 3. Generate via Gemini (once per language per day)
    String result;
    if (_apiKey.isNotEmpty) {
      try {
        result = await _getGeminiFortune(
          yearPillar: yearPillar,
          monthPillar: monthPillar,
          dayPillar: dayPillar,
          lunarDate: lunarDate,
          sajuYear: sajuYear,
          sajuMonth: sajuMonth,
          sajuDay: sajuDay,
          sajuHour: sajuHour,
          languageCode: languageCode,
        );
      } catch (_) {
        result = _getLocalFortune(dayPillar: dayPillar, monthPillar: monthPillar, languageCode: languageCode);
      }
    } else {
      result = _getLocalFortune(dayPillar: dayPillar, monthPillar: monthPillar, languageCode: languageCode);
    }

    // Save to both caches
    _memCache[languageCode] = result;
    await prefs.setString(_cacheKey(languageCode), result);
    return result;
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
    String languageCode = 'ko',
  }) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );

    final sajuInfo = (sajuYear != null && sajuYear.isNotEmpty)
        ? 'Four Pillars: Year=$sajuYear, Month=$sajuMonth, Day=$sajuDay'
            '${sajuHour != null && sajuHour.isNotEmpty ? ", Hour=$sajuHour" : ""}'
        : '';

    final langName = _languageName(languageCode);
    final prompt = '''
Please provide today's fortune in $langName.

Today's lunar date: $lunarDate
Today's year pillar: $yearPillar
Today's month pillar: $monthPillar
Today's day pillar: $dayPillar
${sajuInfo.isNotEmpty ? sajuInfo : ''}

Write 2–3 concise sentences for each category:
- Overall Fortune
- Wealth Fortune
- Love Fortune
- Health Fortune

Use a warm, positive tone with practical advice.
Respond entirely in $langName.
''';

    final response = await model
        .generateContent([Content.text(prompt)])
        .timeout(const Duration(seconds: 30));
    return response.text ?? _getLocalFortune(dayPillar: dayPillar, monthPillar: monthPillar, languageCode: languageCode);
  }

  String _languageName(String code) {
    switch (code) {
      case 'ko': return 'Korean';
      case 'ja': return 'Japanese';
      case 'zh': return 'Simplified Chinese';
      case 'zh_TW': return 'Traditional Chinese';
      case 'vi': return 'Vietnamese';
      case 'id': return 'Indonesian';
      case 'ms': return 'Malay';
      case 'ru': return 'Russian';
      case 'tr': return 'Turkish';
      default:   return 'English';
    }
  }

  String _getLocalFortune({
    required String dayPillar,
    required String monthPillar,
    String languageCode = 'ko',
  }) {
    final fortunes = _localFortunesByLang[languageCode] ??
        _localFortunesByLang['en']!;
    final index = (dayPillar.hashCode ^ monthPillar.hashCode).abs() % fortunes.length;
    return fortunes[index];
  }

  static const Map<String, List<String>> _localFortunesByLang = {
    'ko': [
      '**총운** 오늘은 새로운 시작에 좋은 날입니다. 미루던 일을 시작해보세요.\n\n**재물운** 불필요한 지출을 자제하면 좋겠습니다.\n\n**연애운** 가까운 사람에게 먼저 다가가면 좋은 결과가 있을 것입니다.\n\n**건강운** 충분한 수면과 규칙적인 식사로 컨디션을 유지하세요.',
      '**총운** 오늘은 인내가 필요한 날입니다. 차분하게 행동하세요.\n\n**재물운** 예상치 못한 소득의 기회가 있을 수 있습니다.\n\n**연애운** 솔직한 대화가 관계를 더욱 깊게 만들어 줄 것입니다.\n\n**건강운** 가벼운 운동이 스트레스 해소에 도움이 됩니다.',
      '**총운** 협력과 소통이 중요한 날입니다.\n\n**재물운** 투자보다는 저축에 집중하는 것이 유리합니다.\n\n**연애운** 상대방의 입장에서 생각해보는 하루가 되세요.\n\n**건강운** 과로를 피하고 적절한 휴식을 취하세요.',
    ],
    'en': [
      '**Overall** A great day for new beginnings. Start something you have been putting off.\n\n**Wealth** Avoid unnecessary spending and plan your finances carefully.\n\n**Love** Taking the first step toward someone close will bring good results.\n\n**Health** Maintain your condition with enough sleep and regular meals.',
      '**Overall** Patience is key today. Act calmly without rushing.\n\n**Wealth** An unexpected income opportunity may arise — keep your eyes open.\n\n**Love** Honest conversation will deepen your relationship.\n\n**Health** Light exercise helps relieve stress.',
      '**Overall** Cooperation and communication matter most today.\n\n**Wealth** Focus on saving rather than investing.\n\n**Love** Try to see things from your partner\'s perspective today.\n\n**Health** Avoid overwork and take adequate rest.',
    ],
    'ja': [
      '**総運** 新しいことを始めるのに良い日です。後回しにしていたことを始めましょう。\n\n**金運** 不要な出費を控え、計画的な消費を心がけましょう。\n\n**恋愛運** 身近な人に自分から近づくと良い結果が生まれます。\n\n**健康運** 十分な睡眠と規則正しい食事でコンディションを維持してください。',
      '**総運** 今日は忍耐が必要な日です。焦らず落ち着いて行動しましょう。\n\n**金運** 思わぬ収入のチャンスがあるかもしれません。\n\n**恋愛運** 正直な会話が関係をより深めてくれるでしょう。\n\n**健康運** 軽い運動がストレス解消に役立ちます。',
      '**総運** 協力とコミュニケーションが大切な日です。\n\n**金運** 投資よりも貯蓄に集中するのが有利です。\n\n**恋愛運** 相手の立場で考えてみる一日にしてください。\n\n**健康運** 過労を避け、適切な休息をとりましょう。',
    ],
    'zh': [
      '**总运** 今天是新开始的好日子，开始那些一直推迟的事情吧。\n\n**财运** 避免不必要的支出，做好财务规划。\n\n**爱情运** 主动接近身边的人会带来好的结果。\n\n**健康运** 保持充足睡眠和规律饮食来维持良好状态。',
      '**总运** 今天需要耐心，不要急躁，保持冷静。\n\n**财运** 可能会有意外收入的机会出现。\n\n**爱情运** 坦诚的交流会让关系更加深厚。\n\n**健康运** 适度运动有助于缓解压力。',
      '**总运** 今天合作与沟通至关重要。\n\n**财运** 专注储蓄比投资更为有利。\n\n**爱情运** 试着从对方的角度思考问题。\n\n**健康运** 避免过度劳累，适当休息。',
    ],
    'zh_TW': [
      '**總運** 今天是新開始的好日子，開始那些一直推遲的事情吧。\n\n**財運** 避免不必要的支出，做好財務規劃。\n\n**愛情運** 主動接近身邊的人會帶來好的結果。\n\n**健康運** 保持充足睡眠和規律飲食來維持良好狀態。',
      '**總運** 今天需要耐心，不要急躁，保持冷靜。\n\n**財運** 可能會有意外收入的機會出現。\n\n**愛情運** 坦誠的交流會讓關係更加深厚。\n\n**健康運** 適度運動有助於緩解壓力。',
      '**總運** 今天合作與溝通至關重要。\n\n**財運** 專注儲蓄比投資更為有利。\n\n**愛情運** 試著從對方的角度思考問題。\n\n**健康運** 避免過度勞累，適當休息。',
    ],
    'vi': [
      '**Tổng vận** Hôm nay là ngày tốt để bắt đầu điều mới. Hãy bắt đầu những việc bạn đã trì hoãn.\n\n**Tài vận** Tránh chi tiêu không cần thiết, hãy lên kế hoạch tài chính cẩn thận.\n\n**Tình duyên** Chủ động tiếp cận người thân sẽ mang lại kết quả tốt.\n\n**Sức khỏe** Duy trì ngủ đủ giấc và ăn uống điều độ.',
      '**Tổng vận** Hôm nay cần kiên nhẫn, hành động bình tĩnh không vội vàng.\n\n**Tài vận** Có thể xuất hiện cơ hội thu nhập bất ngờ.\n\n**Tình duyên** Cuộc trò chuyện thẳng thắn sẽ làm sâu sắc thêm mối quan hệ.\n\n**Sức khỏe** Tập thể dục nhẹ giúp giải tỏa căng thẳng.',
      '**Tổng vận** Hợp tác và giao tiếp rất quan trọng hôm nay.\n\n**Tài vận** Tập trung tiết kiệm hơn là đầu tư.\n\n**Tình duyên** Hãy thử nhìn mọi thứ từ góc độ của đối phương.\n\n**Sức khỏe** Tránh làm việc quá sức và nghỉ ngơi hợp lý.',
    ],
    'id': [
      '**Keberuntungan Umum** Hari yang baik untuk memulai hal baru. Mulailah hal yang telah Anda tunda.\n\n**Keberuntungan Finansial** Hindari pengeluaran yang tidak perlu.\n\n**Keberuntungan Cinta** Mengambil inisiatif mendekati orang terdekat akan membawa hasil baik.\n\n**Kesehatan** Jaga kondisi dengan tidur cukup dan makan teratur.',
      '**Keberuntungan Umum** Kesabaran adalah kunci hari ini. Bertindaklah dengan tenang.\n\n**Keberuntungan Finansial** Peluang pendapatan tak terduga mungkin muncul.\n\n**Keberuntungan Cinta** Percakapan jujur akan mempererat hubungan Anda.\n\n**Kesehatan** Olahraga ringan membantu mengurangi stres.',
      '**Keberuntungan Umum** Kerjasama dan komunikasi sangat penting hari ini.\n\n**Keberuntungan Finansial** Fokus menabung lebih menguntungkan dari berinvestasi.\n\n**Keberuntungan Cinta** Cobalah melihat sesuatu dari sudut pandang pasangan Anda.\n\n**Kesehatan** Hindari kerja berlebihan dan istirahat yang cukup.',
    ],
    'ms': [
      '**Nasib Umum** Hari yang baik untuk permulaan baru. Mulakan perkara yang telah ditangguhkan.\n\n**Nasib Kewangan** Elakkan perbelanjaan yang tidak perlu.\n\n**Nasib Cinta** Mengambil langkah pertama mendekati orang terdekat akan membawa hasil baik.\n\n**Kesihatan** Jaga kondisi dengan tidur cukup dan makan secara teratur.',
      '**Nasib Umum** Kesabaran adalah kunci hari ini. Bertindaklah dengan tenang.\n\n**Nasib Kewangan** Peluang pendapatan tidak dijangka mungkin muncul.\n\n**Nasib Cinta** Perbualan yang jujur akan mengeratkan hubungan anda.\n\n**Kesihatan** Senaman ringan membantu melegakan tekanan.',
      '**Nasib Umum** Kerjasama dan komunikasi amat penting hari ini.\n\n**Nasib Kewangan** Fokus menabung lebih menguntungkan berbanding melabur.\n\n**Nasib Cinta** Cuba lihat sesuatu dari perspektif pasangan anda.\n\n**Kesihatan** Elakkan kerja berlebihan dan rehat secukupnya.',
    ],
    'ru': [
      '**Общая удача** Отличный день для нового начала. Начните то, что откладывали.\n\n**Финансы** Избегайте лишних трат, планируйте расходы.\n\n**Любовь** Первый шаг навстречу близкому человеку принесёт хороший результат.\n\n**Здоровье** Поддерживайте форму полноценным сном и регулярным питанием.',
      '**Общая удача** Сегодня важно терпение. Действуйте спокойно, не торопитесь.\n\n**Финансы** Может появиться неожиданная возможность для дохода.\n\n**Любовь** Честный разговор углубит ваши отношения.\n\n**Здоровье** Лёгкие упражнения помогут снять стресс.',
      '**Общая удача** Сотрудничество и общение сегодня особенно важны.\n\n**Финансы** Сосредоточьтесь на сбережениях, а не на инвестициях.\n\n**Любовь** Попробуйте взглянуть на ситуацию глазами партнёра.\n\n**Здоровье** Избегайте переутомления и хорошо отдыхайте.',
    ],
    'tr': [
      '**Genel Şans** Yeni başlangıçlar için harika bir gün. Ertelediğiniz şeylere başlayın.\n\n**Para Şansı** Gereksiz harcamalardan kaçının, finansal plan yapın.\n\n**Aşk Şansı** Yakınlarınıza ilk adımı atmak iyi sonuçlar getirecektir.\n\n**Sağlık** Yeterli uyku ve düzenli öğünlerle kondisyonunuzu koruyun.',
      '**Genel Şans** Bugün sabır anahtar kelime. Acelesiz ve sakin hareket edin.\n\n**Para Şansı** Beklenmedik bir gelir fırsatı çıkabilir.\n\n**Aşk Şansı** Dürüst bir konuşma ilişkinizi derinleştirecektir.\n\n**Sağlık** Hafif egzersiz stresi azaltmaya yardımcı olur.',
      '**Genel Şans** Bugün iş birliği ve iletişim çok önemli.\n\n**Para Şansı** Yatırım yerine tasarrufa odaklanmak daha avantajlı.\n\n**Aşk Şansı** Olaylara partnerinizin bakış açısından görmeye çalışın.\n\n**Sağlık** Aşırı çalışmaktan kaçının ve yeterince dinlenin.',
    ],
  };
}
