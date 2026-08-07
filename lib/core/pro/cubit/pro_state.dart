import 'package:equatable/equatable.dart';

class ProState extends Equatable {
  final bool isPro;

  const ProState({this.isPro = true});

  ProState copyWith({bool? isPro}) {
    return ProState(isPro: isPro ?? this.isPro);
  }

  @override
  List<Object?> get props => [isPro];
}
