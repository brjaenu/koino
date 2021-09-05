import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/repositories.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/widgets/widgets.dart';

import 'cubit/create_prayer_cubit.dart';

class CreatePrayerScreen extends StatelessWidget {
  static const String routeName = '/create-prayer';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CreatePrayerCubit>(
        create: (_) => CreatePrayerCubit(
          prayerRepository: context.read<PrayerRepository>(),
          userBloc: context.read<UserBloc>(),
        ),
        child: CreatePrayerScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _isAnonymousNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<CreatePrayerCubit, CreatePrayerState>(
        listener: (context, state) {
          if (state.status == CreatePrayerStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async => _popRoute(context),
            child: Scaffold(
              appBar: AppBar(
                title: Text('ANLIEGEN ERSTELLEN'),
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
                                hintText: 'TITEL',
                                prefixIcon: Icon(
                                  FontAwesomeIcons.tag,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 20.0,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              focusNode: _titleFocusNode,
                              onChanged: (value) => context
                                  .read<CreatePrayerCubit>()
                                  .titleChanged(value),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a title.';
                                }
                                if (value.toString().length < 3) {
                                  return 'The title must be at least 3 characters long.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25.0),
                            TextFormField(
                              maxLines: 5,
                              minLines: 2,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'BESCHREIBUNG',
                                prefixIcon: Icon(
                                  FontAwesomeIcons.stream,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 20.0,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              focusNode: _descriptionFocusNode,
                              onChanged: (value) => context
                                  .read<CreatePrayerCubit>()
                                  .descriptionChanged(value),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a description.';
                                }
                                if (value.toString().length < 5) {
                                  return 'The description must be at least 5 characters long.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 25.0),
                            CheckboxListTile(
                              title: Text(
                                "Willst du dein Anliegen anonym posten?",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              onChanged: (value) => context
                                  .read<CreatePrayerCubit>()
                                  .isAnonymousChanged(value),
                              value: state.isAnonymous,
                            ),
                            const SizedBox(height: 25.0),
                            ElevatedButton(
                              onPressed: () => _submitForm(
                                  context,
                                  state.status ==
                                      CreatePrayerStatus.submitting),
                              child: Text('ERSTELLEN'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
      final prayer = await context
          .read<CreatePrayerCubit>()
          .createPrayer(authorId: user.id, groupId: user.activeGroup.id);
      if (prayer == null) {
        return;
      }
      _popRoute(context);
    }
  }

  Future<bool> _popRoute(BuildContext context) async {
    context.read<BottomNavBarCubit>().updateNavBarVisibility(isVisible: true);
    Navigator.of(context).pop();
    return Future.value(true);
  }
}
