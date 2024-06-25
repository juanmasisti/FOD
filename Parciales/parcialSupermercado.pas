{ Un supermercado tiene 25 cajas que registran diariamente las ventas de productos. De cada venta se dispone:
numero de ticket, codigo del producto y cantidad de unidades vendidas del producto.
Al finalizar el dia, los archivos correspondientes a las cajas se ordenan por codigo de producto para luego actualizar 
archivo de productos. Los registros del archivo de productos contienen el codigo del prodcuto, la descripcion, la cantidad
en existencia, el stock minimo y el precio de venta actual. Implementar un programa que permita:

a) dada la cantidad de cajas, actualizar la existencia de cada producto registrando la cantidad vendida en la jornada.
Tenga en cuenta que el stock no puedo quedar por debajo de cero-

b) Informar aquellos productos que dispongan unidades en existencia y no hayan sido vendidos.

c) Informar aquellos productos vendidos que quedaron por debajo del stock minimmo.

d) Informar para cada codigo de producto, el nombre y el monto total vendido, tambien informar el monto total facturado en el dia
para todos los productos.

NOTA: No debe implementar el ordenamiento de los archivos, los archivos deben recorrerse una unica vez.
}

program parcialSupermercado;
const
    valorAlto = 9999;
    n = 25;
type
    producto = record
        codigo: integer;
        descripcion: string;
        cantidad: integer;
        stockMinimo: integer;
        precioVenta: real;
    end;

    venta = record
        numeroTicket: integer;
        codigoProducto: integer;
        cantidadVendida: integer;
    end;

    archivo_maestro = file of producto;
    archivo_detalle = file of venta;

    vector_detalle = array [1..n] of archivo_detalle;
    reg_detalle = array [1..n] of venta;

//___________________________________________________________________________________________________________

procedure leer (var archivo: archivo_detalle; var dato: venta);
begin
    if (not eof(archivo)) then 
        read(archivo, dato)
    else 
        dato.codigoProducto := valorAlto;
end;


procedure minimo(var vectorReg: reg_detalle; var min: venta; var deta: vector_detalle);
var
    i,pos_min: integer;
begin
    min.codigo := valoralto;
    pos_min := 0;
    for i := 1 to n do begin // recorro los n registros
        if (vectorReg[i].codigo <> valoralto) then  // si el registro no es valoralto
            if (vectorReg[i].codigo < min.codigo) then begin // si el codigo del registro es menor al minimo
                min := vectorReg[i]; // asigno el registro al minimo
                pos_min := i; 
            end;
    if (pos_min <> 0) then // si encontre un minimo
        leer(deta[pos_min], vectorReg[pos_min]); // leo el siguiente registro del archivo
    end;
end;

procedure actualizarMaestro(var maestro: archivo_maestro; var vectorReg: reg_detalle; var deta: vector_detalle);
var
    regM: producto;
    min: venta;
    codigoActual,cantidad_vendida:integer;
    montoTotalProducto, montoTotalDia: real;
    i: integer;
begin
    reset(maestro);
    for i := 1 to n do begin
        reset(deta[i]);
        leer(deta[i], vectorReg[i]); // leo el primer registro de los 5 archivos y lo escribo en el array de registros
    end;
    minimo(vectorReg, min, deta);
    montoTotalDia := 0;
    while (min.codigo <> valorAlto) do begin
        cant_vendida := 0;
        montoTotalProducto := 0;
        codigoActual := min.codigo;
        while (codigoActual = min.codigo) do begin
                cant_vendida += min.cantidad;
                minimo(vectorReg, min, deta);
        end;
        read(maestro, regM);
        while (regM.codigo <> codigoActual) do begin
            writeln('El producto ', regM.codigo, ' dispone de unidades en existencia y no han sido vendidas');
            read(maestro, regM);
        end;
        if (regM.cantidad-cant_vendida > 0) then
            regm.cantidad -= cant_vendida
        else
            regM.cantidad := 0;
        if (regM.cantidad < regM.stockMinimo) then
            writeln('El producto ', regM.codigo, ' vendido quedo por debajo del stock minimo');
        montoTotalProducto := regM.precioVenta * cant_vendida;
        montoTotalDia += montoTotalProducto;
        writeln('El producto ', regM.codigo, 'descripcion: ', regM.descripcion, 'fue vendido por un monto de: ', montoTotalProducto:2:2);
        seek(maestro, filepos(maestro)-1);
        writeln(maestro, regM);
    end;
    writeln('El monto total facturado en el dia es: ', montoTotalDia:2:2);
     for i := 1 to n do // cierro los archivos
        close(deta[i]);
    close(maestro);
end;


//___________________________________________________________________________________________________________
var
    arcMaestro: maestro;
    deta: vector_detalle;
    vectorReg: reg_detalle;
    i: integer;
begin
    assign(arcMaestro, 'maestro');
    for i := 1 to n do
        assign(deta[i], 'detalle'+intToStr(i));
    actualizarMaestro(arcMaestro, vectorReg, deta);
end.