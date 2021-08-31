import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/groups/cubit/join_group_cubit.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/widgets/widgets.dart';

class JoinGroupSheet extends StatelessWidget {
  final GlobalKey<FormState> _formKey;

  JoinGroupSheet({
    Key key,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final _nameFocusNode = FocusNode();
  final _activationCodeFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinGroupCubit, JoinGroupState>(
      listener: (context, state) {
        if (state.status == JoinGroupStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            child: Wrap(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 12, 25, 25),
                    child: Form(
                      key: this._formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Center(
                                child: Text(
                              'GRUPPE HINZUFÜGEN',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(fontWeight: FontWeight.normal),
                            )),
                            leading: Text(''),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            trailing: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.close)),
                            ),
                          ),
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
                                .read<JoinGroupCubit>()
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
                                .read<JoinGroupCubit>()
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
                                state.status == JoinGroupStatus.submitting),
                            child: Text('HINZUFÜGEN'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _submitForm(BuildContext context, bool isSubmitting) async {
    final User user = context.read<UserBloc>().state.user;

    if (_formKey.currentState.validate() && !isSubmitting) {
      final group =
          await context.read<JoinGroupCubit>().joinGroup(userId: user.id);
      if (group == null) {
        return;
      }
      context.read<UserBloc>().add(UserUpdateActiveGroup(group: group));
      context.read<BottomNavBarCubit>().updateNavBarVisibility(isVisible: true);
      //Navigator.of(context).pop();
      //Navigator.of(context).pop();
    }
  }
}
