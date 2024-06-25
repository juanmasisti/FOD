{ Una federacion de competidores de running organiza distintas carreras al mes. Cada carrera cuenta
con DNI de corredor, apellido, nombre, kms que corrió y si gano o no la carrera (valor 1 indica que ganó, y calor 0 indica que no ganó la carrera)

Puede haber distintas cantidades de carreras en el mes. Para el mes de abril se organizaron 5 carreras.

Escriba en el programa principal con la declaracion de tipos necesaria y realice un proceso que reciba los 5 archivos y genere el archivo maestro
con la siguiente informacion: DNI, apellido, nombre, kms totales y carreras ganadas.

Todos los archivos se encuentran ordenados por DNI del corredor. Cada persona puede haber
corrido una o más carreras.
}

program competidores;
const 
    valorAlto = 9999;
type
    carrera = record
        DNI: integer;
        apellido: string;
        nombre: string;
        kms: real;
        gano: 0..1;
    end;

    maestro = record
        DNI: integer;
        apellido: string;
        nombre: string;
        kmsTotales: real;
        carrerasGanadas: integer;
    end;

    archivo_detalle = file of carrera;
    archivo_maestro = file of maestro;

    reg_detalle = array [1..5] of carrera;      
    vector_detalle = array [1..5] of archivo_detalle;

procedure leer(var archivo: archivo_detalle; var dato: carrera);
begin
    if (not eof(archivo)) then
        read(archivo, dato)
    else
        dato.DNI := valorAlto;
end;

procedure minimo(var vectorReg: reg_detalle; var min: carrera; var deta: vector_detalle);
var
    i,pos_min: integer;
begin
    min.dni := valoralto;
    pos_min := 0;
    for i := 1 to 5 do begin
        if (vectorReg[i].dni <> valoralto) then 
            if (vectorReg[i].dni < min.dni) then begin
                min := vectorReg[i];
                pos_min := i;
            end;
    if (pos_min <> 0) then
        leer(deta[pos_min], vectorReg[pos_min]);
    end;
end;

procedure actualizar (var maestro:archivo_maestro; var vectorD:vector_detalle; var registro:reg_detalle);
var
    regm: maestro;
    min: carrera;
    i: integer;
    kms_totales: real;
    cant_ganadas: integer;
    dni_actual: integer;
begin
    Rewrite(maestro);
    for i := 1 to 5 do begin
        reset (vectorD[i]);
		leer (vectorD[i],registro[i]); //leo el primer registro de los 5 archivos y lo escribo en el array de registros
		writeln (registro[i].dni);
    end;
	minimo (registro,min,vectorD); //obtengo minimo
    while (min.dni <> valorAlto) do begin
        dni_actual := min.dni;
        kms_totales := 0;
        cant_ganadas := 0;
        while (dni_actual = min.dni) do begin
            kms_totales = kms_totales + min.kms;
            if (min.gano = 1) then
                cant_ganadas := cant_ganadas + 1;
	        minimo (vectorD,min,registro); //obtengo minimo
        end;
        writeln (maestro, dni_actual, min.apellido, min.nombre, kms_totales, cant_ganadas);
    end;
    close(maestro);
    for i := 1 to 5 do
        close(vectorD[i]);
end;

var
    maestro: archivo_maestro;
    vectorD: vector_detalle;
    registro: reg_detalle;
    i: integer;
begin
    Assign (maestro,'maestro');
    for i := 1 to 5 do begin
        Assign(vector[i], 'detalle' + IntToStr(i));
    end;
    Rewrite (maestro);
	actualizar (arc_maestro,deta,registro);
end.        
        


