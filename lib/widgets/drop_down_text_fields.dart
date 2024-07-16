import '../exports/exports.dart';

class MyDropdownTextField extends StatelessWidget {
  MyDropdownTextField({
    super.key,
    this.hintText,
    required this.list,
  });

  final String? hintText;
  String? dropdownValue;
  bool isEmpty = false;
  List<String>list;

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        height: 32.h,
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          value: dropdownValue,
          padding: EdgeInsets.zero,

          style:TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 13.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ) ,
          onChanged: (value) {

          },
          items:list
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,

              child: Text(value, style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 13.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 13.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.whiteShade,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.whiteShade,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.whiteShade,
              ),
            ),
          ),
        ),
      );

  }
}