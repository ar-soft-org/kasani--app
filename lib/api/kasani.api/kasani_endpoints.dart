class KasaniEndpoints {
  // FIXME use EnvironmentConfig()
  static const String baseServer = 'http://108.174.198.156:4501';
  static const String apiServer = '$baseServer/api';

  //-----------------Auth-----------------
  static const String loginHost = '$apiServer/auth/acceso_aplicacion';
  static const String changePassword = '$apiServer/auth/cambia_contraseña_usuario';
  static const String loginVendor = '$apiServer/auth/acceso_aplicacion';
  static const String forgotPassword = '$apiServer/auth/verifica_usuario';
  //--------------------------------------
  
  //--------------Categories--------------
  static const String categoriesSubcategories = '$apiServer/producto/categoria/consultar';
  //--------------------------------------
  
  //---------------Products---------------
  static const String products = '$apiServer/producto/consultar';
  static const String favoriteProducts = '$apiServer/producto/favoritos';
  //--------------------------------------
  
  
  //----------------Orders----------------
  static const String orderRegister = '$apiServer/prepedido/registrar';
  static const String orderHistory = '$apiServer/prepedido/consultar';
  static const String orderHistoryDetail = '$apiServer/prepedido/consultar_detalle';
  //--------------------------------------

  //----------------Orders----------------
  static const String clients = '$apiServer/cliente/clientes_vendedor';
}
