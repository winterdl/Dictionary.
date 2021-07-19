import 'package:Dictionary/bloc/word_states.dart';
import 'package:Dictionary/model/search_response.dart';
import 'package:Dictionary/service/definition.api.dart';
import 'package:bloc/bloc.dart';
import 'FetchWordEvent.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final DictionaryApi dictionaryApi;

  WordBloc({required this.dictionaryApi}) : super(WordEmpty());

 @override
  Stream<WordState> mapEventToState(WordEvent event) async* {
    if (event is FetchWord) {
      yield WordLoading();
      try {
        final SearchResponse response = await dictionaryApi.search(event.word);
        yield WordLoaded(response: response);
      } catch (exception) {
        yield WordError();
      }
    }
  }
}