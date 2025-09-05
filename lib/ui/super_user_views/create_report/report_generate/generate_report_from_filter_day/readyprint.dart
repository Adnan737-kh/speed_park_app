import 'package:flutter/material.dart';
import '../../../../../core/model/register_car/car_registration.dart';



  Widget buildPrintablePageDay(List<CarRegistrationModel> dataSet) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text('SPEED PARK LLC', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Valet Parking Management System', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Date From : 03-Jan-24 To : 03-Jan-24', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Site Location : Public Prosecution', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16.0),

          // DataTable
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('S.NO')),
                  DataColumn(label: Text('Ticket No')),
                  DataColumn(label: Text('Make')),
                  DataColumn(label: Text('Registration No')),
                  DataColumn(label: Text('Color')),
                  DataColumn(label: Text('VSA IN')),
                  DataColumn(label: Text('Time IN')),
                  DataColumn(label: Text('Remarks')),
                  DataColumn(label: Text('Total')),
                ],
                rows: dataSet.map((car) {
                  return DataRow(cells: [
                    DataCell(Text((dataSet.indexOf(car) + 1).toString())),
                    DataCell(Text(car.ticket.toString())),
                    DataCell(Text(car.carMade.toString())),
                    DataCell(Text(car.plateNumber.toString())),
                    DataCell(Text(car.color.toString())),
                    DataCell(Text(car.driverName.toString())),
                    DataCell(Text(car.time.toString())),
                    DataCell(Text(car.selectLocation.toString())),
                    DataCell(Text(car.amount.toString())),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }




