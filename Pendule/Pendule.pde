PenduleDouble p;

// Les couleurs suivantes sont pastel
color rouge  = color(255,179,186);
color orange = color(255,223,186);
color jaune  = color(255,255,186);
color vert   = color(186,255,201);  
color bleu   = color(186,225,255);

void setup() {
   fullScreen();
   //size(640,380);
   
   // Tous les paramètres suivants sont modidiables
   p = new PenduleDouble(0.9*PI, // Angle (en radians) de la première tige par rapport à la verticale
                         PI/3,   // Angle (en radians) de la deuxième tige par rapport à la verticale
                         0.1,    // Vitesse initiale (en radians par seconde) de la première tige
                         -0.05,      // Vitesse initiale (en radians par seconde) de la deuxième tige
                         0.3,    // Masse (en kg) de la première bille
                         0.2,    // Masse (en kg) de la deuxième bille
                         0.85,    // Longueur (en mètres) de la première tige
                         0.45,   // Longueur (en mètres) de la deuxième tige
                         rouge); // Couleur du sillage
}

void draw() {
   background(bleu); // Couleur du fond
   translate( width/2, (4/16.) * height); // Position de l'origine de la première tige
   scale(400);
   p.maj(0.01); // 0.01 est le lap de temps utilisé pour mettre à jour les positions
   p.dessiner();
}
