import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/features/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:avlo/features/presentation/blocs/profile_bloc/profile_event.dart';
import 'package:avlo/features/presentation/blocs/profile_bloc/profile_state.dart';
import 'package:avlo/features/presentation/pages/main/main_page.dart';
import 'package:avlo/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/service/shared_preferences_service.dart';
import '../../../../core/util/text_styles.dart';
import '../../../../widgets/custom_text_field.dart';

class ChangeUserProfile extends StatefulWidget {
  ChangeUserProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeUserProfile> createState() => _ChangeUserProfileState();
}

class _ChangeUserProfileState extends State<ChangeUserProfile> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _jobController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _imagePicker = ImagePicker();
  static XFile? _userImage;
  static String? _path;

  @override
  void initState() {
    context.read<ProfileBloc>().add(ProfileInitEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        print(state.toString() + "FROM CHANGE PROFILE");
        if(state is ProfileInitState) {
          print(state.profile.phone_number);
          if(state.profile.last_name != '' && state.profile.first_name != '') {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              return MainPage();
            }), (route) => false);
            SharedPreferencesService.instance.then((value) => value.setAuth(true));

          }else {
            _phoneNumberController.text = state.profile.phone_number;
            _emailController.text = state.profile.email;
          }
        }
        if(state is ProfileSuccessState) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
            return MainPage();
          }), (route) => false);
          SharedPreferencesService.instance.then((value) => value.setAuth(true));
        }
        if(state is ProfileErrorState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(20),
              backgroundColor: AppColors.mainColor,
              content: LocaleText('something_went_wrong', style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
            ),
          );
        }
      },
      child: Scaffold(
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _userImage = await _imagePicker.pickImage(source: ImageSource.gallery);
                        _path = _userImage!.path;
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: 50,
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Align(
                                alignment: Alignment.center,
                                child: Builder(
                                  builder: (context) {
                                    if(_path != null) {
                                      return Image.asset(_path!, fit: BoxFit.cover);
                                    }else {
                                      return Image.asset('assets/png/no_user.png');
                                    }
                                  } ,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SvgPicture.asset('assets/icons_svg/camera.svg'),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SvgPicture.asset('assets/icons_svg/vector.svg'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hint: 'name',
                            onChanged: (value) {},
                            validator: (value) =>
                            value!.isEmpty ? Locales.string(
                                context, 'must_fill_this_line') : null,
                            isFilled: true,
                            color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _surnameController,
                            hint: 'surname',
                            onChanged: (value) {},
                            validator: (value) =>
                            value!.isEmpty ? Locales.string(
                                context, 'must_fill_this_line') : null,
                            isFilled: true,
                            color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _usernameController,
                            hint: 'username',
                            onChanged: (value) {},
                            validator: (value) =>
                            value!.isEmpty ? Locales.string(
                                context, 'must_fill_this_line') : null,
                            isFilled: true,
                            color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _emailController,
                            hint: 'email',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            validator: (value) =>
                            value!.isEmpty ? Locales.string(
                                context, 'must_fill_this_line') : value.contains('@')
                                ? null
                                : Locales.string(context, "enter_valid_info"),
                            isFilled: true,
                            color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _jobController,
                            hint: 'job',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            validator: (value) =>
                            value!.isEmpty ? Locales.string(
                                context, 'must_fill_this_line') : null,
                            isFilled: true,
                            color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _phoneNumberController,
                            hint: 'phone',
                            onChanged: (value) {},
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                            value!.isEmpty ? Locales.string(
                                context, 'must_fill_this_line') : value.length < 7
                                ? Locales.string(context, 'enter_valid_info')
                                : null,
                            isFilled: true,
                            color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    MainButton(
                      color: AppColors.mainColor,
                      title: 'save',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                            ProfileChangeEvent(
                              name: _nameController.text,
                              surname: _surnameController.text,
                              email: _emailController.text,
                              phone: _phoneNumberController.text,
                              username: _usernameController.text,
                              job: _jobController.text,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      child: LocaleText(
                        "skip",
                        style: TextStyle(color: AppColors.mainColor),
                      ),
                      onPressed: () {
                        SharedPreferencesService.instance.then((value) => value.setAuth(true));
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
