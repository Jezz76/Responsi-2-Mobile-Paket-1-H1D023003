# Inventaris Komputer Jeskris

Aplikasi mobile untuk manajemen inventaris barang komputer dengan fitur autentikasi dan CRUD lengkap.

## IDENTITAS WOK

```
Nama      : Jeskris Oktovianus Silahooy
NIM       : H1D023003
Shift     : A
Shift KRS : C
```

## VIDEO DEMO

https://github.com/user-attachments/assets/a1e43e08-dc30-4ec1-8cf8-6055bdd5aee4


## TECH STACK

Frontend: Flutter (Dart)
Backend: Laravel (PHP)
Database: MySQL
Authentication: Bearer Token

## INSTALASI DAN MENJALANKAN

Backend Setup (Laravel):
1. cd backend
2. composer install
3. cp .env.example .env
4. php artisan key:generate
5. php artisan migrate
6. php artisan db:seed
7. php artisan serve

Backend jalan di: http://localhost:8000

Frontend Setup (Flutter):
1. flutter pub get
2. flutter run -d edge

## SPESIFIKASI API

Base URL: http://localhost:8000/api

AUTHENTICATION ENDPOINTS:

1. Register User Baru
   POST /register
   Request: {name, email, password, password_confirmation}
   Response: {success, message, data: {user: {id, name, email}, token}}

2. Login User
   POST /login
   Request: {email, password}
   Response: {success, message, data: {user: {id, name, email}, token}}

3. Logout User
   POST /logout
   Header: Authorization: Bearer {token}
   Response: {success, message}

INVENTARIS ENDPOINTS (Require Bearer Token):

1. Get List Inventaris
   GET /inventaris
   Header: Authorization: Bearer {token}
   Response: {success, data: [array of inventaris]}

2. Create Inventaris
   POST /inventaris
   Header: Authorization: Bearer {token}
   Request: {nama_barang, harga, jumlah, tanggal_masuk}
   Response: {success, message, data: inventaris}

3. Update Inventaris
   PUT /inventaris/{id}
   Header: Authorization: Bearer {token}
   Request: {nama_barang, harga, jumlah, tanggal_masuk}
   Response: {success, message, data: inventaris}

4. Delete Inventaris
   DELETE /inventaris/{id}
   Header: Authorization: Bearer {token}
   Response: {success, message}

## PENJELASAN KODE

### lib/main.dart
- main(): Entry point aplikasi, inisialisasi AuthService
- MyApp: Setup MaterialApp, routing, theme
- AuthWrapper: Check login status, conditional navigation

### lib/services/auth_service.dart
- init(): Inisialisasi SharedPreferences
- login(): POST ke /api/login, simpan token & user data
- register(): POST ke /api/register, simpan token & user data
- logout(): POST ke /api/logout, hapus token dari storage
- getToken(): Retrieve token dari SharedPreferences
- getCurrentUser(): Retrieve user data dari SharedPreferences
- isLoggedIn(): Check apakah user sudah login

### lib/services/inventaris_service.dart
- init(): Inisialisasi SharedPreferences
- getInventaris(): GET list inventaris dari /api/inventaris
- createInventaris(): POST barang baru ke /api/inventaris
- updateInventaris(): PUT update barang ke /api/inventaris/{id}
- deleteInventaris(): DELETE barang dari /api/inventaris/{id}

### lib/screens/login_screen.dart
- build(): UI login form
- _login(): Validate form, call authService.login(), navigate ke home

### lib/screens/register_screen.dart
- _register(): Validate semua field, call authService.register(), navigate ke home

### lib/screens/home_screen.dart
- _loadUserData(): Get user dari storage, tampilkan di drawer
- _loadInventaris(): GET list inventaris dari API
- _deleteInventaris(): DELETE inventaris, reload list
- _logout(): Call authService.logout(), navigate ke login
- build(): Scaffold dengan drawer, AppBar, list inventaris, FAB

### lib/screens/add_inventaris_screen.dart
- _addInventaris(): Validate form, POST ke API, reload home
- _selectDate(): Show date picker, update tanggal

### lib/screens/edit_inventaris_screen.dart
- _updateInventaris(): Validate form, PUT ke API, reload home
- _selectDate(): Show date picker, update tanggal

### lib/models/user_model.dart
- User class: id, name, email, token
- fromJson(): Parse JSON response dari API
- toJson(): Convert ke JSON untuk storage

### lib/models/inventaris_model.dart
- Inventaris class: id, namaBarang, harga, jumlah, tanggalMasuk
- fromJson(): Parse JSON dari API, map nama_barang ke namaBarang
- toJson(): Convert ke JSON untuk API request

### lib/constants/app_constants.dart
- API URL dan endpoints configuration
- Color theme gray (#757575)
- Padding dan border radius constants

## TESTING

Login: test@example.com / password123

Test Flow:
1. Jalankan backend Laravel
2. Run Flutter app
3. Login atau register
4. Test CRUD: tambah, edit, hapus barang
5. Test logout dan login ulang

