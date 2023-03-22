import 'package:cloud_firestore/cloud_firestore.dart';

Iterable<QueryDocumentSnapshot> CategoryFilter({required var list, required l, required s, required d}){
  var lunch = "";
  var dinner = "";
  var snacks = "";
  if(l){lunch = "lunch";}
  if(s){snacks = "snacks";}
  if(d){dinner = "dinner";}

  return list.where(
          (element) => (
              element["foodtype"]==lunch ||
                  element["foodtype"]==snacks ||
                      element["foodtype"]==dinner
          )
  );

}


Iterable<QueryDocumentSnapshot> PriceFilter({required var list1, required p}){
  //print(p[0]);
  //print(int.parse(element["foodprice"])+1);
  print(list1);
  if(p[0]=='<'){
    print("<3");
    p = p.substring(1);
    return list1.where(
            (element) => (
            int.parse(element["foodprice"]) <= int.parse(p)
        )
    );
  }
  else if(p[0]=='>'){
    p = p.substring(1);
    return list1.where(
            (element) => (
                int.parse(element["foodprice"]) >= int.parse(p)
        )
    );
  }
  else{
    return list1.where(
            (element) => (
                int.parse(element["foodprice"]) == int.parse(p)
        )
    );
  }


}