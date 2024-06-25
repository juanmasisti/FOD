{Una empresa que comercializa fármacos recibe de cada una de sus 30 sucursales un resumen mensual de las ventas
y desea analizar la informacion para la toma de futuras decisiones.
El formato de los archivos que recibe la empresa es: cod_farmaco, nombre, fecha, cantidad_vendida, forma_pago (campo string indicando contado o tarjeta).
Los archivos de ventas estan ordenados por cod_farmaco y fecha.
Cada sucursal puede vender cero, uno o mas veces determinado farmaco el mismo dia y la forma de pago podria variar en cada venta. 
Realizar los siguientes procedimientos:
a) Recibe los 30 archivos de ventas e informa por pantalla el farmaco con mayor cantidad_vendida.
c) Recibe los 30 archivos de ventas y guarda en un archivo de texto un resumen de ventas por fecha y farmaco con el siguiente formato:
cod_farmaco, nombre, fecha, cantidad_total_vendida ( el archivo de texto deberá estar oraganizado de manera tal que al tener que utilizarlo pueda recorrer el 
archivo realizando la menos cantidad de lecturas posibles ). NOTA: en el archivo de texto por fecha, cada farmaco aparecerá a lo sumo una vez. Ademas de escribir
cada procedimiento deberá declarar las estructuras de datos utilizadas. }
program farmacos;

const 
    valoralto = 9999;
    n = 20;

type 
    venta = record
        cod_farmaco:integer;
        nombre:string;
        fecha:string;
        cantidad_vendida:integer;
        forma_pago:string;
    end;

    archivo = file of venta;

    vector_detalle = array [1..n] of archivo;
    reg_detalle = array [1..n] of venta;

procedure leer (var archivo:archivo; var dato:venta);
begin
    if (not eof(archivo)) then
        read(archivo,dato)
    else
        dato.cod_farmaco:=valoralto;
end;

procedure minimo(var vectorReg: reg_detalle; var min: venta; var deta: vector_detalle);
var
    i,pos_min: integer;
begin
    min.cod_farmaco := valoralto;
    pos_min := 0;
    for i := 1 to n do begin // recorro los 5 registros
        if (vectorReg[i].cod_farmaco <> valoralto) then  // si el registro no es valoralto
            if (vectorReg[i].cod_farmaco < min.cod_farmaco) then begin // si el codigo del registro es menor al minimo
                min := vectorReg[i]; // asigno el registro al minimo
                pos_min := i; 
            end;
    if (pos_min <> 0) then // si encontre un minimo
        leer(deta[pos_min], vectorReg[pos_min]); // leo el siguiente registro del archivo
    end;
end;

procedure procesarVentas(var arcTxt: Text;var deta: vector_detalle; var vectorReg: reg_detalle);
var
    min: venta;
    max: venta;
    total_vendido: integer;
    farmaco_actual: integer;
begin
    max := 0;        
    Rewrite(arcTxt);
    for i := 1 to n do begin
        reset(deta[i]); 
        leer(deta[i] , vectorReg[i]);
    end;
    minimo(vectorReg, min, deta);
    while (min.cod_farmaco <> valoralto) do begin
        farmaco_actual := min.cod_farmaco;
        total_vendido := 0;
        while (farmaco_actual = min.cod_farmaco) do begin
            total_vendido := total_vendido + min.cantidad_vendida;
            minimo(vectorReg, min, deta);
        end;
        writeln(arcTxt, 'El farmaco ', min.nombre, 'de codigo', farmaco_actual, ' se vendio ', total_vendido, ' veces', ' el dia ', min.fecha);
        if (total_vendido > max)
            max := total_vendido;
        minimo(vectorReg, min, deta);
    end;
    writeln('El farmaco con mayor cantidad vendida es: ', max);
    close(arcTxt);
    for i := 1 to n do
        close(deta[i]);
end;

// PROGRAMA PRINCIPAL

var
    deta: vector_detalle;
    vectorReg: reg_detalle;
    arcTxt: Text;
begin
    assign(arcTxt, 'farmacos.txt');
    for i := 1 to n do
        Assign(deta[i], 'detalle' + IntToStr(i));
    procesarVentas(arcTxt, deta, vectorReg);
end.