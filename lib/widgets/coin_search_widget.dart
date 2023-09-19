import 'package:cryphive/pages/coin_details_page.dart';
import 'package:flutter/material.dart';

class CoinSearchWidget extends StatelessWidget {

  var coin;

  CoinSearchWidget({super.key, this.coin});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (contest) => CoinDetailsPage(coinID: coin.id,)));
        },
        child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(
              color: Colors.white10,
            ),
          ),
          child: ListTile(
            leading: AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                coin.large,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
            title: Text(
              coin.name,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              coin.symbol,
              style: const TextStyle(
                color: Colors.orange,
              ),
            ),
            trailing: Text(
              coin.id,
              style: const TextStyle(
                color: Colors.deepOrange,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
