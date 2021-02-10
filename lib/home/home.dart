import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_movieapp/home/movie.dart';
import 'package:flutter_riverpod_movieapp/home/movie_exception.dart';
import 'package:flutter_riverpod_movieapp/home/movie_service.dart';

final moviesFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;

  final movieService = ref.read(movieServiceProvider);
  final movies = await movieService.getMovies();
  return movies;
});

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Movies"),
        ),
        body: watch(moviesFutureProvider).when(
          data: (movies) {
            return RefreshIndicator(
              onRefresh: () {
                return context.refresh(moviesFutureProvider);
              },
              child: GridView.extent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
                children:
                    movies.map((movie) => _MovieBox(movie: movie)).toList(),
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) {
            if (error is MoviesException) {
              return _ErrorBody(message: error.message);
            }
            return _ErrorBody(message: "Something unexpected happen");
          },
        ));
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;

  const _ErrorBody({Key key, @required this.message})
      : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.refresh(moviesFutureProvider),
            child: Text("Try again"),
          )
        ],
      ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final Movie movie;

  const _MovieBox({Key key, this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          child: _FrontBanner(text: movie.title),
          bottom: 0,
          top: 0,
          left: 0,
          right: 0,
        ),
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  const _FrontBanner({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        child: Container(
          // color: Colors.grey.shade200.withOpacity(0.5),
          height: 60,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
