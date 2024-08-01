import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';

class CustomPhoneNumber extends StatefulWidget {
  CustomPhoneNumber({
    super.key,
    required this.country,
    required this.onTap,
    required this.controller,
  });

  Country country;

  final Function(Country) onTap;

  final TextEditingController? controller;

  @override
  State<CustomPhoneNumber> createState() => _CustomPhoneNumberState();
}

class _CustomPhoneNumberState extends State<CustomPhoneNumber> {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.transparent),
  );

  String errorMessage = '';
  int numberCount = 0;

  void showPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      favorite: ['IN', 'US', 'NP'],
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 600,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.circular(20),
        inputDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black),
          hintText: "Search your country here...",
          border: InputBorder.none,
        ),
      ),
      onSelect: (country) {
        setState(() {
          widget.country = country;
        });
        widget.onTap(country);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    widget.controller?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller?.text ?? '';
    setState(() {
      numberCount = text.length;
      if (text.startsWith(widget.country.phoneCode)) {
        widget.controller?.text = text.substring(widget.country.phoneCode.length);
        widget.controller?.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller!.text.length));
      }
      if (text.isNotEmpty) {
        if (text.length != 10) {
          errorMessage = 'Invalid mobile number';
        } else {
          errorMessage = '';
        }
      } else {
        errorMessage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            cursorColor: Colors.black,
            controller: widget.controller,
            autofillHints: const [AutofillHints.telephoneNumberLocalSuffix],
            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.zero,
              hintText: "Enter Mobile Number",
              hintStyle: const TextStyle(color: Colors.grey,fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.secondaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.lightAppColor600),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.secondaryColor),
              ),
              prefixIcon: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => showPicker(context),
                child: Container(
                  height: 55,
                  width: 105,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        "${widget.country.flagEmoji} +${widget.country.phoneCode}",
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              suffixIcon: widget.controller!.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    widget.controller?.clear();
                  });
                },
              )
                  : null,
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }
}
