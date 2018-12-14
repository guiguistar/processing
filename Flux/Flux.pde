Couleurs C = new Couleurs();
Systeme s;

int dt;

void setup() {
  //size(640,380);
  fullScreen();
  
  println(width, height);
  
  s = new Systeme();
  dt = 1;
  
  // Ajout des particules
  
  /*
  s.ajouterParticule( new Particule( new PVector(-300,  0), +4.) );
  s.ajouterParticule( new Particule( new PVector(+200,150), +4.) );
  */
  
  /*
  s.ajouterParticule( new Particule( new PVector(+250,0), +2) );
  s.ajouterParticule( new Particule( new PVector(-250,0), +2) );
  */
  /*
  s.ajouterParticule( new Particule( new PVector(-200,-100), -4.) );
  s.ajouterParticule( new Particule( new PVector(-500,+500), -4) );
  */
  /*
  for(int x = 0; x < width; x+=100) {
     for(int y = 0; y < height; y+=150) {
        s.ajouterParticule( new Particule( new PVector(x-width/2+random(-100,100),y-height/2+random(-50,50)), (int)random(-3,3)) ); 
     }
  }
  */
  
  for(int x = -460; x < 60; x+=15) {
     s.ajouterParticule( new Particule( new PVector(x,-30), +1) ); 
     s.ajouterParticule( new Particule( new PVector(x,+170), -1) ); 
  }

  s.genererPointsAleatoirement(6000);
  //s.genererPointsAutourDuneParticuleAleatoire(20);
  s.genererPointsAutourDesParticulesPositives(3);
  //s.genererPointsAuBordDeLecran(10);
  
  s.calculerChamps(false);
  
  s.setEpaisseurPoint(1);
  
  background(0);
}

void draw() {
  //background(0);
  
  translate(width/2,height/2);
  stroke(255);
  
  //s.dessinerParticules();
  
  //s.dessinerChamps(20);
   
  //s.genererPointsAleatoirement(80);
  //s.genererPointsAutourDesParticulesPositives(20);
  //s.genererPointsAuBordDeLecran(10);
  
  //s.majDynamiquePositionsPoints(300);
  s.majHybridePositionsPoints(dt);
  if( dt < 5100 && s.getTemps() % 20 == 0) { dt *= 4; }
  
  //s.enleverPointsMorts();
  //s.majPrecalculeePositionsPoints(1000.);
  
  s.dessinerPoints();
  
}
