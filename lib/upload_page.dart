import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:image/image.dart' as img_lib;
import 'package:file_picker/file_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _propertyCodeController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationDetailController = TextEditingController();
  final _priceController = TextEditingController();
  final _priceAreController = TextEditingController();
  final _areaSizeController = TextEditingController();
  final _buildSizeController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _builtYearController = TextEditingController();
  final _parkingSpacesController = TextEditingController();
  final _gpsLocationController = TextEditingController();
  final _locationInputController = TextEditingController();
  final _youtubeLinkController = TextEditingController();
  final _statusJualController = TextEditingController();

  String _propertyType = 'house';
  String _status = 'sale';
  String _statusJual = '0';
  bool _agree = false;

  List<String> _selectedFasilitas = [];
  List<String> _selectedFasilitasUmum = [];

  // Dummy data untuk fasilitas (ganti dengan real jika ada DB)
  final List<String> _fasilitasOptions = ['AC', 'Swimming Pool', 'Gym', 'Parkir', 'WiFi'];
  final List<String> _fasilitasUmumOptions = ['Dekat Sekolah', 'Dekat Rumah Sakit', 'Dekat Mall', 'Transportasi Umum'];

  final List<File> _selectedFiles = [];
  String? _featuredImage;

  final Completer<GoogleMapController> _mapController = Completer();
  Marker? _marker;
  LatLng _currentPosition = LatLng(-7.2574729, 112.7407765); // Default posisi

  @override
  void initState() {
    super.initState();
    _marker = Marker(
      markerId: MarkerId('property_location'),
      position: _currentPosition,
      draggable: true,
      onDragEnd: (newPosition) => _updateLocation(newPosition.latitude, newPosition.longitude),
    );
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'mp4'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.paths.map((path) => File(path!)));
      });
    }
  }

  Future<Uint8List> _addWatermark(File file) async {
    final byteData = await rootBundle.load(file.path); // Salah, gunakan file.readAsBytes
    Uint8List bytes = await file.readAsBytes();
    img_lib.Image image = img_lib.decodeImage(bytes)!;

    // Add watermark
    img_lib.drawString(
      image,
      'iyandana.com',
      font: img_lib.arial24,
      x: image.width ~/ 2 - 100,
      y: image.height ~/ 2,
      color: img_lib.ColorRgba8(255, 255, 255, 180),
    );

    return img_lib.encodePng(image);
  }

  void _removeFile(File file) {
    setState(() {
      _selectedFiles.remove(file);
      if (_featuredImage == file.path) _featuredImage = null;
    });
  }

  Future<void> _geocodeLocation() async {
    String input = _locationInputController.text.trim();
    if (input.isEmpty) return;

    // Handle URL or coords or address
    try {
      List<Location> locations = await locationFromAddress(input); // Forward geocode
      if (locations.isNotEmpty) {
        _updateMapPosition(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lokasi tidak ditemukan')));
    }
  }

  Future<void> _updateLocation(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng); // Reverse geocode
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      _gpsLocationController.text = place.street ?? '';
      // Update hidden fields if needed (kota, provinsi, dll. statis)
    }
    _updateMapPosition(lat, lng);
  }

  void _updateMapPosition(double lat, double lng) {
    setState(() {
      _currentPosition = LatLng(lat, lng);
      _marker = Marker(
        markerId: MarkerId('property_location'),
        position: _currentPosition,
        draggable: true,
        onDragEnd: (newPosition) => _updateLocation(newPosition.latitude, newPosition.longitude),
      );
    });
    _mapController.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 17));
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _agree) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Simpan berhasil (simulasi)')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form tidak lengkap')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Property')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Kode Property & Judul
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _propertyCodeController, decoration: InputDecoration(labelText: 'Kode Property'), validator: (v) => v!.isEmpty ? 'Required' : null)),
                  SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _titleController, decoration: InputDecoration(labelText: 'Judul'), validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              // Deskripsi
              TextFormField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Deskripsi'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
              // Fasilitas
              MultiSelectDialogField(
                items: _fasilitasOptions.map((e) => MultiSelectItem<String>(e, e)).toList(),
                title: Text('Fasilitas Property'),
                onConfirm: (values) => _selectedFasilitas = values,
                buttonText: Text('Pilih Fasilitas'),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
              ),
              // Fasilitas Umum
              MultiSelectDialogField(
                items: _fasilitasUmumOptions.map((e) => MultiSelectItem<String>(e, e)).toList(),
                title: Text('Fasilitas Umum Property'),
                onConfirm: (values) => _selectedFasilitasUmum = values,
                buttonText: Text('Pilih Fasilitas Umum'),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
              ),
              // Tipe & Lokasi Detail
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _propertyType,
                      items: [
                        DropdownMenuItem(value: 'house', child: Text('Rumah')),
                        DropdownMenuItem(value: 'hotel', child: Text('Hotel')),
                        // Tambah lainnya
                      ],
                      onChanged: (v) => setState(() => _propertyType = v!),
                      decoration: InputDecoration(labelText: 'Tipe Property'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _locationDetailController, decoration: InputDecoration(labelText: 'Lokasi Detail'), validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              // Status & Durasi
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      items: [
                        DropdownMenuItem(value: 'sale', child: Text('Dijual')),
                        // Tambah lainnya
                      ],
                      onChanged: (v) => setState(() => _status = v!),
                      decoration: InputDecoration(labelText: 'Status'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _status == 'leashold' || _status == 'rented'
                        ? TextFormField(controller: _statusJualController, decoration: InputDecoration(labelText: 'Durasi'), validator: (v) => v!.isEmpty ? 'Required' : null)
                        : DropdownButtonFormField<String>(
                            value: _statusJual,
                            items: [
                              DropdownMenuItem(value: '0', child: Text('--Durasi Sewa--')),
                              // Tambah lainnya
                            ],
                            onChanged: (v) => setState(() => _statusJual = v!),
                            decoration: InputDecoration(labelText: 'Durasi Sewa'),
                          ),
                  ),
                ],
              ),
              // Harga & Harga per Are
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _priceController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number)),
                  SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _priceAreController, decoration: InputDecoration(labelText: 'Harga per Are'), keyboardType: TextInputType.number)),
                ],
              ),
              // Luas Area & Bangunan
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _areaSizeController, decoration: InputDecoration(labelText: 'Luas Area (m²)'), keyboardType: TextInputType.number)),
                  SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _buildSizeController, decoration: InputDecoration(labelText: 'Luas Bangunan (m²)'), keyboardType: TextInputType.number)),
                ],
              ),
              // Kamar Mandi & Tidur
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _bathroomsController, decoration: InputDecoration(labelText: 'Jumlah Kamar Mandi'), keyboardType: TextInputType.number)),
                  SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _bedroomsController, decoration: InputDecoration(labelText: 'Jumlah Kamar Tidur'), keyboardType: TextInputType.number)),
                ],
              ),
              // Tahun Dibangun & Parkir
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _builtYearController, decoration: InputDecoration(labelText: 'Tahun Dibangun'), keyboardType: TextInputType.number)),
                  SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _parkingSpacesController, decoration: InputDecoration(labelText: 'Jumlah Tempat Parkir'), keyboardType: TextInputType.number)),
                ],
              ),
              // Lokasi GPS
              TextFormField(controller: _gpsLocationController, decoration: InputDecoration(labelText: 'Lokasi GPS'), validator: (v) => v!.isEmpty ? 'Required' : null),
              // Map
              SizedBox(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 17),
                  markers: {_marker!},
                  onMapCreated: (controller) => _mapController.complete(controller),
                  onTap: (pos) => _updateLocation(pos.latitude, pos.longitude), // Single tap untuk place marker (simulasi double click)
                ),
              ),
              TextField(controller: _locationInputController, decoration: InputDecoration(labelText: 'Masukkan lokasi atau link')),
              ElevatedButton(onPressed: _geocodeLocation, child: Text('Cari Lokasi')),
              // Upload Gambar/Video
              ElevatedButton(onPressed: _pickFiles, child: Text('Upload Gambar atau Video')),
              Wrap(
                children: _selectedFiles.map((file) => FutureBuilder<Uint8List>(
                  future: _addWatermark(file),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          Image.memory(snapshot.data!, width: 150, height: 150),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(icon: Icon(Icons.remove_circle), onPressed: () => _removeFile(file)),
                          ),
                          Radio<String>(
                            value: file.path,
                            groupValue: _featuredImage,
                            onChanged: (v) => setState(() => _featuredImage = v),
                          ),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  },
                )).toList(),
              ),
              // YouTube Link
              TextFormField(controller: _youtubeLinkController, decoration: InputDecoration(labelText: 'Link YouTube Long')),
              // Checkbox Agree
              CheckboxListTile(
                value: _agree,
                onChanged: (v) => setState(() => _agree = v!),
                title: Text('Segala data... dibebaskan dari claim...'),
              ),
              // Submit
              ElevatedButton(onPressed: _submit, child: Text('Simpan Perubahan')),
            ],
          ),
        ),
      ),
    );
  }
}