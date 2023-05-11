{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}

program ej2;

type 

archivo = file of integer;
var 
arcL: archivo;
arcF : string[12];
promCant: integer;
promSum: integer;
cantNum: integer;
num: integer;

begin
  promCant := 0;
  promSum := 0;
  cantNum := 0;
  writeln('Ingrese nombre del archivo a procesar');
  readln(arcF);
  Assign(arcL,arcF);
  Reset(arcL);
  writeln('Contenido del archivo: ');
  while (not eof(arcL)) do begin
    read(arcL,num);
    writeln(num);
    if (num < 1500) Then
        cantNum:= cantNum + 1;
    promCant:= promCant + 1;
    promSum:= promSum + num;
  end;
  writeln('Cantidad de numeros menores a 1500: ', cantNum);
  writeln('Promedio de numeros: ', promSum/promCant:2:0);
end.