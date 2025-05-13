import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileData extends ProfileEvent {}

class SelectProfile extends ProfileEvent {
  final dynamic imageUrl;

  const SelectProfile(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class GetProfileImage extends ProfileEvent {}
