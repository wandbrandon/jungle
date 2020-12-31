import 'package:flutter/material.dart';
import 'package:jungle/main.dart';
import 'package:jungle/services/auth_exception_handler.dart';
import 'package:provider/provider.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:pinput/pin_put/pin_put.dart';

class SignInNumVerify extends StatefulWidget {
  final String number;
  final String vid;
  final int resendToken;

  const SignInNumVerify({Key key, this.number, this.vid, this.resendToken})
      : super(key: key);

  @override
  _SignInNumVerifyState createState() => _SignInNumVerifyState();
}

class _SignInNumVerifyState extends State<SignInNumVerify> {
  TextEditingController textController = TextEditingController();
  AuthResultStatus authStatus;
  bool isLoading = false;
  bool validate = false;
  bool isTapped = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final tempStatus = await context
        .read<AuthenticationService>()
        .signInWithPhoneCred(
            smsCode: textController.text.trim(), verificationId: widget.vid);
    print(tempStatus.toString());
    if (tempStatus == AuthResultStatus.successful) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthenticationWrapper()));
    } else {
      setState(() {
        authStatus = tempStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: Container(
            padding: EdgeInsets.all(35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verify your number",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 25),
                    Text('Enter the code that we sent to'),
                    SizedBox(height: 6.25),
                    Text(
                      '+1 ${widget.number}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25),
                    PinPut(
                      onChanged: (value) {
                        if (value.length == 6) {
                          setState(() {
                            validate = true;
                          });
                        } else {
                          setState(() {
                            validate = false;
                          });
                        }
                      },
                      inputDecoration: InputDecoration(
                          counterText: '',
                          errorText: authStatus != null
                              ? AuthExceptionHandler.generateExceptionMessage(
                                  authStatus)
                              : null),
                      controller: textController,
                      pinAnimationType: PinAnimationType.scale,
                      eachFieldHeight: MediaQuery.of(context).size.height * .06,
                      textStyle:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      autofocus: true,
                      animationCurve: Curves.easeIn,
                      fieldsCount: 6,
                      submittedFieldDecoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      followingFieldDecoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      selectedFieldDecoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: 25),
                  ],
                ),
                GestureDetector(
                    onTap: validate
                        ? () {
                            setState(() {
                              isTapped = false;
                              isLoading = true;
                            });
                            login();
                          }
                        : null,
                    onTapCancel: validate
                        ? () {
                            setState(() {
                              isTapped = false;
                            });
                          }
                        : null,
                    onTapDown: validate
                        ? (details) {
                            setState(() {
                              isTapped = true;
                            });
                          }
                        : null,
                    child: Transform.scale(
                      alignment: Alignment.center,
                      scale: isTapped ? .93 : 1,
                      child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          height: MediaQuery.of(context).size.height * .065,
                          decoration: BoxDecoration(
                            color: !validate
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                              child: !isLoading
                                  ? Text('SIGN IN',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))
                                  : SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor,
                                      )),
                                    ))),
                    ))
              ],
            )),
      ),
    );
  }
}
