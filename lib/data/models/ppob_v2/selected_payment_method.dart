import 'package:equatable/equatable.dart';

class SelectedPaymentMethodData extends Equatable {
  final String? id;
  final String? name;
  final String? channel;

  const SelectedPaymentMethodData({this.id, this.name, this.channel});

  @override
  List<Object?> get props => [
    id,
    name,
    channel,
  ];
}
