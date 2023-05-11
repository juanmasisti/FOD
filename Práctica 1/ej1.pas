{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}

program ej1;

type 

archivo = file of integer;

Procedure Recorrido(var arc_logico: archivo );
var nro: integer; { para leer elemento del archivo}
begin
    reset( arc_logico ); {archivo ya creado, para operar debe abrirse como de lect/escr}
    while not eof( arc_logico) do begin
        read( arc_logico, nro ); {se obtiene elemento desde archivo }
        write( nro ); {se presenta cada valor en pantalla}
    end;
    close( arc_logico );
end;

var
arch_logico : archivo;
arch_fisico : string[12];
nro: integer;

begin
    writeln( 'Ingrese el nombre del archivo:' );
    readln(arch_fisico);
    assign(arch_logico, arch_fisico);
    rewrite(arch_logico);
    writeln('Ingrese un numero');
    readln(nro);
    while (nro <> 3000) do begin
        write(arch_logico,nro);
        writeln('Ingrese un numero');
        readln(nro);
    end;
    close(arch_logico);
    Recorrido(arch_logico);
end.
