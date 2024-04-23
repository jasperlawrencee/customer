import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:customer/components/background.dart';
import 'package:customer/components/constants.dart';
import 'package:customer/components/widgets.dart';
import 'package:customer/screens/Homescreen/booking_transcations.dart';
import 'package:customer/screens/Rating/rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// final db = FirebaseFirestore.instance;

class TransactionHistory extends StatefulWidget {
  Transactions transactions;

  TransactionHistory({
    super.key,
    required this.transactions,
  });

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  // Future<bool> ratingIsExisting = false as Future<bool>;
  Future<bool> doesSubcollectionExist() async {
    //if rating doc exists on customer
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('bookings')
            .doc(widget.transactions.reference)
            .collection('ratings')
            .doc('rating')
            .get();
    print(documentSnapshot);
    return documentSnapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: Container(
        margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('ref: ${widget.transactions.reference}'),
            const SizedBox(height: defaultPadding),
            bookingCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Billing Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: defaultPadding),
                RowDetails([
                  const Text('Payment Method'),
                  Text(widget.transactions.paymentMethod),
                ]),
                RowDetails([
                  const Text('Total'),
                  Text('PHP ${widget.transactions.total}')
                ]),
                const Divider(),
                RowDetails([
                  const Text('Serivce Fee'),
                  Text('PHP ${widget.transactions.serviceFee}'),
                ]),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.transactions.services.length,
                  itemBuilder: (context, index) {
                    return RowDetails([
                      Text(
                          '${widget.transactions.services[index]['serviceName']}'),
                      Text(
                          'PHP ${widget.transactions.services[index]['price'].toStringAsFixed(2)}'),
                    ]);
                  },
                ),
              ],
            )),
            const SizedBox(height: defaultPadding),
            bookingCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appointment Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: defaultPadding),
                const Text('Time & Date'),
                Text(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    '${DateFormat.jm().format(widget.transactions.dateFrom)} - ${DateFormat.jm().format(widget.transactions.dateTo)} | ${DateFormat('MMMMd').format(widget.transactions.dateTo)}'),
                const SizedBox(height: defaultPadding),
                const Text('Address'),
                Text(widget.transactions.location,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
// <<<<<<< master
//                 const SizedBox(height: defaultPadding),
//                 transactions.preferredWorker != null
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// =======
                widget.transactions.preferredWorker != null
                    ? Column(
                        children: [
                          const Text('Preferred Stylist'),
// <<<<<<< master
//                           Text(
//                             transactions.preferredWorker!,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           )
// =======
                          Text(widget.transactions.preferredWorker!)
                        ],
                      )
                    : Container()
              ],
            )),
            const SizedBox(height: defaultPadding),
            bookingCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Booking Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: defaultPadding),
                RowDetails([
                  const Text('Booked Provider'),
// <<<<<<< master
//                   const Spacer(),
//                   Flexible(
//                     child: Text(
//                       overflow: TextOverflow.ellipsis,
//                       transactions.clientID,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
// =======
                  Text(
                    widget.transactions.clientID,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ]),
                RowDetails([
                  const Text('Status'),
                  Text(
                    widget.transactions.status.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ]),
                if (widget.transactions.status == 'denied' &&
                    widget.transactions.reason != null)
                  RowDetails([
                    const Text('Reason'),
                    Text(widget.transactions.reason!),
                  ]),
                const SizedBox(height: defaultPadding),
                FutureBuilder<bool>(
                    future: doesSubcollectionExist(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text(
                            'loading Review button...',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: grayText,
                                fontSize: 12),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final hasRating = snapshot.data!;

                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                hasRating ? 'RATING DONE' : 'NO RATING YET',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: hasRating
                                        ? Colors.green[800]
                                        : Colors.red[800]),
                              ),
                              hasRating
                                  ? Text('')
                                  : TextButton(
                                      onPressed: () {
                                        // print(widget.transactions.reference);
                                        print(hasRating.toString());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Rating(
                                                      // transactions:
                                                      // widget.transactions,
                                                      reference: widget
                                                          .transactions
                                                          .reference,
                                                      clientId: widget
                                                          .transactions
                                                          .clientId,
                                                    )));
                                      },
                                      child: Text(
                                        'Leave a rating',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ))
                            ]);
                      }
                    })
              ],
            ))
          ],
        ),
      )),
    );
  }
}
