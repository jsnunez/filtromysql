
CREATE DATABASE Gourmet;


Use Gourmet;




CREATE TABLE  cliente (
    id int AUTO_INCREMENT,
    nombre VARCHAR(100),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(15),
    fecha_registro DATE,
    CONSTRAINT PRIMARY KEY (id,correo_electronico)
);



CREATE TABLE  pedidos (
    id int AUTO_INCREMENT,
    fkidcliente INT(11),
    fecha DATE,
    total decimal(10,2),
    CONSTRAINT Pk_id_cliente PRIMARY KEY (id),
    CONSTRAINT FK_pedido_cliente FOREIGN KEY (fkidcliente) REFERENCES cliente (id)
);




CREATE TABLE  menus (
    id int AUTO_INCREMENT,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio decimal(10,2),
    CONSTRAINT Pk_id_menu PRIMARY KEY (id)
    );





CREATE TABLE  detallespedido (
    fkidpedido INT(11),
    fkidmenu INT(11),
    cantidad INT,
    precio_unitario decimal(10,2),
    CONSTRAINT Pk_id_detallespedido PRIMARY KEY (fkidpedido,fkidmenu),
    CONSTRAINT FK_detalle_pedido FOREIGN KEY (fkidpedido) REFERENCES pedidos (id),
    CONSTRAINT FK_detalle_menu  FOREIGN KEY (fkidmenu) REFERENCES menus (id)
    );





















