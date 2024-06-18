import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absensi_app/core/helper/radius_calculate.dart';
import 'package:flutter_absensi_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_absensi_app/presentation/home/bloc/get_company/get_company_bloc.dart';
import 'package:flutter_absensi_app/presentation/home/bloc/is_checkedin/is_checkedin_bloc.dart';
import 'package:flutter_absensi_app/presentation/home/pages/attendance_checkin_page.dart';
import 'package:flutter_absensi_app/presentation/home/pages/register_face_attendance_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../../core/core.dart';
import '../widgets/menu_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? faceEmbedding;

  @override
  void initState() {
    _initializeFaceEmbedding();

    context.read<IsCheckedinBloc>().add(const IsCheckedinEvent.isCheckedIn());
    context.read<GetCompanyBloc>().add(const GetCompanyEvent.getCompany());

    super.initState();
    getCurrentPosition();
  }

  double? latitude;
  double? longitude;

  Future<void> getCurrentPosition() async {
    try {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      locationData = await location.getLocation();
      latitude = locationData.latitude;
      longitude = locationData.longitude;

      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == 'IO_ERROR') {
        debugPrint(
            'A network error occurred trying to lookup the supplied coordinates: ${e.message}');
      } else {
        debugPrint('Failed to lookup coordinates: ${e.message}');
      }
    } catch (e) {
      debugPrint('An unknown error occurred: $e');
    }
  }

  Future<void> _initializeFaceEmbedding() async {
    print('---------------> Face : $faceEmbedding');
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      setState(() {
        faceEmbedding = authData?.user?.faceEmbedding;
      });
    } catch (e) {
      print('Error fetching auth data: $e');
      setState(() {
        faceEmbedding = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(
            top: 40,
            left: 35,
            right: 35,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hallo,',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          'Danadipa',
                          style: const TextStyle(
                            fontSize: 30.0,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SpaceHeight(24.0),
              faceEmbedding != null
                  ? Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.green.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SpaceWidth(5),
                            Assets.icons.warning.svg(
                              color: AppColors.green,
                            ),
                            SpaceWidth(10),
                            Flexible(
                              child: Text(
                                'Wajah sudah terdaftar',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.black,
                                ),
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.red.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpaceWidth(5),
                            Assets.icons.warning.svg(),
                            SpaceWidth(10),
                            Flexible(
                              child: Text(
                                'Wajah belum terdaftar!!!',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              const SpaceHeight(40.0),
              Text(
                'Fitur',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SpaceHeight(20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Daftar
                    BlocBuilder<GetCompanyBloc, GetCompanyState>(
                      builder: (context, state) {
                        final latitudePoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (data) => double.parse(data.latitude!),
                        );
                        final longitudePoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (data) => double.parse(data.longitude!),
                        );

                        final radiusPoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (data) => double.parse(data.radiusKm!),
                        );
                        return BlocConsumer<IsCheckedinBloc, IsCheckedinState>(
                          listener: (context, state) {
                            //
                          },
                          builder: (context, state) {
                            return faceEmbedding != null
                                ? MenuButton(
                                    label: 'Daftar Wajah',
                                    iconPath:
                                        Assets.icons.attendanceActive.path,
                                    isDaftarCheckIn: true,
                                    onPressed: () async {
                                      if (faceEmbedding != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Anda sudah checkin'),
                                            backgroundColor: AppColors.red,
                                          ),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          barrierColor:
                                              Colors.black.withOpacity(0.5),
                                          builder: (context) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.white,
                                              ),
                                            );
                                          },
                                        );
                                        // cek lokasi palsu
                                        final position = await Geolocator
                                            .getCurrentPosition();
                                        // cek radius
                                        final distanceKm =
                                            RadiusCalculate.calculateDistance(
                                          latitude ?? 0.0,
                                          longitude ?? 0.0,
                                          latitudePoint,
                                          longitudePoint,
                                        );
                                        if (position.isMocked) {
                                          context.pop();
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierColor:
                                                Colors.black.withOpacity(0.8),
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SvgPicture.asset(
                                                        Assets
                                                            .icons.warning.path,
                                                        width: 150,
                                                      ),
                                                      SpaceHeight(10),
                                                      const Text(
                                                        'HAYOHH PAKAI FAKE GPS YA!!!',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              AppColors.primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          return;
                                        } else {
                                          if (distanceKm > radiusPoint) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Anda diluar jangkauan absen',
                                                ),
                                                backgroundColor: AppColors.red,
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                            return;
                                          } else {
                                            Navigator.of(context).pop();
                                            context.push(
                                              const AttendanceCheckinPage(),
                                            );
                                            print(
                                                '=============-------->>>>${faceEmbedding}');
                                          }
                                        }
                                      }
                                    },
                                  )
                                : MenuButton(
                                    label: 'Daftar Wajah',
                                    iconPath: Assets.icons.attendance.path,
                                    isDaftarCheckIn: true,
                                    onPressed: () async {
                                      context.push(
                                          const RegisterFaceAttendencePage());
                                    },
                                  );
                          },
                        );
                      },
                    ),

                    // Masuk
                    BlocBuilder<GetCompanyBloc, GetCompanyState>(
                      builder: (context, state) {
                        final latitudePoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (data) => double.parse(data.latitude!),
                        );
                        final longitudePoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (data) => double.parse(data.longitude!),
                        );

                        final radiusPoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (data) => double.parse(data.radiusKm!),
                        );
                        return BlocConsumer<IsCheckedinBloc, IsCheckedinState>(
                          listener: (context, state) {
                            //
                          },
                          builder: (context, state) {
                            final isCheckin = state.maybeWhen(
                              orElse: () => false,
                              success: (data) => data.isCheckedin,
                            );
                            return faceEmbedding != null
                                ? MenuButton(
                                    label: 'Presensi Datang',
                                    isCheckIn: isCheckin,
                                    isDaftarCheckIn: false,
                                    onPressed: () async {
                                      if (isCheckin) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Anda sudah checkin'),
                                            backgroundColor: AppColors.red,
                                          ),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          barrierColor:
                                              Colors.black.withOpacity(0.5),
                                          builder: (context) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.white,
                                              ),
                                            );
                                          },
                                        );
                                        // cek lokasi palsu
                                        final position = await Geolocator
                                            .getCurrentPosition();
                                        // cek radius
                                        final distanceKm =
                                            RadiusCalculate.calculateDistance(
                                          latitude ?? 0.0,
                                          longitude ?? 0.0,
                                          latitudePoint,
                                          longitudePoint,
                                        );
                                        if (position.isMocked) {
                                          context.pop();
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierColor:
                                                Colors.black.withOpacity(0.8),
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SvgPicture.asset(
                                                        Assets
                                                            .icons.warning.path,
                                                        width: 150,
                                                      ),
                                                      SpaceHeight(10),
                                                      const Text(
                                                        'HAYOHH PAKAI FAKE GPS YA!!!',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              AppColors.primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          return;
                                        } else {
                                          if (distanceKm > radiusPoint) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Anda diluar jangkauan absen',
                                                ),
                                                backgroundColor: AppColors.red,
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                            return;
                                          } else {
                                            Navigator.of(context).pop();
                                            context.push(
                                              const AttendanceCheckinPage(),
                                            );
                                            print(
                                                '=============-------->>>>${faceEmbedding}');
                                          }
                                        }
                                      }
                                    },
                                  )
                                : MenuButton(
                                    label: 'Presensi Datang',
                                    isCheckIn: isCheckin,
                                    isDaftarCheckIn: false,
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Anda belum Daftarkan Wajah!'),
                                          backgroundColor: AppColors.red,
                                        ),
                                      );
                                    },
                                  );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SpaceHeight(100.0),
            ],
          ),
        ),
      ),
    );
  }
}
