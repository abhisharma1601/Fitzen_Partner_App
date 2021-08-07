import 'package:admin/loading.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
part 'fitzen_admin_state.dart';

class FitzenAdminCubit extends Cubit<FitzenAdminState> {
  FitzenAdminCubit()
      : super(FitzenAdminState(
            screen: LoadingScreen(),
            img: "https://i.ibb.co/9ngpz6F/add.jpg",
            queslist: <Widget>[],
            coins: 0));

  void changescreen(Widget cscreen) {
    emit(FitzenAdminState(
        screen: cscreen,
        img: state.img,
        queslist: state.queslist,
        coins: state.coins));
  }

  void changeimg(String url) {
    emit(FitzenAdminState(
        screen: state.screen,
        img: url,
        queslist: state.queslist,
        coins: state.coins));
  }

  void changelist(ques) {
    emit(FitzenAdminState(
        screen: state.screen,
        img: state.img,
        queslist: ques,
        coins: state.coins));
  }

  void changecoins(coinss) {
    print(coinss);
    emit(FitzenAdminState(
        screen: state.screen,
        img: state.img,
        queslist: state.queslist,
        coins: coinss));
  }
  
}
