#consultas


1.Obtener la lista de todos los menús con sus precios


~~~sql
SELECT nombre, precio FROM menus;
~~~




2. Encontrar todos los pedidos realizados por el cliente 'Juan Perez'
~~~sql
SELECT p.id, p.fecha,p.total
FROM pedidos AS p
JOIN cliente AS c
ON c.id=fkidcliente
WHERE c.nombre='Juan Perez';
~~~


3. Listar los detalles de todos los pedidos, incluyendo el nombre del menú, cantidad y precio unitario

~~~sql
SELECT dp.fkidpedido AS PedidoID, m.nombre AS Menu, dp.cantidad,dp.precio_unitario
FROM detallespedido AS dp
JOIN menus AS m
ON dp.fkidmenu =m.id;

~~~


4. Calcular el total gastado por cada cliente en todos sus pedidos
~~~sql
SELECT c.nombre,SUM(p.total) AS TotalGastado
FROM cliente AS c 
JOIN pedidos AS p
ON p.fkidcliente=c.id
GROUP BY c.nombre;
~~~



5. Encontrar los menús con un precio mayor a $10

~~~sql
SELECT nombre, precio 
FROM menus
WHERE precio>10;
~~~




6. Obtener el menú más caro pedido al menos una vez
~~~sql
SELECT m.nombre, m.precio 
FROM menus m
WHERE id=(SELECT fkidmenu FROM detallespedido
ORDER BY precio_unitario desc
limit 1);

~~~

7. Listar los clientes que han realizado más de un pedido


SELECT  nombre, correo_electronico 
FROM cliente AS c
JOIN pedidos AS p
ON c.id=p.fkidcliente
JOIN
(select fkidcliente, count(fkidcliente) AS compras FROM pedidos
GROUP by fkidcliente) AS n
ON n.fkidcliente=p.fkidcliente
WHERE compras >1
GROUP BY nombre, correo_electronico 
;






8.Obtener el cliente con el mayor gasto total
~~~sql

SELECT c.nombre AS totalCompra FROM cliente AS c
JOIN pedidos AS p
ON c.id=p.fkidcliente
WHERE c.id=(SELECT fkidcliente  FROM pedidos AS p
 GROUP BY p.fkidcliente
ORDER BY SUM(total)  desc
limit 1)
limit 1
;
~~~



9 Mostrar el pedido más reciente de cada cliente





10 Obtener el detalle de pedidos (menús y cantidades) para el cliente 'Juan Perez'.

~~~sql
SELECT dp.fkidpedido,m.nombre,dp.cantidad,dp.precio_unitario
FROM menus AS m
JOIN detallespedido AS dp
ON m.id= dp.fkidmenu
JOIN pedidos AS p
ON p.id=dp.fkidpedido
JOIN cliente AS c
ON p.fkidcliente = c.id
WHERE c.nombre='Juan Perez';

~~~

#Procedimientos Almacenados

Crear un procedimiento almacenado para agregar un nuevo cliente

~~~sql
DELIMITER $$

DROP PROCEDURE IF EXISTS AgregarCliente;
CREATE PROCEDURE AgregarCliente(
    IN nombrea VARCHAR(100),
    IN correo_electronicoa VARCHAR(100),
    IN telefonoa VARCHAR(15),
    IN  fecha_registroa DATE
)
BEGIN
INSERT INTO cliente(nombre,correo_electronico, telefono,fecha_registro)
VALUES 
(nombrea,correo_electronicoa, telefonoa,fecha_registroa);
END $$
DELIMITER ;

~~~


Crear un procedimiento almacenado para obtener los
detalles de un pedido

~~~sql
DELIMITER $$

DROP PROCEDURE IF EXISTS ObtenerDetallesPedido;
CREATE PROCEDURE  (
    IN id INT(11)
)
BEGIN
SELECT m.nombre,dp.cantidad,dp.precio_unitario
FROM detallespedido AS dp
JOIN menus AS m
ON m.id=dp.fkidmenu
WHERE fkidpedido=id;

END $$
DELIMITER ;

~~~


Crear un procedimiento almacenado para actualizar el
precio de un menú
~~~sql
DELIMITER $$

DROP PROCEDURE IF EXISTS ActualizarPrecioMenu;
CREATE PROCEDURE ActualizarPrecioMenu (
    IN idc INT(11),
   IN precion decimal(10,2)
)
BEGIN
Update menus
set precio = precion
WHERE id=idc;

END $$
DELIMITER ;
~~~


Crear un procedimiento almacenado para eliminar un cliente
y sus pedidos
~~~sql
DELIMITER $$

DROP PROCEDURE IF EXISTS EliminarCliente;
CREATE PROCEDURE EliminarCliente (
    IN idc INT(11)
)
BEGIN
DELETE FROM detallespedido
WHERE fkidpedido=(SELECT id FROM pedidos where fkidcliente=idc);

DELETE FROM pedidos
WHERE fkidcliente=idc;

DELETE FROM cliente
WHERE id=idc;



END $$
DELIMITER ;

~~~


Crear un procedimiento almacenado para obtener el total
gastado por un cliente

~~~sql
DELIMITER $$

DROP PROCEDURE IF EXISTS TotalGastadoPorCliente;
CREATE PROCEDURE TotalGastadoPorCliente (
    IN idc INT(11)

)
BEGIN
SELECT SUM(total) FROM pedidos
WHERE fkidcliente=idc;


END $$
DELIMITER ;
~~~
