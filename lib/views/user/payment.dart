import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/user_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/user/buses.dart';
import 'package:transpot/views/user/wallet.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  static String routeName = "/payment";

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment>{
  bool paymentSection = false;
  bool addressSection = false;
  bool TotalSection = false;

  late Future futureCart;
  late User u;

  late int total_cost = 0;

  @override
  void initState() {
    u = Provider.of<AuthModel>(context, listen: false).CurrentUser()!;
    futureCart = Provider.of<MainVariables>(context, listen: false).getUserCart(u);
    super.initState();
  }

  late User user;

  @override
  Widget build(BuildContext context) {
    user = context.read<AuthModel>().CurrentUser()!;
    final UserModel u = UserModel(uid: user.uid);
    return Consumer<MainVariables>(builder: (_, gv, __) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Checkout",
            style: TextStyle(
              color: secondaryColor,
              fontSize: 20,
              fontFamily: 'Lato',
            ),
          ),
          backgroundColor: secondaryColorDark,
        ),
        drawer: const AppDrawer(),
        body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: getSuitableScreenWidth(20),
              vertical: getSuitableScreenWidth(30),
            ),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: ListView(
              // shrinkWrap: true,
              children: <Widget>[
                Row(
                  children: [
                    const Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 24,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 25,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                getDivider(),
                InkWell(
                  child: checkoutRow("Payment", paymentSection, false, trailingText: gv.paymentMethod),
                  onTap: () {
                    setState(() {
                      paymentSection = !paymentSection;
                      addressSection = false;
                      TotalSection = false;
                    });
                  },
                ),
                AnimatedSizeAndFade.showHide(
                  fadeInCurve: Curves.easeInOutQuint,
                  fadeOutCurve: Curves.easeInOutQuint,
                  sizeCurve: Curves.easeInOutQuint,
                  show: paymentSection,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              gv.changePaymentMethod("Wallet");
                              paymentSection = !paymentSection;
                            });
                          },
                          child: const ListTile(
                            title: Text("Wallet"),
                            trailing: Icon(Icons.wallet),
                          ),
                        ),
                        const Divider(
                          indent: 17,
                          endIndent: 17,
                          thickness: 1,
                          color: Color(0xFFE2E2E2),
                        ),
                        InkWell(
                          enableFeedback: true,
                          onTap: () {
                            setState(() {
                              gv.changePaymentMethod("Credit/Debit Card");
                              paymentSection = !paymentSection;
                            });
                          },
                          child: const ListTile(
                            title: Text("Credit/Debit Card"),
                            trailing: Icon(Icons.credit_card),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // checkoutRow("Promo Code", trailingText: "Pick Discount"),
                getDivider(),
                InkWell(
                  child: checkoutRow("Total Cost", TotalSection, false,trailingText: "${(gv.total).toString()} EGP"),
                  onTap: () {
                    setState(() {
                      addressSection = false;
                      paymentSection = false;
                      TotalSection = !TotalSection;
                    });
                  },
                ),
                AnimatedSizeAndFade.showHide(
                    fadeInCurve: Curves.easeInOutQuint,
                    fadeOutCurve: Curves.easeInOutQuint,
                    sizeCurve: Curves.easeInOutQuint,
                    show: TotalSection,
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: gv.userCart.length,
                            itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                    '${gv.userCart[index].product}',
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Text("${gv.userCart[index].uid}"),
                                  trailing: Text("${gv.userCart[index].price}  EGP"),
                                )),
                        // const ListTile(
                        //   title: Text("Shipping fees"),
                        //   trailing: Text("40"),
                        // )
                      ],
                    )),
                getDivider(),
                const SizedBox(
                  height: 30,
                ),
                termsAndConditionsAgreement(context),
                Container(
                  margin: const EdgeInsets.only(
                    top: 25,
                  ),
                  child: ElevatedButton(
                          onPressed: () async {onPressedIconWithText(gv,u);},
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                          ),
                          child: const Text("Finish Payment",style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
                        ),
                ),
              ],
            ),
          )
      ),
    );
    });
  }

  Widget getDivider() {
    return const Divider(
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }

  Widget checkoutRow(String label, bool b, bool overflow, {required String trailingText, Widget trailingWidget = const SizedBox()}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF7C7C7C),
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          trailingText == null
              ? trailingWidget
              : overflow
                  ? Expanded(
                      child: Text(
                        trailingText,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Text(
                      trailingText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          const SizedBox(
            width: 20,
          ),
          Icon(
            b ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
            size: 25,
          )
        ],
      ),
    );
  }

  Widget termsAndConditionsAgreement(BuildContext context) {
    return RichText(
      text: const TextSpan(
          text: 'By placing an order you agree to our',
          style: TextStyle(
            color: Color(0xFF7C7C7C),
            fontSize: 14,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
                text: " Terms",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            TextSpan(text: " And"),
            TextSpan(
                text: " Conditions",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ]),
    );
  }

  void onPressedIconWithText(MainVariables gv, UserModel u) async {
      Future.delayed(const Duration(milliseconds: 600), () {
        try {
          if (gv.paymentMethod != "Select Method") {
            List<dynamic> tempCart = [];
            Map map = Map<String, dynamic>();

            for (int i = 0; i < gv.userCart.length; i++) {

              if(gv.userCart[i].product == "Wallet Topup") {
                u.addBalance(gv.userCart[i].price);
              }


              // tempCart.add(map = {
              //   "id": gv.userCart[i].product.id,
              //   "option1": gv.userCart[i].option1,
              //   "quantity": gv.userCart[i].quantity,
              //   "total": gv.userCart[i].quantity * gv.userCart[i].product.price,
              // });
            }
            // String orderID = customAlphabet("0123456789", 18);
            // u.addOrder(orderID, tempCart, gv.paymentMethod, gv.total);
            u.DeleteAttribute("cart");
            gv.resetCart();
            gv.resetPmethod();
            Future.delayed(const Duration(milliseconds: 1250), () {
              Navigator.of(context).pushNamed(Wallet.routeName);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Choose Payment Method"),
              duration: Duration(milliseconds: 3000),
              behavior: SnackBarBehavior.floating,
              backgroundColor: secondaryColorDark,
            ),
          );
          }
        } catch (e) {
          print(e);
        }
      });
  }

}