{ A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program e4p2;

CONST 
    valor_alto = 9999;

type
    reg_maestro = record
        nombre_provincia: string;
        cant_alfabetizados: integer;
        total_encuestados: integer;
    end;

    reg_detalle = record
        nombre_provincia: string;
        cod_localidad: integer;
        cant_alfabetizados: integer;
        total_encuestados: integer;
    end;

    archivo_maestro = file of reg_maestro;
    archivo_detalle = file of reg_detalle;

procedure leer(var archivo: archivo_detalle; var registro: reg_detalle);
begin
    if (not eof(archivo)) then
        read(archivo, registro)
    else
        registro.cod_localidad := valor_alto;
end;

procedure minimo(var r1, r2: reg_detalle; var min: reg_detalle; var archivo1, archivo2: archivo_detalle);
begin 
    if (r1.nombre_provincia < r2.nombre_provincia) then
    begin
        min := r1;
        leer(archivo1, r1);
    end
    else
    begin
        min := r2;
        leer(archivo2, r2);
    end;
end;


procedure actualizar_maestro(var archivo_maestro: archivo_maestro; var archivo1, archivo2: archivo_detalle);
var
    r1, r2: reg_detalle;
    m: reg_maestro;
    min: reg_detalle;
    provActual: string;
begin
    reset(archivo1);
    reset(archivo2);
    reset(archivo_maestro);
    leer(archivo1, r1);
    leer(archivo2, r2);
    minimo(r1, r2, min, archivo1, archivo2);
    while (min.cod_localidad <> valor_alto) do
    begin
        provActual := min.nombre_provincia;

        // Leer el registro del archivo maestro correspondiente a la provincia actual
        read(archivo_maestro, m);
        while (m.nombre_provincia <> provActual) do
            read(archivo_maestro, m);

        // Procesar todos los registros de detalle para la provincia actual
        while (provActual = min.nombre_provincia) do
        begin
            m.cant_alfabetizados := m.cant_alfabetizados + min.cant_alfabetizados;
            m.total_encuestados := m.total_encuestados + min.total_encuestados;
            minimo(r1, r2, min, archivo1, archivo2);
        end;

        // Guardar el registro actualizado en el archivo maestro
        seek(archivo_maestro, filepos(archivo_maestro) - 1);
        write(archivo_maestro, m);
    end;
    close(archivo1);
    close(archivo2);
    close(archivo_maestro);
end;

var
    archivo_maestro: archivo_maestro;
    archivo1, archivo2: archivo_detalle;
begin
    assign(archivo_maestro, 'maestro');
    assign(archivo1, 'detalle1');
    assign(archivo2, 'detalle2');
    actualizar_maestro(archivo_maestro, archivo1, archivo2);
end.
    

