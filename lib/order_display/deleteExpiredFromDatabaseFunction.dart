import 'orders_display.dart';


void DeleteExpiredFromDatabase()async{

  var list;

  await db.collection("sellerOrder").get().then((event) {
    list = event.docs;
    //print(orderData.orderDataList);
  });

  list = orderData.orderDataList.where(
          (element) => (
          element["expirydate"] == DateTime.now().toString().split(" ")[0]
      )
  );

  if(list!=null){

    for(var i=0;i<list.length;i++){
      await db.collection("sellerOrder").doc(list.elementAt(i).id).delete().then(
            (doc) => print("Order deleted"),
        onError: (e) => print("Error updating document $e"),
      );
      //print(list.elementAt(i).id);
    }

  }
}