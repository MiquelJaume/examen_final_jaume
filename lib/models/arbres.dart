class Arbres {
    bool autocton;
    String detall;
    String foto;
    String nom;
    String tipus;
    String varietat;

    Arbres({
        required this.autocton,
        required this.detall,
        required this.foto,
        required this.nom,
        required this.tipus,
        required this.varietat,
    });

    factory Arbres.fromMap(Map<String, dynamic> json) => Arbres(
        autocton: json["autocton"],
        detall: json["detall"],
        foto: json["foto"],
        nom: json["nom"],
        tipus: json["tipus"],
        varietat: json["varietat"],
    );

    Map<String, dynamic> toMap() => {
        "autocton": autocton,
        "detall": detall,
        "foto": foto,
        "nom": nom,
        "tipus": tipus,
        "varietat": varietat,
    };
}