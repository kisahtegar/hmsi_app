import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/informasi/informasi_entity.dart';
import '../../../domain/usecases/informasi/fetch_informasi_usecase.dart';

part 'informasi_state.dart';

class InformasiCubit extends Cubit<InformasiState> {
  final FetchInformasiUsecase fetchInformasiUsecase;

  InformasiCubit({
    required this.fetchInformasiUsecase,
  }) : super(InformasiInitial());

  Future<void> fetchInformasi(
      {required InformasiEntity informasiEntity}) async {
    emit(InformasiLoading());
    try {
      final response = await fetchInformasiUsecase.call(informasiEntity);
      emit(InformasiLoaded(informasi: response));
    } on SocketException catch (_) {
      emit(InformasiFailure());
    } catch (_) {
      emit(InformasiFailure());
    }
  }
}
