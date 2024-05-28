{ Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log } 

program e6p2;
const
    valoralto = 9999;
type
    reg_detalle = record
        cod_usuario: integer;
        fecha: string;
        tiempo_sesion: integer;
    end;
    
    reg_maestro = record
        cod_usuario: integer;
        fecha: string;
        tiempo_total_de_sesiones_abiertas: integer;
    end;

    maestro = file of reg_maestro;
    detalle = file of reg_detalle;
    ar_detalle = array [1..5] of detalle;

procedure leer (var archivo: detalle; var dato: reg_detalle);
begin
    if (not eof(archivo)) then
        read(archivo, dato)
    else
        dato.cod_usuario := valoralto;
end;

procedure minimo(var regs_detalle: array of reg_detalle; var min: reg_detalle; var archivos_detalle: ar_detalle);
var
    i, indice_min: integer;
begin
    min := regs_detalle[1]; // Asignamos el primer registro de detalle como mínimo inicial
    indice_min := 1;

    // Buscamos el mínimo entre todos los registros de detalle
    for i := 2 to 5 do
    begin
        if (regs_detalle[i].cod_usuario < min.cod_usuario) then
        begin
            min := regs_detalle[i];
            indice_min := i;
        end;
    end;

    // Leemos el próximo registro del archivo de detalle donde se encontró el mínimo
    leer(archivos_detalle[indice_min], regs_detalle[indice_min]);
end;


procedure generarArchivoMaestro(var archivos_detalle: ar_detalle; var archivo_maestro: maestro);
var
    registros_detalle: array[1..5] of reg_detalle;
    registro_maestro, min: reg_maestro;
    total_tiempo: integer;
    i: integer;
    cod_usuario_actual: integer;
begin
    // Inicializamos los registros de detalle
    for i := 1 to 5 do
        leer(archivos_detalle[i], registros_detalle[i]);


    // sacamos el minimo de los registros de detalle
    minimo(registros_detalle, min, archivos_detalle);

    // Generar el archivo maestro
    while (min.cod_usuario <> valoralto) do
    begin
        // Procesar todas las sesiones abiertas para el usuario actual
        total_tiempo := 0;
        cod_usuario_actual := min.cod_usuario;
        while (min.cod_usuario = cod_usuario_actual) do
        begin
            total_tiempo := total_tiempo + min.tiempo_sesion;
            minimo(registros_detalle, min, archivos_detalle);
        end;

        // Actualizar el registro maestro
        registro_maestro.cod_usuario := min.cod_usuario;
        registro_maestro.fecha := min.fecha;
        registro_maestro.tiempo_total_de_sesiones_abiertas := total_tiempo;

        // Escribir el registro maestro en el archivo maestro
        write(archivo_maestro, registro_maestro);
    end;

    // Cerrar el archivo maestro
    close(archivo_maestro);
end;


var
    archivos_detalle: ar_detalle;
    archivo_maestro: maestro;
    i: integer;
begin
    // Abrir los archivos detalle
    for i := 1 to 5 do
        assign(archivos_detalle[i], 'detalle' + IntToStr(i) + '.dat');

    // Abrir el archivo maestro
    assign(archivo_maestro, '/var/log/maestro.dat');
    rewrite(archivo_maestro);

    // Llamar al procedimiento para generar el archivo maestro
    generarArchivoMaestro(archivos_detalle, archivo_maestro);
end.