import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/blocs/prayers/prayer_bloc.dart';
import 'package:koino/models/models.dart';

class PrayerCard extends StatefulWidget {
  PrayerCard({
    Key key,
    @required this.prayer,
  }) : super(key: key);

  final Prayer prayer;

  @override
  _PrayerCardState createState() => _PrayerCardState();
}

class _PrayerCardState extends State<PrayerCard>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;

  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.prayer.title.toUpperCase(),
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                widget.prayer.isAnonymous
                    ? Container()
                    : Text('~' + widget.prayer.username,
                        style: Theme.of(context).textTheme.bodyText1),
                widget.prayer.isAnonymous ? Container() : SizedBox(height: 10),
                Text(
                  widget.prayer.description,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 15,
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                if (!isPlaying) {
                  _pray(context, widget.prayer.id);
                  setState(() {
                    isPlaying = true;
                    _animationController.forward();
                  });
                }

                Future.delayed(const Duration(milliseconds: 2000), () {
                  setState(() {
                    _animationController.reverse();
                    isPlaying = false;
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    isPlaying
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: Theme.of(context).primaryColor,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _pray(BuildContext context, String prayerId) {
    final userId = context.read<UserBloc>().state.user.id;
    context.read<PrayerBloc>()
      ..add(EventPrayForPrayer(prayerId: prayerId, userId: userId));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
