import 'package:projetmobiles6/model/Categorie.dart';
import 'package:projetmobiles6/model/MainElementItem.dart';

class Project extends MainElementItem{

  List<Categorie> categories = <Categorie>[];

  Project(String name, String description) : super(name, description);

  addCategorie(Categorie categorie){
    categories.add(categorie);
  }




}