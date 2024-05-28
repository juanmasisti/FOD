{3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}


program ejer3;

CONST
valorAlto = 9999;

type
	producto = record
		cod: integer;
		nombre: string;
		precio: real;
		stockActual: integer;
		stockMin: integer;
	end;

	detalle = record
		cod: integer;
		cant: integer;
	end;

	maestro = file of producto;
	detalleArchivo = file of detalle;

procedure leerD(var archivo: detalleArchivo; var dato: detalle);
begin
	if (not eof(archivo)) then
		read(archivo, dato)
	else
		dato.cod := valorAlto;
end;

procedure leerM(var archivo: maestro; var dato: producto);
begin
	if (not eof(archivo)) then
		read(archivo, dato)
	else
		dato.cod := valorAlto;
end;

procedure actualizarMaestro(var maestro: maestro; var detalle: detalleArchivo);
var
  regM: producto;
  regD: detalle;
  codAct: integer;
begin
  reset(maestro);
  reset(detalle);
  leerM(maestro, regM);
  leerD(detalle, regD);
  while (regD.cod <> valorAlto) do
  begin
    codAct := regD.cod;
    // Encontrar el registro correspondiente en el maestro utilizando leerM
    while (regM.cod <> codAct) do
      leerM(maestro, regM);
    // Actualizar el registro del maestro con todas las ventas del detalle
    while (regD.cod = codAct) do
    begin
      regM.stockActual := regM.stockActual - regD.cant;
      leerD(detalle, regD);
    end;
    // Escribir el registro actualizado en el maestro
    seek(maestro, filepos(maestro) - 1);
    write(maestro, regM);
  end;
  close(maestro);
  close(detalle);
end;


procedure listarStockMinimo(var maestro: maestro);
var
	regM: producto;
	texto: Text;
begin
	reset(maestro);
	assign(texto, 'stock_minimo.txt');
	rewrite(texto);
	while (not eof(maestro)) do
		begin
			read(maestro,regM)
			if (regM.stockActual < regM.stockMin) then
				writeln(texto, 'Codigo: ', regM.cod, ' Nombre: ', regM.nombre , ' Stock actual: ', regM.stockActual, ' Stock minimo: ', regM.stockMin, ' Precio: ', regM.precio);
		end;
	close(maestro);
	close(texto);
end;

var
	maestro: maestro;
	detalle: detalleArchivo;
begin
	assign(maestro, 'maestro');
	assign(detalle, 'detalle');
	actualizarMaestro(maestro, detalle);
	listarStockMinimo(maestro);
end.