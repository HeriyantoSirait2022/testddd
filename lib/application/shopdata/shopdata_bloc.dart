import 'dart:async';

import 'package:testddd/domain/i_shopdata_repository.dart';
import 'package:testddd/infrastructure/shopdata/data_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'shopdata_event.dart';
part 'shopdata_state.dart';
part 'shopdata_bloc.freezed.dart';

@injectable
class ShopdataBloc extends Bloc<ShopdataEvent, ShopdataState> {
  final IshopDataRepository _ishopDataRepository;

  ShopdataBloc(this._ishopDataRepository)
      : super(const ShopdataState.initial());

  @override
  Stream<ShopdataState> mapEventToState(
    ShopdataEvent event,
  ) async* {
    yield* event.map(
      watchAllProducts: (e) async* {
        yield const ShopdataState.loadInProgress();
        List<Datum> shopdata = await _ishopDataRepository.watchAllProducts();

        try {
          yield ShopdataState.loadSuccess(shopdata);
        } catch (e) {
          yield ShopdataState.loadFailure();
        }
      },
    );
  }
}
