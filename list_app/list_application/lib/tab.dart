import 'package:flutter/material.dart';

void main() {}
List<Car> _carsList = [
  Car(name: 'Car A', driverName: 'Driver A', hired: false),
  Car(name: 'Car B', driverName: 'Driver B', hired: false),
  Car(name: 'Car C', driverName: 'Driver C', hired: true)
];
List<Bike> _bikeList = [
  Bike(name: 'Bike A', driverName: '', hired: false),
  Bike(name: 'Bike B', driverName: '', hired: false),
  Bike(name: 'Bike C', driverName: '', hired: false)
];
List<Bus> _busList = [
  Bus(name: 'Bus A', driverName: 'Bus Driver A'),
  Bus(name: 'Bus B', driverName: 'Bus Driver B'),
  Bus(name: 'Bus C', driverName: 'Bus Driver C')
];

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.directions_car),
                ),
                Tab(
                  icon: Icon(Icons.directions_bike),
                ),
                Tab(
                  icon: Icon(Icons.directions_bus),
                ),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              _buildVehicleList(_carsList),
              _buildVehicleList(_bikeList),
              _buildVehicleList(_busList)
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildVehicleList(List<Vehicle> vehicles) {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: vehicles.length,
    itemBuilder: (context, index) {
      return _buildList(context: context, vehicle: vehicles[index]);
    },
  );
}

Widget _buildList({required BuildContext context, required Vehicle vehicle}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VehicleDetailView(vehicle: vehicle),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightGreen),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(vehicle.name),
              Text(vehicle.type),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetailView(vehicle: vehicle),
                  ),
                );
              },
              child: const Icon(Icons.call_made)),
        ],
      ),
    ),
  );
}

abstract class Vehicle {
  final String name;
  final String type;
  final String? driverName;
  final bool? hired;

  Vehicle(
      {required this.name, required this.type, this.driverName, this.hired});
}

class Car extends Vehicle {
  Car(
      {required super.name,
      super.type = 'Car',
      required super.driverName,
      required super.hired});
}

class Bike extends Vehicle {
  Bike(
      {required super.name,
      super.type = 'Bike',
      super.driverName,
      required super.hired});
}

class Bus extends Vehicle {
  Bus({required super.name, super.type = 'Bus', required super.driverName});
}

class VehicleDetailView extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailView({super.key, required this.vehicle});
  @override
  Widget build(BuildContext context) {
    bool canBeHired = false;
    String driverName;
    if (vehicle is Car) {
      driverName = (vehicle as Car).driverName ?? 'Unknown';
      canBeHired = !(vehicle as Car).hired!;
    } else if (vehicle is Bus) {
      driverName = (vehicle as Bus).driverName ?? 'Unknown';
    } else {
      driverName = 'N/A';
      canBeHired = !(vehicle as Bike).hired!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Detail View - ${vehicle.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${vehicle.name}',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${vehicle.type}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (vehicle is Car || vehicle is Bus)
              Text(
                'Driver Name: $driverName',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16),
            if (canBeHired)
              ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                            content:
                                Text('Hired this vehicle: ${vehicle.name}')),
                      );
                  },
                  child: const Text('Hire this vehicle')),
          ],
        ),
      ),
    );
  }
}
