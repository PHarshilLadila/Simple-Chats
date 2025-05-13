import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';

abstract class ContactState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<Contact> contacts;
  ContactLoaded(this.contacts);
  @override
  List<Object?> get props => [contacts];
}

class ContactError extends ContactState {
  final String error;
  ContactError(this.error);
  @override
  List<Object> get props => [error];
}
