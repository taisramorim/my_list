import 'package:my_list/services/api_repository.dart';

class ApiService {
  final MotivationalQuoteRepository _quoteRepository = MotivationalQuoteRepository();

  Future<String> getMotivationalQuote() async {
    try {
      return await _quoteRepository.fetchQuote();
    } catch (e) {
      return 'Failed to load quote: $e';
    }
  }
}