import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:monitorlibrary/functions.dart';

class CreditCardHandlerMobile extends StatefulWidget {
  @override
  _CreditCardHandlerMobileState createState() =>
      _CreditCardHandlerMobileState();
}

class _CreditCardHandlerMobileState extends State<CreditCardHandlerMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Credit Card Handling'),
          bottom: PreferredSize(
            child: Column(),
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
                    showBackView: isCvvFocused),
                Expanded(
                  child: SingleChildScrollView(
                    child: CreditCardForm(
                        key: _formKey, onCreditCardModelChange: _onChange),
                  ),
                ),
              ],
            ),
            showSubmit
                ? Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      child: Card(
                        elevation: 8,
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0, right: 24, top: 12, bottom: 12),
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
    pp('😡 😡 😡 Credit Card Details changed ${creditCardModel.toString()}');
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
    pp('😡 😡 😡 Credit Card about to be submitted ');
  }
}
