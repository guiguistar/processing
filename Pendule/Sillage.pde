/*
  Classe pour modéliser le sillage d'un point mobile.
  La structure sous-jacente est une file.
  La queue de sillage représente le point le plus jeune.
  La tête de sillage représente le point le plus ancien.
*/
class Sillage {
  int nombrePoints;    // nombre de points du sillage
  int nombrePointsMax; // nombre maximum de points pour le sillage

  int tete = 0;        // indice de la tête de file
  int queue = 0;       // indice de la future queue de file

  float[] listeX;      // tableau contenant les abscisses des points du sillage
  float[] listeY;      // tableau contenant les ordonnées des points du sillage

  color couleur;       // Couleur du silllage
  
  // Le constructeur de la classe
  Sillage(int nombrePointsMax, color couleur) {
    this.nombrePointsMax = nombrePointsMax;
    this.listeX = new float[this.nombrePointsMax];
    this.listeY = new float[this.nombrePointsMax];
    this.couleur = couleur;
  }
  
  // Méthode pour ajouter un point au silllage
  public void enfiler(PVector v) {
    
      // Si la file est pleine, on enlève la tête du sillage
      if(this.nombrePoints == this.nombrePointsMax) {
          this.defiler(); 
      }
      
      // Si la file n'est pas pleine,
      if(this.nombrePoints < this.nombrePointsMax) {
  
         // On ajoute le nouveau point en queue de sillage
         this.listeX[this.queue] = v.x;
         this.listeY[this.queue] = v.y;
         
         // L'indice de la future queue de file ne doit pas dépacer le tableau
         this.queue = ( this.queue + 1 ) % this.nombrePointsMax;
         
         // On incrémente le nombre de points du sillage
         this.nombrePoints++;
      }
  }
  
  // Méthode pour enlever un point (le plus ancien) du sillage
  public PVector defiler() {
    
     // On vérifie que la file contient au moins un point
     if(this.nombrePoints > 0 ) {
       // On contruit un nouveau point, voué à être retourné par la méthode 
       PVector v = new PVector(this.listeX[this.tete], this.listeY[this.tete]);
       
       // L'indice de la tete ne doit pas sortir du tableau
       this.tete = ( this.tete + 1 ) % this.nombrePointsMax;
       
       // On décrémente le nombre de points de la file
       this.nombrePoints--;
       return v;
     }
     
     // Si la file est vide, on retourne une "rérérence null"
     return null;
  }
  
  // Une méthode pour tracer le sillage comme une suite de points
  void dessiner() {
    // On vérifie qu'il y a des points à tracer
    if(this.nombrePoints > 0) {
      // L'indice du point du sillage à tracer
      int j;
      for(int i = 0; i < this.nombrePoints-1; i++) {
         // j parcourt la file
         j = ( this.tete + i ) % this.nombrePointsMax;
         
         // On établit la transparence des points du sillage
         stroke(this.couleur, 255*exp((i-this.nombrePoints)*0.005));
         
         // On trace le point
         point(this.listeX[j], this.listeY[j]);          
      }
    }
  }
  // Une méthode pour tracer le sillage comme une ligne
  void dessiner_ligne() {
    // On vérifie qu'il y a des points à tracer
    if(this.nombrePoints > 0) {
      int j, k;
      for(int i = 0; i < this.nombrePoints-1; i++) {
         // L'indice du premier point du segment à tracer
         j = ( this.tete + i ) % this.nombrePointsMax;
         // L'indice du deuxième point du segment
         k = ( j + this.nombrePointsMax + 1 ) % this.nombrePointsMax;
         
         // Calcul de la transparence
         strokeCap(ROUND);
         stroke(this.couleur, i*255./this.nombrePoints);
         
         // On trace la ligne
         strokeCap(SQUARE);
         line(this.listeX[j], this.listeY[j],this.listeX[k], this.listeY[k]);          
      }
    }
  }
}
