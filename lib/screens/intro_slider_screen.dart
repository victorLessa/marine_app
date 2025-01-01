import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:marine/providers/app_provider.dart';
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
        renderPrevBtn: const Text(
          "Anterior",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColorAllTabs: Colors.white,
        renderSkipBtn:
            const Text("Pular", style: TextStyle(color: Colors.white)),
        renderNextBtn:
            const Text("Próximo", style: TextStyle(color: Colors.white)),
        renderDoneBtn:
            const Text("Finalizar", style: TextStyle(color: Colors.white)),
        isShowPrevBtn: true,
        isShowSkipBtn: false,
        listContentConfig: const [
          ContentConfig(
            backgroundColor: Colors.blue,
            widgetDescription: Column(
              children: [
                Text(
                  "Controle sua escala.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Aqui você controla sua escala de trabalho com precisão, deixa os calculos com a gente.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ContentConfig(
            backgroundColor: Colors.blue,
            widgetDescription: Column(
              children: [
                Text(
                  "Aproveite seu tempo livre",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Te ajudamos a planejar suas folgas para curtir com a familia.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ContentConfig(
            widgetDescription: Column(
              children: [
                Text("Aproveite",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Se preocupe com o que realmente importa.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            backgroundColor: Colors.blue,
          ),
        ],
        onDonePress: () {
          // Navegar para outra página
          final appProvider = Provider.of<AppProvider>(context, listen: false);
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Antes de começar precisamos saber seu nome",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                          decoration: const InputDecoration(
                            labelText: "Nome",
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
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
                        child: const Text(
                          'Salvar',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await appProvider.updateUserName(appProvider.state);
                            await appProvider.loadUserData();
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(context, '/home');
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
