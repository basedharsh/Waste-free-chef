import 'orders_display.dart';

void GetDataFromDatabase()async{
  await db.collection("sellerOrder").get().then((event) {
    orderData.orderDataList = event.docs;
    loading = false;
    //print(orderData.orderDataList);
  });
}