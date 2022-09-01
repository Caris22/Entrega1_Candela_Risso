CREATE SCHEMA transporte_candelarisso ;


USE transporte_candelarisso ;


CREATE TABLE `articulos` (
  `id_articulo` int NOT NULL AUTO_INCREMENT,
  `medidas` decimal(7,2) NOT NULL,
  `peso_unitario` decimal(7,2) NOT NULL,
  `descripcion` varchar(60) DEFAULT NULL,
  `codigo_barras` varchar(40) NOT NULL,
  PRIMARY KEY (`id_articulo`)) ;
  

  CREATE TABLE `proveedores` (
  `id_proveedor` int NOT NULL AUTO_INCREMENT,
  `contacto` varchar(25) NOT NULL,
  `cuit` varchar(20) NOT NULL,
  `nro_cuenta` varchar(30) NOT NULL,
  `horario` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_proveedor`)) ;
  

  
  CREATE TABLE `choferes` (
  `dni_chofer` varchar(20) NOT NULL,
  `id_proveedor` int NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `apellido` varchar(45) NOT NULL,
  `edad` int NOT NULL,
  PRIMARY KEY (`dni_chofer`),
  KEY `choferes_proveedores_idx` (`id_proveedor`),
  CONSTRAINT `choferes_proveedores` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`)) ;
  

  CREATE TABLE `ubicaciones` (
  `id_ubicacion` int NOT NULL AUTO_INCREMENT,
  `direccion` varchar(60) NOT NULL,
  `pais` varchar(25) NOT NULL,
  `provincia` varchar(25) NOT NULL,
  `localidad` varchar(25) NOT NULL,
  PRIMARY KEY (`id_ubicacion`)) ;
  

  
  CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `telefono` varchar(20) NOT NULL,
  `mail` varchar(40) NOT NULL,
  `id_ubicacion` int NOT NULL,
  `cuit_cliente` varchar(20) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `clientes_ubicaciones_idx` (`id_ubicacion`),
  CONSTRAINT `clientes_ubicaciones` FOREIGN KEY (`id_ubicacion`) REFERENCES `ubicaciones` (`id_ubicacion`)) ;
  

  CREATE TABLE `vehiculos` (
  `id_vehiculo` int NOT NULL AUTO_INCREMENT,
  `patente` varchar(10) NOT NULL,
  `id_proveedor` int NOT NULL,
  `modelo` varchar(50) NOT NULL,
  `capacidad` decimal(6,2) NOT NULL,
  `vehiculoscol` varchar(45) NOT NULL,
  PRIMARY KEY (`id_vehiculo`),
  KEY `vehiculos_proveedores_idx` (`id_proveedor`),
  CONSTRAINT `vehiculos_proveedores` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`)) ;
  

  
  CREATE TABLE `envios` (
  `id_envio` int NOT NULL AUTO_INCREMENT,
  `id_proveedor` int NOT NULL,
  `dni_chofer` varchar(20) NOT NULL,
  `id_vehiculo` int NOT NULL,
  PRIMARY KEY (`id_envio`),
  KEY `envios_proveedores_idx` (`id_proveedor`),
  KEY `envios_choferes_idx` (`dni_chofer`),
  KEY `envios_vehiculos_idx` (`id_vehiculo`),
  CONSTRAINT `envios_choferes` FOREIGN KEY (`dni_chofer`) REFERENCES `choferes` (`dni_chofer`),
  CONSTRAINT `envios_proveedores` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`),
  CONSTRAINT `envios_vehiculos` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`)) ;
  

  
  CREATE TABLE `facturas` (
  `nro_factura` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `metodo_pago` varchar(30) NOT NULL,
  `precio_total` decimal(9,2) NOT NULL,
  `precio unitario` decimal(7,2) NOT NULL,
  PRIMARY KEY (`nro_factura`),
  KEY `facturas_clientes_idx` (`id_cliente`),
  CONSTRAINT `facturas_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`)) ;
  

  
  CREATE TABLE `ordenes` (
  `id_orden` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_articulo` int NOT NULL,
  `direc_entrega` varchar(60) NOT NULL,
  PRIMARY KEY (`id_orden`),
  KEY `ordenes_clientes_idx` (`id_cliente`),
  KEY `ordenes_articulos_idx` (`id_articulo`),
  CONSTRAINT `ordenes_articulos` FOREIGN KEY (`id_articulo`) REFERENCES `articulos` (`id_articulo`),
  CONSTRAINT `ordenes_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`)) ;
  

  
  CREATE TABLE `paradas` (
  `id_ubicacion` int NOT NULL,
  `id_envio` int NOT NULL,
  `duracion_descarga` varchar(20) NOT NULL,
  `boca_descarga` varchar(5) NOT NULL,
  PRIMARY KEY (`id_ubicacion`,`id_envio`),
  KEY `paradas_envios_idx` (`id_envio`),
  CONSTRAINT `paradas_envios` FOREIGN KEY (`id_envio`) REFERENCES `envios` (`id_envio`),
  CONSTRAINT `paradas_ubicaciones` FOREIGN KEY (`id_ubicacion`) REFERENCES `ubicaciones` (`id_ubicacion`)) ;
  

  
  CREATE TABLE `entregas` (
  `id_orden` int NOT NULL,
  `id_envio` int NOT NULL,
  `art_entregado` varchar(30) NOT NULL,
  `cant_articulo_entregado` int NOT NULL,
  PRIMARY KEY (`id_orden`,`id_envio`),
  KEY `entregas_envios_idx` (`id_envio`),
  CONSTRAINT `entregas_envios` FOREIGN KEY (`id_envio`) REFERENCES `envios` (`id_envio`),
  CONSTRAINT `entregas_ordenes` FOREIGN KEY (`id_orden`) REFERENCES `ordenes` (`id_orden`)) ;
  

  
  CREATE TABLE `detalles_ordenes` (
  `id_detalle_orden` int NOT NULL AUTO_INCREMENT,
  `id_orden` int NOT NULL,
  `cant_articulos` int NOT NULL,
  `volumen` decimal(7,2) NOT NULL,
  `unidad_transporte` varchar(45) NOT NULL,
  PRIMARY KEY (`id_detalle_orden`),
  KEY `detalles_ordenes_ordenes_idx` (`id_orden`),
  CONSTRAINT `detalles_ordenes_ordenes` FOREIGN KEY (`id_orden`) REFERENCES `ordenes` (`id_orden`)) ;
  

  
  CREATE TABLE `detalles_facturas` (
  `id_detalle_factura` int NOT NULL AUTO_INCREMENT,
  `nro_factura` int NOT NULL,
  `cant_articulos_enviados` int NOT NULL,
  `cant_km` decimal(7,2) NOT NULL,
  `peaje` tinyint NOT NULL,
  PRIMARY KEY (`id_detalle_factura`),
  KEY `detalles_facturas_facturas_idx` (`nro_factura`),
  CONSTRAINT `detalles_facturas_facturas` FOREIGN KEY (`nro_factura`) REFERENCES `facturas` (`nro_factura`)) ;
  

  
  CREATE TABLE `conducen` (
  `dni_chofer` varchar(20) NOT NULL,
  `id_vehiculo` int NOT NULL,
  `nro_cedula` varchar(45) NOT NULL,
  `vto_cedula` date NOT NULL,
  PRIMARY KEY (`dni_chofer`,`id_vehiculo`),
  KEY `conducen_vehiculos_idx` (`id_vehiculo`),
  CONSTRAINT `conducen_choferes` FOREIGN KEY (`dni_chofer`) REFERENCES `choferes` (`dni_chofer`),
  CONSTRAINT `conducen_vehiculos` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`)) ;
  
  