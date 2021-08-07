part of 'fitzen_admin_cubit.dart';

class FitzenAdminState {
  FitzenAdminState({this.screen, this.img, this.queslist, this.coins});
  Widget screen;
  String img;
  List<Widget> queslist;
  int coins = 0;
}
