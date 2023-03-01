part of 'informasi_cubit.dart';

abstract class InformasiState extends Equatable {
  const InformasiState();

  @override
  List<Object> get props => [];
}

class InformasiInitial extends InformasiState {}

class InformasiLoading extends InformasiState {}

class InformasiLoaded extends InformasiState {
  final List<InformasiEntity> informasi;

  const InformasiLoaded({required this.informasi});

  @override
  List<Object> get props => [informasi];
}

class InformasiFailure extends InformasiState {}
