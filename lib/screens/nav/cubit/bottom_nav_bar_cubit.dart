import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/enums/bottom_nav_item.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit()
      : super(BottomNavBarState(selectedItem: BottomNavItem.agenda));

  void updateSelectedItem(BottomNavItem item) {
    if (item != state.selectedItem) {
      emit(BottomNavBarState(selectedItem: item));
    }
  }
}
