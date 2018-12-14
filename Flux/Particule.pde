class Particule {
  // Coordonnées de la particule
  PVector position;
 
  // Charge de la particule
  float charge;
  
  // Constante universelle
  float K = 10.;
  
  // Couleurs pour les particules lorsqu'on les dessine;
  color rouge = color(255,0,0);
  color bleu = color(0,0,255);
  
  // Couleur de la particule
  color couleur;
  
  // Constructeur
  Particule(PVector position, float charge) {
     this.position = position.copy();
     this.charge = charge;
     
     System.out.println("Particule de charge " + this.charge + " en position " + this.position);
  }
  PVector champ_exerce_sur(PVector point) {
     PVector champs = this.position.copy();
     float distance;
     
     champs.sub(point); // Probable erreur de signe ici; relire la doc de sub()
     distance = champs.magSq();

     // La force électrstatique exercée par la particule en le point
     champs = champs.mult( this.K * this.getCharge() / pow(distance,1.5) );
     //champs = champs.mult( this.K * this.getCharge() / distance );
     
     return champs;
  }
  
  void dessiner() {
     // Couleur en fonction du signe de la charge
     if(this.charge > 0) this.couleur = rouge;
     else this.couleur = bleu;
     stroke(this.couleur,250);
     
     // Taille en fonction de la valeur de la charge
     strokeWeight(abs(this.charge*5));

     point(this.position.x, this.position.y); 
  }
  
  // Getters
  public PVector getPosition() { return this.position; }
  public float getCharge() { return this.charge; }
}
