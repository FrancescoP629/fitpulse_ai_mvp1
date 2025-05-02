// /home/ubuntu/fitpulse_ai/mobile/lib/services/sensor_service.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  StreamSubscription? _accelerometerSubscription;
  AccelerometerEvent? lastAccelerometerEvent;

  // Stream controller per notificare i cambiamenti dell'accelerometro
  final _accelerometerController = StreamController<AccelerometerEvent>.broadcast();
  Stream<AccelerometerEvent> get accelerometerStream => _accelerometerController.stream;

  void startListening() {
    if (_accelerometerSubscription != null) return; // Già in ascolto

    _accelerometerSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        lastAccelerometerEvent = event;
        // Notifica gli ascoltatori del nuovo evento
        if (!_accelerometerController.isClosed) {
           _accelerometerController.add(event);
        }
        // Stampa i valori per debug (opzionale)
        // print('Accelerometer: x=${event.x.toStringAsFixed(2)}, y=${event.y.toStringAsFixed(2)}, z=${event.z.toStringAsFixed(2)}');
      },
      onError: (error) {
        print('Errore sensore accelerometro: $error');
        stopListening();
      },
      cancelOnError: true,
    );
    print("Avviato ascolto accelerometro.");
  }

  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    print("Interrotto ascolto accelerometro.");
  }

  void dispose() {
    stopListening();
    _accelerometerController.close();
    print("SensorService disposed.");
  }
}

// Esempio di Widget che usa il SensorService (potrebbe essere messo in un file separato)

class AccelerometerDisplay extends StatefulWidget {
  final SensorService sensorService;

  const AccelerometerDisplay({required this.sensorService, Key? key}) : super(key: key);

  @override
  _AccelerometerDisplayState createState() => _AccelerometerDisplayState();
}

class _AccelerometerDisplayState extends State<AccelerometerDisplay> {
  AccelerometerEvent? _event;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    // Ascolta lo stream dal service
    _subscription = widget.sensorService.accelerometerStream.listen((event) {
      if (mounted) { // Controlla se il widget è ancora nell'albero
        setState(() {
          _event = event;
        });
      }
    });
    // Assicurati che il service stia ascoltando
    widget.sensorService.startListening(); 
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancella la sottoscrizione allo stream
    // Non fermare l'ascolto qui, potrebbe servire ad altri widget.
    // Il service gestirà la sua chiusura.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final x = _event?.x.toStringAsFixed(2) ?? 'N/A';
    final y = _event?.y.toStringAsFixed(2) ?? 'N/A';
    final z = _event?.z.toStringAsFixed(2) ?? 'N/A';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Accelerometro: X: $x, Y: $y, Z: $z',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

