{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
* a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos. --> si hay una diferencia de +5 entre final y cursada.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
* }
program ejer2;

CONST
  valorAlto = 9999;

type
  rango = 0..1;

  alumno = record
    cod: integer;
    apellido: string[50];
    nombre: string[50];
    cantMsin: integer;
    cantMcon: integer;
  end;

  materia = record
    cod: integer;
    fin: rango; // 0 desaprobado, 1 aprobado
    curs: rango; // 0 desaprobado, 1 aprobado
  end;

  maestro = file of alumno;
  detalle = file of materia;

procedure leerDetalle(var arc_detalle: detalle; var dato: materia); // Procedimiento para leer el archivo detalle
begin
  if not eof(arc_detalle) then
    read(arc_detalle, dato)
  else
    dato.cod := valorAlto;
end;

procedure actualizar(var arc_maestro: maestro; var arc_detalle: detalle);
var
  m: materia;
  a: alumno;
  codActual: integer;
  cantC, cantM: integer;
begin
  reset(arc_maestro);
  reset(arc_detalle);
  leerDetalle(arc_detalle, m);

  while (m.cod <> valorAlto) do
  begin
    codActual := m.cod;
    cantC := 0;
    cantM := 0;

    // Cuenta las materias aprobadas y finales aprobados para el alumno actual
    while (m.cod = codActual) do
    begin
      if (m.curs <> 0) then
        cantC := cantC + 1;
      if (m.fin <> 0) then
        cantM := cantM + 1;
      leerDetalle(arc_detalle, m);
    end;

    // Encuentra y actualiza el registro correspondiente en el archivo maestro
    read(arc_maestro, a);
    while (a.cod <> codActual) do
      read(arc_maestro, a);

    a.cantMsin := a.cantMsin + cantC;
    a.cantMcon := a.cantMcon + cantM;

    // Escribe el registro actualizado en el archivo maestro
    seek(arc_maestro, filePos(arc_maestro) - 1); // Retrocede un registro para sobreescribir el actual
    write(arc_maestro, a); // Sobreescribe el registro actualizado
  end;

  close(arc_maestro);
  close(arc_detalle);
end;


procedure pasarATxt(var arc_maestro: maestro; var arcTxt: Text);
var
  a: alumno;
begin
  reset(arc_maestro);
  rewrite(arcTxt);

  while not eof(arc_maestro) do
  begin
    read(arc_maestro, a);
    if (a.cantMsin - a.cantMcon > 4) then
    begin
      writeln(arcTxt, a.cod, ' ', a.apellido, ' ', a.nombre, ' ', a.cantMsin, ' ', a.cantMcon);
    end;
  end;

  close(arc_maestro);
  close(arcTxt);
end;

var
  arc_maestro: maestro;
  arc_detalle: detalle;
  arcTxt: Text;
begin
  Assign(arc_maestro, 'maestro.dat');
  Assign(arc_detalle, 'detalle.dat');
  Assign(arcTxt, 'alumnos.txt');

  // Crear archivo maestro y detalle con datos de ejemplo
  // crearMaestro(arc_maestro);
  // crearDetalle(arc_detalle);

  // Mostrar contenido inicial de los archivos
  // mostrarMaestro(arc_maestro);
  // mostrarDetalle(arc_detalle);

  // Actualizar archivo maestro
  actualizar(arc_maestro, arc_detalle);

  // Mostrar contenido actualizado del archivo maestro
  // mostrarMaestro(arc_maestro);

  // Pasar a archivo de texto los alumnos con más de 4 materias cursadas y menos finales aprobados
  pasarATxt(arc_maestro, arcTxt);
end.
