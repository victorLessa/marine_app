import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:marine/providers/app_provider.dart';
import 'package:marine/routes/paths.dart';
import 'package:marine/styles/app_style.dart';
import 'package:marine/widgets/button_loading.dart';
import 'package:provider/provider.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return introSlider();
  }

  Widget introSlider() {
    return IntroSlider(
        indicatorConfig: IndicatorConfig(
            colorActiveIndicator: AppColors.primaryColor,
            colorIndicator: AppColors.secondaryColor),
        renderPrevBtn: Text(
          "Anterior",
          style: TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.primaryColor),
        ),
        backgroundColorAllTabs: Colors.white,
        renderSkipBtn: Text("Pular",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
        renderNextBtn: Text("Próximo",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
        renderDoneBtn: Text("Finalizar",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
        isShowPrevBtn: true,
        isShowSkipBtn: false,
        listContentConfig: [
          ContentConfig(
            pathImage: 'assets/images/calendario.png',
            widgetDescription: Column(
              children: [
                Text(
                  "Controle sua escala",
                  style: AppFonts.titleIntro,
                ),
                Container(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "Aqui você controla sua escala de trabalho com precisão, deixa os calculos com a gente.",
                    style: AppFonts.subtitleIntro,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          ContentConfig(
            pathImage: 'assets/images/mundo.png',
            widgetDescription: Column(
              children: [
                Text(
                  "Aproveite seu tempo livre",
                  style: AppFonts.titleIntro,
                ),
                Container(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "Te ajudamos a planejar suas folgas para curtir com a familia.",
                    style: AppFonts.subtitleIntro,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          ContentConfig(
            pathImage: 'assets/images/ferias.png',
            widthImage: double.infinity,
            widgetDescription: Column(
              children: [
                Text("Aproveite", style: AppFonts.titleIntro),
                Container(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "Se preocupe com o que realmente importa. Sua folga!",
                    style: AppFonts.subtitleIntro,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ],
        onDonePress: () {
          // Navegar para outra página
          final appProvider = Provider.of<AppProvider>(context, listen: false);
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Antes de começar precisamos saber seu nome",
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: appProvider.state.userName,
                          decoration: InputDecoration(
                              labelText: "Nome",
                              labelStyle: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.w500),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.secondaryColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.secondaryColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.secondaryColor)),
                              fillColor: AppColors.secondaryColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um nome';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  actions: [
                    Consumer<AppProvider>(
                        builder: (BuildContext context, appProvider, _) {
                      return ButtonLoading(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.transparent), // Defina a cor de fundo aqui
                        ),
                        progressIndicatorColor: Colors.black,
                        isBusy: appProvider.isBusy,
                        child: Text(
                          'Salvar',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await appProvider.updateUserName(appProvider.state);
                            await appProvider.loadUserData();
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(
                                  context, AppRouterPaths.home);
                            }
                          }
                        },
                      );
                    })
                  ],
                );
              });
        });
  }
}
