{Una empresa dedicada a la venta de golosinas posee un archivo que contiene informacion sobre los productos que tiene a la venta. 
De cada producto se registran los siguientes datos: codigo de producto, nombre comercial, precio de venta, stock actual y estock minimo.
La empresa cuenta con 20 sucursales. Diariamente se recibe un archivo detalle de cada una de las 20 sucursales de la empresa que indica las ventas diarias efectuadas por cada sucursal.
De cada venta se registra codigo de producto y cantidad vendida. 
Se debe realizar un procedimiento que actualice el stock en el archivo maestro con la informacion disponible en los archivos detalles y que ademas informe en un 
archivo de texto aquellos productos cuyo monto total vendido
en el día supere a los $10.000. En el archivo de texto a exportar, por cada producto incluido, se deben informar todos sus datos. 

Los datos de un producto se deben organizar en el archivo de texto para facilitar el uso eventual del mismo como un archivo de carga
El objetivo del ejercio es escribir el procedimiento solicitado, junto con las estructuras de datos y modulos usados en el mismo.

Notas:
Todos los archivos se encuentran ordenados por codigo de producto.
En un archivo detalle puede haber 0,1 o N registros de un producto determinado.
Cada archivo detalle solo contiene productos que seguro existen en el maestro.
Los archivos se deben recorrer una sola vez. En el mismo recorrido, se debe realizar la actualzacion del archivo maestro con los detalles, asi como la generacion del archivo de texto.}

program parcialfecha3;

const 
    valoralto = 9999;
    n = 20;
type 
    producto = record 
        codigo: integer;
        nombre: string;
        precio: real;
        stock: integer;
        stockmin: integer;
    end;

    venta = record
        codigo: integer;
        cantidad: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

    vector_detalle = array [1..n] of detalle; // vector de archivos detalle
    reg_detalle = array [1..n] of venta; // vector de registros de detalle

procedure leer (var archivo: detalle; var dato: venta);
begin
    if (not eof(archivo)) then 
        read(archivo, dato)
    else 
        dato.codigo := valoralto;
end;

procedure minimo(var vectorReg: reg_detalle; var min: venta; var deta: vector_detalle);
var
    i,pos_min: integer;
begin
    min.codigo := valoralto;
    pos_min := 0;
    for i := 1 to n do begin // recorro los 5 registros
        if (vectorReg[i].codigo <> valoralto) then  // si el registro no es valoralto
            if (vectorReg[i].codigo < min.codigo) then begin // si el codigo del registro es menor al minimo
                min := vectorReg[i]; // asigno el registro al minimo
                pos_min := i; 
            end;
    if (pos_min <> 0) then // si encontre un minimo
        leer(deta[pos_min], vectorReg[pos_min]); // leo el siguiente registro del archivo
    end;
end;

procedure actualizarMaestro(var arcTxt: Text; var maestro: maestro; var vectorReg: reg_detalle; var deta: vector_detalle);
var
    regm: producto;
    min: venta;
    i: integer;
    cantVendida: integer;
    codigoActual: integer;
    montoVendido: real;
begin
    reset(maestro);
    Rewrite(arcTxt);
    for i := 1 to n do begin
        reset(deta[i]);
        leer(deta[i], vectorReg[i]); // leo el primer registro de los 5 archivos y lo escribo en el array de registros
    end;
    minimo(vectorReg, min, deta); //  busco el minimo de los 5 registros
    while (min.codigo <> valoralto) do begin
        codigoActual := min.codigo;
        cantVendida := 0;
        montoVendido := 0;
        while (min.codigo = codigoActual) do begin
            cantVendida += min.cantidad;
            minimo(vectorReg, min, deta);
        end;
        read(maestro, regm); // leo el registro del maestro
        while (regm.codigo <> codigoActual) do  // busco el registro que coincida con el codigo actual
            read(maestro, regm);
        regm.stock -= cantVendida; // actualizo el stock
        montoVendido += cant_vendida * regm.precio;        
        seek(maestro, filepos(maestro) - 1); // retrocedo el puntero
        writeln(maestro, regm);
        if (montoVendido > 10000) then  // si el monto vendido supera los 10000 lo escribo en el archivo de texto
            writeln(arcTxt, 'Codigo: ', regm.codigo, ' Nombre: ', regm.nombre, ' Precio: ', regm.precio, ' Stock: ', regm.stock, ' Stock minimo: ', regm.stockmin);
    end;

    for i := 1 to n do // cierro los archivos
        close(deta[i]);
    close(maestro);
    close(arcTxt);
end;

//  PP
var
    arcMaestro: maestro;
    arcTxt: Text;
    deta: vector_detalle;
    vectorReg: reg_detalle;
    i: integer;
begin
    assign(arcMaestro, 'maestro');
    assign(arcTxt, 'archivoTexto.txt');
    for i := 1 to n do
        Assign(deta[i], 'detalle' + IntToStr(i));
    actualizarMaestro(arcTxt, arcMaestro, vectorReg, deta);
end.