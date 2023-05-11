{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

program ej2;

Uses 
crt;

Type 
  string12 = String[12];
  empleados = Record
    numEmp: integer;
    apellido: string12;
    nombre: string12;
    edad: integer;
    DNI: string12;
  End;
  archivos = file Of empleados;

Procedure crearArchivo(Var arcL: archivos);

Var 
  arcF: string12;
  r: empleados;
Begin
  writeln('Ingrese el nombre del archivo: ');
  readln(arcF);
  Assign(arcL, arcF);
  Rewrite(arcL);
  writeln('Ingresar el apellido del Empleado: ');
  readln(r.apellido);
  While (r.apellido <> 'fin') Do
    Begin
      writeln('Ingresar el nombre del Empleado: ');
      readln(r.nombre);
      writeln('Ingresar el numero del Empleado: ');
      readln(r.numEmp);
      writeln('Ingresar la edad del Empleado: ');
      readln(r.edad);
      writeln('Ingresar el DNI del Empleado: ');
      readln(r.DNI);
      write(arcL, r);
      writeln('Ingresar el apellido del Empleado: ');
      readln(r.apellido);
    End;
  close(arcL);
End;

Procedure procesarArchivoI(Var arcL: archivos);

Var 
  str: string12;
  r: empleados;
Begin
  writeln('Ingresar el nombre o apellido del Empleado a mostrar: ');
  readln(str);
  Reset(arcL);
  read(arcL, r);
  While (str <> r.apellido ) And (str <> r.nombre) Do
    Begin
      read(arcL, r);
    End;
  writeln('Num: ', r.numEmp, ' Apellido: ', r.apellido, ' Nombre: ', r.nombre,
          ' Edad: ', r.edad, ' DNI: ', r.DNI);
  writeln('---Presionar Enter para volver---');
  readln();
  close(arcL);
End;


Procedure procesarArchivoII(Var arcL: archivos);

Var 
  r: empleados;
Begin
  Reset(arcL);
  While (Not eof(arcL)) Do
    Begin
      read(arcL, r);
      writeln('Num: ', r.numEmp, ' Apellido: ', r.apellido, ' Nombre: ', r.
              nombre, ' Edad: ', r.edad, ' DNI: ', r.DNI);
    End;
  writeln('---Presionar Enter para volver---');
  readln();
  close(arcL);
End;

Procedure procesarArchivoIII(Var arcL: archivos);

Var 
  r: empleados;
Begin
  Reset(arcL);
  While (Not eof(arcL)) Do
    Begin
      read(arcL, r);
      If (r.edad> 70) Then
        writeln('Num: ', r.numEmp, ' Apellido: ', r.apellido, ' Nombre: ', r.
                nombre, ' Edad: ', r.edad, ' DNI: ', r.DNI);
    End;
  writeln('---Presionar Enter para volver---');
  readln();
  close(arcL);
End;

Var 
  arcL: archivos;
  sal : boolean;
  tec : char;
Begin
  sal := false;
  Repeat
    clrscr;
    writeln('-----Menu General-----');
    writeln;
    writeln('1: Ingresar Archivo');
    writeln('2: Buscar Empleado');
    writeln('3: Mostrar Empleados');
    writeln('4: Mostrar Empleados mayores a 70');
    writeln('5: Cerrar');
    writeln;
    writeln('>>> Elija Opcion <<<');
    Repeat
      tec := readkey;
      If tec In['1','2','3','4','5'] Then
        Begin
        End
      Else
        Begin
          writeln('  Eleccion Erronea pulse una tecla');
          readkey;
        End;
    Until tec In['1','2','3','4','5'];
    clrscr;
    Case tec Of 
      '1' :
            Begin
              crearArchivo(arcL);
            End;
      '2' :
            Begin
              procesarArchivoI(arcL);
            End;
      '3' :
            Begin
              procesarArchivoII(arcL);
            End;
      '4' :
            Begin
              procesarArchivoIII(arcL);
            End;
      '5' : sal := true;
    End;
  Until sal = true;
End.