class Course {
  int id;
  String nombre;
  int teckstack;
  int costo;

  Course(this.nombre, this.teckstack, this.costo);
  Course.withId(this.id, this.nombre, this.teckstack, this.costo);
}
