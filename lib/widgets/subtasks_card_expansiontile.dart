import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/features/presentation/pages/tasks/components/members.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SubTasksCard extends StatefulWidget {
  SubTasksCard(
      {this.procentCount = 0,
      this.elevation = 4,
      required this.titleSubtask,
      Key? key})
      : super(key: key);
  final String titleSubtask;
  final int procentCount;
  final double elevation;

  @override
  _SubTasksCardState createState() => _SubTasksCardState();
}

class _SubTasksCardState extends State<SubTasksCard>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  List subTasks = [];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    animation = Tween<double>(begin: 0, end: 1.6).animate(controller);
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isCheck = false;
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 10),
      elevation: widget.elevation,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        trailing: Container(
            child: AnimatedBuilder(
          animation: animation,
          child: SvgPicture.asset('assets/icons_svg/next.svg'),
          builder: (BuildContext context, Widget? child) => Transform.rotate(
            angle: animation.value,
            child: child,
          ),
        )),
        onExpansionChanged: (vue) {
          if (vue) {
            controller.forward();
          } else {
            controller.reverse();
          }
        },
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  isCheck = !isCheck;
                });
              },

              /*** CHECKBOX Container green/grey border ***/

              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  // color: Colors.green,
                  border: Border.all(
                      color: isCheck
                          ? Color.fromARGB(255, 97, 200, 119)
                          : Color.fromARGB(255, 197, 196, 196),
                      width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                alignment: Alignment.center,
                child: isCheck
                    ? Icon(Icons.check,
                        size: 12, color: Color.fromARGB(255, 97, 200, 119))
                    : null,
              ),
            ),
            SizedBox(
              width: 9,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.titleSubtask,
                      style: isCheck
                          ? TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Color.fromARGB(
                                255,
                                202,
                                205,
                                210,
                              ),
                            )
                          : null),
                  SizedBox(height: 10),

                  /**** Progress bar  ****/

                  Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(60)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearPercentIndicator(
                          animation: true,
                          padding: EdgeInsets.all(0),
                          width: 158,
                          lineHeight: 6,
                          percent: 0.1 * widget.procentCount,
                          backgroundColor: Color.fromARGB(
                            255,
                            245,
                            246,
                            251,
                          ),
                          progressColor: widget.procentCount == 10
                              ? Color.fromARGB(255, 97, 200, 119)
                              : Color.fromARGB(
                                  255,
                                  255,
                                  206,
                                  147,
                                ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            ),

            /**Members container **/

            Container(
              // color: Colors.orange,
              width: 69,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                      child: Members(
                          imgSize: 37,
                          memberImagePath: 'assets/png/avatar.png')),
                  Positioned(
                    left: 30,
                    child: Members(
                      imgSize: 37,
                      memberImagePath: 'assets/png/img.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          SubtasksCheck(
            titleSubtask: 'UX исследование',
            isCheck: true,
          ),
          SubtasksCheck(
            titleSubtask: 'UX исследование',
            isCheck: true,
          ),
        ],
      ),
    );
  }
}

class SubtasksCheck extends StatefulWidget {
  SubtasksCheck({required this.titleSubtask, Key? key, required this.isCheck})
      : super(key: key);
  final String titleSubtask;
  bool isCheck;

  @override
  _SubtasksCheckState createState() => _SubtasksCheckState();
}

class _SubtasksCheckState extends State<SubtasksCheck> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(
                () {
                  widget.isCheck = !widget.isCheck;
                },
              );
            },
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                // color: Colors.green,
                border: Border.all(
                    color: widget.isCheck
                        ? Color.fromARGB(255, 97, 200, 119)
                        : (Color.fromARGB(255, 197, 196, 196)),
                    width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              alignment: Alignment.center,
              child: widget.isCheck
                  ? Icon(Icons.check,
                      size: 12, color: Color.fromARGB(255, 97, 200, 119))
                  : null,
            ),
          ),
          SizedBox(
            width: 9,
          ),
          Text(
            widget.titleSubtask,
            style: widget.isCheck
                ? TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Color.fromARGB(
                      255,
                      202,
                      205,
                      210,
                    ))
                : null,
          ),
        ],
      ),
    );
  }
}
