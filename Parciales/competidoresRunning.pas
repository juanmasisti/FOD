{ Una federacion de competidores de running organiza distintas carreras al mes. Cada carrera cuenta
con DNI de corredor, apellido, nombre, kms que corrió y si gano o no la carrera (valor 1 indica que ganó, y calor 0 indica que no ganó la carrera)

Puede haber distintas cantidades de carreras en el mes. Para el mes de abril se organizaron 5 carreras.

Escriba en el programa principal con la declaracion de tipos necesaria y realice un proceso que reciba los 5 archivos y genere el archivo maestro
con la siguiente informacion: DNI, apellido, nombre, kms totales y carreras ganadas.

Todos los archivos se encuentran ordenados por DNI del corredor. Cada persona puede haber
corrido una o más carreras.
}

program competidores;

const valoralto = 9999;

type
    carrera = record
        dni: integer;
        apellido: string;
        nombre: string;
        kms: real;
        gano: boolean;
    end;

    maestro = record
        dni: integer;
        apellido: string;
        nombre: string;
        kms_totales: real;
        carreras_ganadas: integer;
    end;

    archivo_detalle = file of carrera;
    archivo_maestro = file of maestro;

    reg_detalle = array [1..5] of carrera;
    vector_detalle = array[1..5] of archivo_detalle;

procedure leer(var archivo: archivo_detalle; var dato: carrera);
begin
    if (not eof(archivo)) then
        read(archivo, dato)
    else
        dato.dni := valoralto;
end;

procedure minimo(var vector: vector_detalle; var min: carrera; var deta: reg_detalle);
var
    i,pos_min: integer;
begin
    min.dni := valoralto;
    pos_min := 0;
    for i := 1 to 5 do 
        if (vector[i].dni <> valoralto) then 
            if (vector[i].dni < min.dni) then begin
                min := vector[i];
                pos_min := i;
            end;
    if (pos_min <> 0) then
        leer(deta[pos_min], vector[pos_min]);
    end;
end;

procedure actualizar (var maestro:archivo_maestro; var deta:archivo_detalle; var registro:reg_detalle);
var
min: carrera;
i:integer;
m:maestro;
kms_totales:real;
dniActual:integer;
begin
	reset (maestro);
	for i:=1 to n do begin
		reset (deta[i]);
		leer (deta[i],registro[i]); //leo el primer registro de los 5 archivos y lo escribo en el array de registros
		writeln (registro[i].dni);
	end;
	minimo (registro,min,deta); //obtengo minimo
	while (min.dni <> valorAlto) do begin  //mientras ese minimo sea distinto a valor alto
		dniActual:= min.dni; 
		kms_totales:= 0;
		while (min.dni = dniActual) do begin //mientras el minimo sea el dni actual
			kms_totales:= kms_totales + min.kms;  //voy sumando los kms
			minimo (registro,min,deta); //busco otro minimo, si es el mismo el dni va a seguir siendo el mismo al actual y se van a ir sumando
		end;
		read (maestro,m);
		while(m.dni <> dniActual)do begin  //busco el dni de maestro para que coincida con el minimo
			read (maestro,m);
		end;
		seek (maestro,filePos (maestro)-1); //ubico puntero
		write (maestro,m); //actualizo maestro
	end;
	for i:=1 to n do
		close (deta[i]);
	close (maestro);
end;

var
    deta: reg_detalle;
    vector: vector_detalle;
    maestro: archivo_maestro;
    i: integer;
    min: carrera;
begin
	Assign (maestro,'maestro');
    Rewrite (maestro);
	actualizar (arc_maestro,deta,registro);
end.    



