import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weathers = [];
  bool _isLoading = true;
  String? _errorMessage;

  void _getWeatherData() async {
    try {
      print("VERİ ÇEKİLİYOR...");
      _weathers = await WeatherService().getWeatherData();
      print("VERİ BAŞARIYLA ÇEKİLDİ: ${_weathers.length} adet");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("HOME PAGE HATA: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hava Durumu")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Hata Oluştu",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });
                        _getWeatherData();
                      },
                      child: const Text("Tekrar Dene"),
                    ),
                  ],
                ),
              ),
            )
          : _weathers.isEmpty
          ? const Center(child: Text("Veri bulunamadı"))
          : ListView.builder(
              itemCount: _weathers.length,
              itemBuilder: (context, index) {
                final WeatherModel weather = _weathers[index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.network(weather.ikon, width: 100),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(
                          "${weather.gun}\n ${weather.durum.toUpperCase()} ${weather.derece}°",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Min: ${weather.min} °"),
                              Text("Max: ${weather.max} °"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Gece: ${weather.gece} °"),
                              Text("Nem: ${weather.nem}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
