import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../core/components/components.dart';
import '../../../core/constants/colors.dart';

class MenuButton extends StatefulWidget {
  final String label;
  final String? iconPath;
  final bool? isCheckIn;
  final bool? isDaftar;
  final bool isDaftarCheckIn;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.label,
    this.iconPath,
    this.isCheckIn,
    this.isDaftar,
    required this.isDaftarCheckIn,
    required this.onPressed,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  @override
  void initState() {
      
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: AppColors.stroke,
          ),
          color: widget.isDaftar == true
              ? widget.isCheckIn == true
                  ? AppColors.primary.withOpacity(0.4)
                  : AppColors.red.withOpacity(.2)
              : AppColors.primary.withOpacity(.1),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isDaftarCheckIn
                    ? SvgPicture.asset(
                        widget.iconPath!,
                        width: 40.0,
                        height: 40.0,
                      )
                    : Icon(
                        Icons.fact_check_outlined,
                        size: 35,
                        color: AppColors.black,
                      ),
                const SpaceHeight(4.0),
                Text(
                  widget.label,
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ),

            // widget.isDaftarCheckIn
            //     ? widget.isCheckIn!
            //         ? BlocBuilder<GetAttendanceByDateBloc,
            //             GetAttendanceByDateState>(
            //             builder: (context, state) {
            //               return state.maybeWhen(
            //                 orElse: () => SizedBox.shrink(),
            //                 error: (message) => Center(
            //                   child: Text('Error'),
            //                 ),
            //                 loading: () => Center(
            //                   child: CircularProgressIndicator(),
            //                 ),
            //                 empty: () {
            //                   return Positioned(
            //                     bottom: -20,
            //                     child: Container(
            //                       width: 70,
            //                       height: 20,
            //                       decoration: BoxDecoration(
            //                         color: AppColors.primary,
            //                         borderRadius: BorderRadius.circular(100),
            //                       ),
            //                       child: Center(
            //                           child: Text(
            //                         'Done',
            //                         style: TextStyle(
            //                           color: AppColors.white,
            //                         ),
            //                       )),
            //                     ),
            //                   );
            //                 },
            //                 loaded: (attendance) {
            //                   final timeParts = attendance.timeIn!.split(':');
            //                   final hour = timeParts[0]; // Jam
            //                   final minute = timeParts[1]; // Menit
            //                   return Positioned(
            //                     bottom: -20,
            //                     child: Container(
            //                       width: 70,
            //                       height: 20,
            //                       decoration: BoxDecoration(
            //                         color: AppColors.primary,
            //                         borderRadius: BorderRadius.circular(100),
            //                       ),
            //                       child: Center(
            //                           child: Text(
            //                         '$hour:$minute',
            //                         style: TextStyle(
            //                           color: AppColors.white,
            //                         ),
            //                       )),
            //                     ),
            //                   );
            //                 },
            //               );
            //             },
            //           )
            //         : SizedBox.shrink()
            //     : widget.isDaftar!
            //         ? BlocBuilder<GetAttendanceByDateBloc,
            //             GetAttendanceByDateState>(
            //             builder: (context, state) {
            //               return state.maybeWhen(
            //                 orElse: () => SizedBox.shrink(),
            //                 error: (message) => Center(
            //                   child: Text(message),
            //                 ),
            //                 loading: () => Center(
            //                   child: CircularProgressIndicator(),
            //                 ),
            //                 empty: () {
            //                   return Positioned(
            //                     bottom: -20,
            //                     child: Container(
            //                       width: 70,
            //                       height: 20,
            //                       decoration: BoxDecoration(
            //                         color: AppColors.primary,
            //                         borderRadius: BorderRadius.circular(100),
            //                       ),
            //                       child: Center(
            //                           child: Text(
            //                         'Done',
            //                         style: TextStyle(
            //                           color: AppColors.white,
            //                         ),
            //                       )),
            //                     ),
            //                   );
            //                 },
            //                 loaded: (attendance) {
            //                   final timeParts = attendance.timeOut!.split(':');
            //                   final hour = timeParts[0]; // Jam
            //                   final minute = timeParts[1];
            //                   return Positioned(
            //                     bottom: -20,
            //                     child: Container(
            //                       width: 70,
            //                       height: 20,
            //                       decoration: BoxDecoration(
            //                         color: AppColors.primary,
            //                         borderRadius: BorderRadius.circular(100),
            //                       ),
            //                       child: Center(
            //                           child: Text(
            //                         '$hour:$minute',
            //                         style: TextStyle(
            //                           color: AppColors.white,
            //                         ),
            //                       )),
            //                     ),
            //                   );
            //                 },
            //               );
            //             },
            //           )
            //         : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
