import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RatingBearScreen extends StatefulWidget {
  const RatingBearScreen({super.key});

  @override
  State<RatingBearScreen> createState() => _RatingBearScreenState();
}

class _RatingBearScreenState extends State<RatingBearScreen> {
  StateMachineController?
      controller; // El ? sirve para verificar que la variable no sea nulo
  // SMI: State Machine Input
  SMIBool? isChecking; // Activa la movilidad de los ojos
  SMITrigger? trigSuccess; // Se emociona
  SMITrigger? trigFail; // Se pone triste

  Artboard? _artboard;

  int rating = 0;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onRiveInit(Artboard artboard) {
    _artboard = artboard;

    controller = StateMachineController.fromArtboard(
      artboard,
      "Login Machine",
    );

    if (controller == null) return;

    artboard.addController(controller!);

    isChecking = controller!.findSMI('isChecking') as SMIBool?;
    trigSuccess = controller!.findSMI('trigSuccess') as SMITrigger?;
    trigFail = controller!.findSMI('trigFail') as SMITrigger?;
  }

  void _resetAndPlayAnimation() {
    if (_artboard != null && controller != null) {
      _artboard!.removeController(controller!);
      _artboard!.addController(controller!);
    }
  }

  void _onStarTap(int starIndex) {
    setState(() {
      rating = starIndex;
    });

    _resetAndPlayAnimation();

    Future.delayed(const Duration(milliseconds: 50), () {
      if (starIndex >= 4) {
        trigSuccess?.fire();
      } else if (starIndex <= 2) {
        trigFail?.fire();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  child: RiveAnimation.asset(
                    'assets/animated_login_character.riv',
                    fit: BoxFit.contain,
                    stateMachines: const ["Login Machine"],
                    onInit: _onRiveInit,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  '¿Disfrutando de Sounter?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '¿Con cuántas estrellas calificarías tu experiencia?\nToca una estrella para calificar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starNumber = index + 1;
                    final isFilled = starNumber <= rating;

                    return GestureDetector(
                      onTap: () => _onStarTap(starNumber),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          isFilled ? Icons.star : Icons.star_border,
                          size: 48,
                          color: isFilled
                              ? const Color(0xFFFFD700)
                              : Colors.grey[300],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: const Color(0xFF5B4CFF),
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Calificar ahora',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: null,
                  child: const Text(
                    'NO GRACIAS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5B4CFF),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
