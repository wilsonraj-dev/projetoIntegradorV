import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projeto_pi_flutter/model/address.dart';
import 'package:projeto_pi_flutter/model/product.dart';
import 'package:projeto_pi_flutter/model/user.dart';
import 'package:projeto_pi_flutter/model/user_manager.dart';
import 'package:projeto_pi_flutter/services/cepaberto_service.dart';
import 'cart_product.dart';


class CartManager extends ChangeNotifier{

  List<CartProduct> items = [];

  User user;
  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;

  //Recuperando valor total do pedido
  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager){
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();

    if(user != null){
      _loadCartItems();
      _loadUserAddress();
      removeAddress();
    }
  }

  Future<void> _loadCartItems() async{
     final QuerySnapshot cartSnap = await user.cartRerefence.getDocuments();

     items = cartSnap.documents.map(
         (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)
     ).toList();
  }

  Future<void> _loadUserAddress() async{
    if(user.address != null
        && await calculateDelivery(user.address.latitude, user.address.longitude)){
      address = user.address;
      notifyListeners();
    }
  }

  //Adicionando produtos
  void addToCart(Product product){
    try{
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch(e){
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartRerefence.add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdated();
    }
    notifyListeners();
  }

  //Removendo produtos
  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartRerefence.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  //Atualizando produtos
  void _onItemUpdated(){
    productsPrice = 0.0;
    for(int i=0; i<items.length; i++){
      final cartProduct = items[i];

      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }
     notifyListeners();
  }

  //Atualizando carrinho
  void _updateCartProduct(CartProduct cartProduct){
    if(cartProduct.id != null) {
      user.cartRerefence.document(cartProduct.id).updateData(cartProduct.toCartItemMap());
    }
  }


  bool get isCartValid{
    for(final cartProduct in items){
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  //Desabilitando campo de 'Continuar para pagamento'
  bool get isAddressValid => address != null && deliveryPrice != null;


  //ADDRESS
  Future<void> getAddress(String cep) async{
    loading = true;
    final cepAbertoService = CepAbertoService();

    try{
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if(cepAbertoAddress != null){
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          latitude: cepAbertoAddress.latitude,
          longitude: cepAbertoAddress.longitude
        );
      }
      loading = false;
    }
    catch (e){
      loading = false;
      return Future.error('CEP Inválido');
    }
  }


  Future<void> setAddress(Address address) async{
    loading = true;
    this.address = address;

    if(await calculateDelivery(address.latitude, address.longitude)){
      user.setAddress(address);
      loading = false;
      notifyListeners();
    }
    else {
      return Future.error('Endereço fora do raio de entrega');
    }
  }

  void removeAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async{
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxKm = doc.data['maxKm'] as num;

    double dis = await Geolocator().distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

    print('Distance $dis');

    if(dis > maxKm){
      return false;
    }
    //Calculando frete da entrega
    deliveryPrice = base + dis * km;
    return true;
  }
}