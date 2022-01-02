import 'package:Dictionary/cards/views/empty_view.dart';
import 'package:Dictionary/cards/views/error_view.dart';
import 'package:Dictionary/cards/views/word_info_view.dart';
import 'package:Dictionary/cards/widgets/cardDecoration/indicator_decoration.dart';
import 'package:Dictionary/search/search_bloc/word_search_bloc.dart';
import 'package:Dictionary/search/search_bloc/word_search_states.dart';
import 'package:Dictionary/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<WordSearchBloc>(context),
        builder: (_, WordSearchState state) {
          if (state is WordSearchError) {
            return errorView();
          }
          if (state is WordSearchLoading) {
            return indicatorCircular();
          }
          if (state is WordSearchLoaded) {
            return Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text(
                  state.response.word,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child:
                    wordInfo(state.response, greyLightColor.withOpacity(0.3)),
              ),
            ]);
          }
          return emptyView();
        });
  }
}