import 'package:cinema_ghar/core/common/widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../config/router/app_route.dart';
import '../../../../../auth/presentation/viewmodel/auth_viewmodel.dart';
import '../../../../../movies/presentation/viewmodel/movie_viewmodel.dart';

class AllMoviesView extends ConsumerStatefulWidget {
  const AllMoviesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllMoviesViewState();
}

class _AllMoviesViewState extends ConsumerState<AllMoviesView> {
  final _gap = const SizedBox(height: 10);

  final _textStle = const TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
  @override
  Widget build(BuildContext context) {
    var movieState = ref.watch(movieViewModelProvider);
    var authState = ref.watch(authViewModelProvider);
    // print('Auth role : ${authState.userEntity!.role}');
    // print('Length of movie list is ${movieState.allMovies.length}}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Movies'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, AppRoute.loginRoute);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            // const Text('All Movies'),
            if (movieState.isLoading) ...{
              const Center(
                child: CircularProgressIndicator(),
              ),
            } else if (movieState.error != null) ...{
              Text(
                'Error: ${movieState.error!}',
                style: const TextStyle(color: Colors.red),
              ),
            } else if (movieState.allMovies.isEmpty) ...{
              const Expanded(
                flex: 3,
                child: Center(
                  child: Text('No Movies Available',
                      style: TextStyle(fontSize: 20)),
                ),
              )
            } else if (movieState.allMovies.isNotEmpty) ...{
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, item) {
                        var movie = movieState.allMovies[item];
                        print('Movie id is : ${movie.id}');
                        String? movieId = movie.id;
                        return Container(
                          // height: 360,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Image(
                                image: NetworkImage(
                                    'https://imgs.search.brave.com/UJJ8hWvCHWXoY22glnKQ-zAo2BpaqI4usicaOvWCr18/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NzFNWDI3N0RhbUwu/anBn'),
                              ),
                              _gap,
                              Text(
                                'Title: ${movie.title}',
                                style: _textStle,
                              ),
                              _gap,
                              Text(
                                'Description: ${movie.description}',
                                style: _textStle.copyWith(fontSize: 15),
                              ),
                              _gap,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Seats: ${movie.seats}',
                                    style: _textStle.copyWith(fontSize: 15),
                                  ),
                                  _gap,
                                  Text(
                                    'Price: 120',
                                    style: _textStle.copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
                              _gap,
                              authState.userEntity!.role == 'admin'
                                  ?SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          confirmationAlert(context, 'Delete', 'Are you sure want to delete ?', () { 

                                            // print('FOr confirmation movie id : $movieId');

                                            ref.watch(movieViewModelProvider.notifier).deleteMovie(movieId!);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              AppRoute.ticketSelectionRoute,
                                              arguments: movie);

                                          // Navigator.pushNamed(
                                          //     context, AppRoute.ticketRoute);
                                        },
                                        child: const Text('Book Now'),
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: movieState.allMovies.length))
            }
          ],
        ),
      ),
    );
  }
}
