import 'package:money_formatter/money_formatter.dart';

String moneyFormat(double amount){
 MoneyFormatter formatter = MoneyFormatter(amount:amount );
 return formatter.output.nonSymbol.replaceAll(".00", " ");
}