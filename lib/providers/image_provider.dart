import 'package:flutter/material.dart';
import '../models/image_model.dart';
import '../services/api_service.dart';

class AppImageProvider with ChangeNotifier {
  List<ImageModel> _images = [];
  bool _isLoading = false;
  String _searchValue = '';
  String _selectedArea = '';
  String _selectedClub = '';

  List<ImageModel> get images => _images;
  bool get isLoading => _isLoading;
  String get searchValue => _searchValue;
  String get selectedArea => _selectedArea;
  String get selectedClub => _selectedClub;
  // set searchValue
  set searchValue(String value) {
    _searchValue = value;
    loadImages();
  }

  // set selectedArea
  set selectedArea(String value) {
    _selectedArea = value;
  }

  // set selectedClub
  set selectedClub(String value) {
    _selectedClub = value;
  }

  Future<void> loadImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      _images = await ApiService().fetchImages(_searchValue);
      _selectedArea = '';
      _selectedClub = '';
    } catch (error) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }
}
