import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/group/group_repository.dart';
import 'package:koino/screens/create_group/cubit/create_group_cubit.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/widgets/widgets.dart';

class CreateGroupScreen extends StatelessWidget {
  static const String routeName = '/create-group';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CreateGroupCubit>(
        create: (_) => CreateGroupCubit(
          groupRepository: context.read<GroupRepository>(),
        ),
        child: CreateGroupScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _activationCodeFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<CreateGroupCubit, CreateGroupState>(
        listener: (context, state) {
          if (state.status == CreateGroupStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('GRUPPE ERSTELLEN'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 25.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'GRUPPENNAME',
                              prefixIcon: Icon(
                                FontAwesomeIcons.userFriends,
                                color: Theme.of(context).iconTheme.color,
                                size: 20.0,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            focusNode: _nameFocusNode,
                            onChanged: (value) => context
                                .read<CreateGroupCubit>()
                                .nameChanged(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a name.';
                              }
                              if (value.toString().length < 4) {
                                return 'The name must be at least 4 characters long.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'AKTIVIERUNGSCODE',
                              prefixIcon: Icon(
                                FontAwesomeIcons.lock,
                                color: Theme.of(context).iconTheme.color,
                                size: 20.0,
                              ),
                            ),
                            onChanged: (value) => context
                                .read<CreateGroupCubit>()
                                .activationCodeChanged(value),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            focusNode: _activationCodeFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an activationCode.';
                              }
                              if (value.toString().length < 8) {
                                return 'The code must be at least 8 characters long.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25.0),
                          ElevatedButton(
                            onPressed: () => _submitForm(context,
                                state.status == CreateGroupStatus.submitting),
                            child: Text('ERSTELLEN'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _submitForm(BuildContext context, bool isSubmitting) async {
    final User user = context.read<UserBloc>().state.user;

    if (_formKey.currentState.validate() && !isSubmitting) {
      final group =
          await context.read<CreateGroupCubit>().createGroup(ownerId: user.id);
      if (group == null) {
        return;
      }
      context.read<UserBloc>().add(UserUpdateActiveGroup(group: group));
      context.read<BottomNavBarCubit>().updateNavBarVisibility(isVisible: true);
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
    }
  }
}
