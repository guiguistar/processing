/*
  Classe pour modéliser un pendule double.
  Fiche Wikipedia: 

  https://fr.wikipedia.org/wiki/Pendule_double
  
*/
class PenduleDouble {
   float theta1;
   float theta2;
   float theta_1;
   float theta_2;
   
   float m1;
   float m2;
   
   float l1;
   float l2;
   
   float gr = 9.81; // Constante gravitationnelle

   Sillage s1;
   Sillage s2;

   PenduleDouble(float t1, float t2, float t_1, float t_2, float m1, float m2, float l1, float l2, color couleurSillage) {
      // Initialisations
      this.theta1  = t1;   // Angle (en radians) de la première tige par rapport à la verticale
      this.theta2  = t2;   // Angle (en radians) de la deuxième tige par rapport à la verticale
      this.theta_1 = t_1;  // Vitesse initiale (en radians par seconde) de la première tige
      this.theta_2 = t_2;  // Vitesse initiale (en radians par seconde) de la deuxième tige
      this.m1      = m1;   // Masse (en kg) de la première bille
      this.m2      = m2;   // Masse (en kg) de la deuxième bille
      this.l1      = l1;   // Longueur (en mètres) de la première tige
      this.l2      = l2;   // Longueur (en mètres) de la deuxième tige

      this.s1 = new Sillage(200, couleurSillage); // Sillage pour la première bille
      this.s2 = new Sillage(200, couleurSillage); // Sillage pour la deuxième bille
   }
   void maj(float dt) {
     /*
         Les équations et la déifnition des angles sont dispnibles sur la fiche Wikipeadia du 
         pendule double:
         
         https://fr.wikipedia.org/wiki/Pendule_double
         
         A * theta__1 + B * theta2__ + E = 0
         C * theta__1 + D * theta2__ + F = 0
     */
     
     // Implémentation des équations
     float A = (m1+m2) * l1;
     float B = m2 * l2 * cos(theta1 - theta2);
     float E = m2 * l2 * theta_2 * theta_2 * sin(theta1-theta2) + (m1+m2) * gr * sin(theta1);
 
     float C = l1 * cos(theta1-theta2);
     float D = l2;
     float F = -l1 * theta_1 * theta_1 * sin(theta1-theta2) + gr * sin(theta2);
     
     // Calcul du déterminant du système et de son inverse
     float delta = A * D - C * B;
     float invdelta = 1 / delta;
     
     /*
      Inversion de la matrice du système grâce à la comatrice:
      https://fr.wikipedia.org/wiki/Comatrice#G%C3%A9n%C3%A9ralisation
      
      A  B   X + E
      C  D * Y + F = 0
      
      X                D -B   -E
      Y = (1/delta) * -C  A * -F
     
     */
     
     float theta__1 = invdelta * (-D * E + B * F);
     float theta__2 = invdelta * ( C * E - A * F);
     
     // Misa à jour des vitesses angulaires
     theta_1 += theta__1 * dt;
     theta_2 += theta__2 * dt;
     
     // Mise à jour des positions angulaires
     theta1 += theta_1 * dt;
     theta2 += theta_2 * dt;
   }
   
   // Une méthode pour dessiner les billes et leurs sillages
   void dessiner() {
     // Voir la fiche wikipedia pour la définition des angles
     
     // Coordonnées du centre de la première bille
     float x1 = l1 * sin(theta1);
     float y1 = l1 * cos(theta1);

     // Coordonnées du centre de la deuxième bille
     float x2 = x1 + l2 * sin(theta2);
     float y2 = y1 + l2 * cos(theta2);
     
     // On dessine les billes
     stroke(rouge);     // Couleur des billes
     strokeCap(ROUND);
     strokeWeight(m1*0.2); // Diamètre de la première bille
     point(x1,y1);

     strokeWeight(m2*0.2); // Diamètre de la deuxième bille
     point(x2,y2);
     
     // Les tiges
     strokeWeight(0.004); // Epaisseur des tiges
     line(0,0,x1,y1);     // Première tige
     line(x1,y1,x2,y2);   // Deucième tige
     
     
     // On ajoute les nouveaux points aux sillages
     //s1.enfiler(new PVector(x1,y1)); // Premier sillage facultatif
     s2.enfiler(new PVector(x2,y2)); // Deucième sillage
 
     // Style du sillage: points
     //strokeWeight(0.015);
     //s1.dessiner();
     s2.dessiner();

     // Style du sillage: lignes
     strokeWeight(0.005);
     //s1.dessiner_ligne();
     s2.dessiner_ligne();
 }
}
