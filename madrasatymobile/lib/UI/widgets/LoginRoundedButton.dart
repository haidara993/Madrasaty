import 'package:flutter/material.dart';

class LoginRoundedButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final String heroTag;
  const LoginRoundedButton({this.onPressed, this.label, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Hero(
        tag: heroTag ?? 'login',
        transitionOnUserGestures: true,
        child: Card(
          color: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
          ),
          child: MaterialButton(
            height: 50,
            // minWidth: 300,
            // elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
            ),
            onPressed: onPressed,
            child: Text(
              label ?? 'Login',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
