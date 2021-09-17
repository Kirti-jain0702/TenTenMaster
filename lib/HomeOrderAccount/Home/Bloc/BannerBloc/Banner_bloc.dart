import 'package:delivoo/HomeOrderAccount/HomeRepository/home_repository.dart';
import 'package:delivoo/JsonFiles/Banner/Banner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Banner_event.dart';
import 'Banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  HomeRepository _repository = HomeRepository();

  BannerBloc() : super(LoadingBannerState());

  @override
  Stream<BannerState> mapEventToState(BannerEvent event) async* {
    if (event is FetchBannerEvent) {
      yield* _mapFetchBannerToState();
    }
  }

  Stream<BannerState> _mapFetchBannerToState() async* {
    yield LoadingBannerState();
    try {
      BannerData listBanners = await _repository.getBanners();
      yield SuccessBannerState(listBanners);
    } catch (e) {
      yield FailureBannerState(e);
    }
  }
}
