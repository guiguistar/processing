import java.util.Iterator;

class Systeme {
   ArrayList<Particule> particules; // Les charges fixes du système
   ArrayList<CVector> points; // Les points mobiles du système
   
   PVector[][] positions; // Positions précalculées pour chaque pixel
   PVector[][] champ; // Champ précalculé en les positions correspondant à chaque pixel
   
   // Permet de boucler sur les points et d'enlever les points morts en même temps
   Iterator<CVector> iterateurDePoints;
   
   float k = 0.; // Pour la fonction couleur de Filou
   int temps = 0; // Compte le nombre d'appels à la méthode dessiner()
   float epaisseurPoint = 2;
   
   Systeme() {
      this.particules = new ArrayList<Particule>();;
      this.points = new ArrayList<CVector>();
   }
   
   void ajouterParticule(Particule p) {
      this.particules.add(p); 
   }
   
   PVector calculerChamp(PVector position) {
      PVector ch = new PVector(0,0);
      // Boucle sur l'ensemble des particules pour calculer le champ total
      for(Particule p : this.particules) {
         ch.add(p.champ_exerce_sur(position));
      }
      return ch;
   }
   
   // Calcul du champs total pour tous les pixels de l'écran
   void calculerChamps(boolean normalise) {
       this.positions = new PVector[width][];
       this.champ     = new PVector[width][];
       for(int x = 0; x < width; x++) {
           this.positions[x] = new PVector[height];
           this.champ[x]     = new PVector[height];
           
           for(int y = 0; y < height; y++) {
              this.positions[x][y] = new PVector(-width/2 + x, -height/2 + y);
              this.champ[x][y] = this.calculerChamp(this.positions[x][y]);
           
              // Si on veut normaliser le champ; casse les lois de la physique
              if(normalise) {
                 this.champ[x][y] = this.champ[x][y].mult(10/this.champ[x][y].mag());
              }
           }
       }
   }
   void dessinerParticules() {
      for(Particule p : this.particules) {
         p.dessiner(); 
      }
   }
   // Mise à jour dynamique de la position des points;
   // Le champs exercé sur chaque point est calculé en temps réel
   void majDynamiquePositionsPoints(float pas) {
      for(CVector point : this.points) {
         PVector deplacement = s.calculerChamp(point);
         point.add( deplacement.mult(pas) );
      }
   }
   // Mise à jour précalculée de la position des points;
   // Le champs exercé sur est calculé à la construction du système, uniquement pour les points de l'écran
   void majPrecalculeePositionsPoints(float pas) {
      for(CVector point : this.points) {
         PVector deplacement = this.champ[(int)(point.x+width/2)][(int)(point.y+height/2)].copy();
         point.add( deplacement.mult(pas) );
      }
   }
   // Mise à jour précalculée pour les points de l'écran
   // et dynamique pour les points hors de l'écran
   void majHybridePositionsPoints(float pas) {
      for(CVector point : this.points) {
          PVector deplacement;
          if(point.x < -width/2+1 
             || point.x > width/2-1
             || point.y < -height/2+1
             || point.y > height/2-1) {
             deplacement = s.calculerChamp(point);
          }
          else {
             deplacement = this.champ[(int)(point.x+width/2)][(int)(point.y+height/2)].copy();
          }
          point.add( deplacement.mult(pas) );
      }     
   }
   // Attention à générer des positions contenues dans l'écran
   ArrayList<CVector> genererPointsAleatoirement(int nombrePoints) {
      for(int i = 0; i < nombrePoints; i++) {
         CVector p = new CVector(random(1,width-1)-width/2,random(1,height-1)-height/2,color(255,0,0));
         this.points.add(p);
      }
      return this.points;
   }
   ArrayList<CVector> genererPointsAutourDuneParticuleAleatoire(int nombrePoints) {
      Particule  part = this.particules.get( (int)random(this.particules.size()) );
      this.genererPointsAutourDuneParticule(part, nombrePoints);

      return this.points;
   }
   void genererPointsAutourDuneParticule(Particule particule, int nombrePoints) {
      nombrePoints *= (int) sqrt(abs(particule.getCharge()));
      //float a = 2*PI *random(1.);
      //float a = (this.temps % 3) * 2 * PI / 3;
      for(int i = 0; i < nombrePoints; i++) {
         // On crée un point à droite de la particule
         CVector p = new CVector(5,0,color(150,55+200*sin(this.temps/300.),200*cos(this.temps/100.)));
         // puis on le fait tourner d'une fraction de tour
         p.rotate(2*PI*i/nombrePoints);   
         p.add(particule.getPosition());
         
         this.points.add(p);
      }     
   }
   void genererPointsAutourDesParticulesPositives(int nombrePoints) {
      // On genère les points toutes les 40 itérations
      if(this.temps % 40 != 0) { return; }
      
      for(Particule part : this.particules) {
         if(part.charge < 0) {
            this.genererPointsAutourDuneParticule(part, nombrePoints); 
         }
      }
   }
   // Voir s'il faudrait pas utiliser this.positions
   void genererPointsAuBordDeLecran(int pas) {
       if(this.temps % 20 != 00) {
          return; 
       }
       for( int x = 0; x < width-pas; x += pas) {
          this.points.add( new CVector(x-width/2+pas, -height/2+pas, color(0,0,255)));
          this.points.add( new CVector(x-width/2+pas, +height/2-pas, color(0,0,255)));
       }
       for( int y = 0; y < height-pas; y += pas) {
          this.points.add( new CVector(-width/2+pas, y-height/2+pas, color(255,0,255)));
          this.points.add( new CVector(+width/2-pas, y-height/2+pas, color(255,0,255)));         
       }
   }
   void enleverPointsMorts() {
      this.iterateurDePoints = this.points.iterator();  
      while(this.iterateurDePoints.hasNext()) {
          PVector point = this.iterateurDePoints.next();
          
          // Teste si le point est sorti de l'écran
          if(point.x < -width/2
             || point.x > width/2
             || point.y < -height/2
             || point.y > height/2
             
             // où s'il est près d'un particule négative
             || pointProcheParticuleNegative(point)) {
             this.iterateurDePoints.remove();
         }
      }
      println(this.points.size());
   }
   boolean pointProcheParticuleNegative(PVector point) {
      for(Particule p : this.particules) {
         if( p.charge > 0 && point.dist(p.getPosition()) < 10 ) {
            return true; 
         }
      }
      return false; 
   }
   void dessinerChamps(int pas) {
      PVector pos;
      PVector ch;
      for(int j = 0; j < width; j += pas) {
         for(int i = 0; i < height; i += pas) {
            pos = this.positions[j][i];
            ch = this.champ[j][i];
            stroke(255);
            strokeWeight(0.5);
            line(pos.x,pos.y,pos.x+ch.x,pos.y+ch.y);
         }
      }
   }
   void dessinerPoints() { 
      for( CVector point: this.points) {
         // Trois fonctions de couleurs au choix
         
         stroke(this.fonctionCouleurUn(),254);
         //stroke(this.fonctionCouleurDeux(point.x));
         //stroke(point.getCouleur());
         
         
         strokeWeight(this.epaisseurPoint);
         point(point.x,point.y);        
      }
      this.temps++;
   }
   color fonctionCouleurUn() {
      color from = color(255, 25, 50,150);
      color to = color(50, 50, 255,150);

      float step = 0.000001;
      this.k += step;
      if( k > 1 ) { k = step; }
      return lerpColor(from, to, this.k);
   }
   color fonctionCouleurDeux(float pos) {
      return color(255*cos(pos/20 - this.temps/10.),150,0); 
   }
   // Setters
   public void setEpaisseurPoint(float ep) {
      this.epaisseurPoint = ep; 
   }
   // Getters
   public int getTemps() { return this.temps; }
}
