/*
 * Classe pour ajouter une couleur à un vecteur.
 */
class CVector extends PVector {
   color couleur;
   
   CVector(float x, float y, color couleur) {
      super(x, y);
      this.couleur = couleur;
   }
   
   // Getters
   public color getCouleur() { return this.couleur; }
}
