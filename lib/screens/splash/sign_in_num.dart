import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/screens/splash/sign_in_num_verify.dart';
import 'package:jungle/services/auth_exception_handler.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignInNum extends StatefulWidget {
  @override
  _SignInNumState createState() => _SignInNumState();
}

class _SignInNumState extends State<SignInNum> {
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

  @override
  Widget build(BuildContext context) {
    authStatus = context.select((AuthenticationService auth) => auth.status);
    if (authStatus != null) {
      isLoading = false;
    }
    return Center(
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's your number?",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Don't worry, this isn't being shared with anyone, and it won't be on your profile.",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 12.5),
                    TextField(
                      style: TextStyle(fontSize: 24),
                      autofocus: true,
                      controller: textController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: authStatus != null
                            ? AuthExceptionHandler.generateExceptionMessage(
                                authStatus)
                            : null,
                        prefix: Text('+1 '),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          textController.text.isEmpty
                              ? validate = false
                              : validate = true;
                        });
                      },
                    ),
                    SizedBox(height: 25),
                    Text(
                      "When submitting your number, a verification code will be sent as a text. Message and data rates may apply.",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: validate
                        ? () {
                            setState(() {
                              isTapped = false;
                              isLoading = true;
                            });
                            context.read<AuthenticationService>().clearStatus();
                            context.read<AuthenticationService>().verifyNumber(
                                number: textController.text.trim(),
                                context: context);
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
                                  ? Text('CONTINUE',
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
