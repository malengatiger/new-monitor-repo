import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';

class CreditCardHandlerMobile extends StatefulWidget {
  final User user;

  const CreditCardHandlerMobile({Key? key, required this.user}) : super(key: key);
  @override
  _CreditCardHandlerMobileState createState() =>
      _CreditCardHandlerMobileState();
}

class _CreditCardHandlerMobileState extends State<CreditCardHandlerMobile>
    with SingleTickerProviderStateMixin
    implements SnackBarListener {
  late AnimationController _controller;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  var _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    cardHolderName = widget.user.name!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Service Subscription',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            child: Column(
              children: [
                Text(
                  '${widget.user.organizationName}',
                  style: Styles.whiteSmall,
                ),
                SizedBox(
                  height: 8,
                )
              ],
            ),
            preferredSize: Size.fromHeight(20),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                CreditCardWidget(
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    textStyle: Styles.whiteSmall,
                    cardBgColor: Theme.of(context).primaryColor,
                    showBackView: isCvvFocused),
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: CreditCardForm(
                //         key: _formKey, onCreditCardModelChange: _onChange),
                //   ),
                // ),
              ],
            ),
            showSubmit
                ? Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      child: Card(
                        elevation: 8,
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 32, right: 32, top: 12, bottom: 12),
                            child: Text(
                              'Submit Card',
                              style: Styles.whiteSmall,
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  var _formKey = GlobalKey<FormState>();
  bool showSubmit = false;
  void _onChange(CreditCardModel creditCardModel) {
    pp('😡 😡 😡 Credit Card Details changed '
        'cardHolderName: ${creditCardModel.cardHolderName} 💙 cardNumber: ${creditCardModel.cardNumber} '
        ' 💙 expiryDate: ${creditCardModel.expiryDate} 💙 cvv: ${creditCardModel.cvvCode}');
    int cnt = 0;
    if (creditCardModel.cardNumber.isNotEmpty) {
      cnt++;
    }
    if (creditCardModel.cardHolderName.isNotEmpty) {
      cnt++;
    }
    if (creditCardModel.cvvCode.isNotEmpty) {
      cnt++;
    }
    if (creditCardModel.expiryDate.isNotEmpty) {
      cnt++;
    }
    if (cnt == 4) {
      showSubmit = true;
    } else {
      showSubmit = false;
    }

    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void _submit() {
    pp('😡 😡 😡 Credit Card about to be submitted here 💙 💙 💙 💙 💙');
    AppSnackbar.showSnackbarWithAction(
        scaffoldKey: _key,
        message: 'Payment made',
        textColor: Colors.white,
        backgroundColor: Colors.teal[600]!,
        listener: this,
        actionLabel: 'Close');
  }

  @override
  onActionPressed(int action) {
    Navigator.pop(context);
  }
}
