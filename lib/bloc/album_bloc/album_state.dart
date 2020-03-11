import 'package:equatable/equatable.dart';

import '../../data/model/album.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();
}

class AlbumInitial extends AlbumState {
  const AlbumInitial();
  
  @override
  List<Object> get props => [];
}

class AlbumLoadInProgress extends AlbumState {
  const AlbumLoadInProgress();
  
  @override
  List<Object> get props => [];
}

class AlbumsLoadSuccess extends AlbumState {
  final List<Album> albums;
  const AlbumsLoadSuccess(this.albums);
  
  @override
  List<Object> get props => [albums];
}

class AlbumLoadSuccess extends AlbumState {
  final Album album;
  const AlbumLoadSuccess(this.album);
  
  @override
  List<Object> get props => [album];
}

class AlbumError extends AlbumState {
  final String message;
  const AlbumError(this.message);
  
  @override
  List<Object> get props => [message];
}
