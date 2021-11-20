//create table brice2021 (cleobjet int, statobj VARCHAR (10), carton int, photo int, categorie VARCHAR (20), titre VARCHAR (50), prix int, specfra tinyint(1), specpml tinyint(1), prixcalc int, descriptif VARCHAR (100) );
//insert into brice2021  (cleobjet, statobj, carton, photo, categorie, titre, prix,
// specfra, specpml, prixcalc, descriptif ) value

class Cartonton {
  int cleObjet =0;
  String statusObjet = "";
  int cartonNo = 0;
  int imageNo = 0;
  String categorie = "";
  String titre = "";
  int prix = 0;
  int specFra = 0;
  int  specPml = 0;
  int prixCalc = 0;
  String descriptif = "";
  //
  int kikey=0;

  Cartonton(
      { required this.cleObjet, required this.statusObjet, required this.cartonNo, required this.imageNo, required this.categorie,
        required this.titre, required this.prix, required this.specFra, required this.specPml,required this.prixCalc,
        required this.descriptif});
  factory Cartonton.fromJson(Map<String, dynamic> json) {
    return Cartonton(
      cleObjet: int.parse(json['cleobjet']),
      statusObjet: json['statobj'] as String,
      cartonNo: int.parse(json['carton']),
      imageNo: int.parse(json['photo']),
      categorie: json['categorie'] as String,
      titre: json['categorie'] as String,
      prix: int.parse(json['prix']),
      specFra: int.parse(json['specfra']),
      specPml: int.parse(json['specpml']),
      prixCalc: int.parse(json['prixcalc']),
      descriptif: json['descriptif'] as String,

    );
  }

}
