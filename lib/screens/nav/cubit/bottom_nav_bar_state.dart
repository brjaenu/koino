part of 'bottom_nav_bar_cubit.dart';

class BottomNavBarState extends Equatable {
  final BottomNavItem selectedItem;
  final bool isVisible;

  BottomNavBarState({
    @required this.selectedItem,
    @required this.isVisible,
  });

  @override
  List<Object> get props => [selectedItem, isVisible];
}
