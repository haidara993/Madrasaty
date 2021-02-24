import 'package:flutter/material.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;
  final String buttonHeroTag;

  TopBar(
      {@required this.title,
      @required this.child,
      @required this.onPressed,
      this.buttonHeroTag = 'topBarBtn',
      this.onTitleTapped})
      : preferredSize = Size.fromHeight(60.0);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  // TODO: implement preferredSize
  final Size preferredSize;
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              transitionOnUserGestures: true,
              tag: widget.buttonHeroTag,
              child: Container(
                child: MaterialButton(
                  height: 50,
                  minWidth: 50,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                    ),
                  ),
                  onPressed: widget.onPressed,
                  child: widget.child,
                ),
              ),
            ),
            Hero(
              tag: 'title',
              transitionOnUserGestures: true,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(5)),
                ),
                child: InkWell(
                  onTap: widget.onTitleTapped,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 50,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}
