
Program ejemplo;

Uses 
crt;

Type 
  string30 = String[30];
  celulares = Record
    codigo: integer;
    nombre: string30;
    descripcion: string30;
    marca: string30;
    precio: real;
    stockM: integer;
    stockD: integer;
  End;
  archivos = file Of celulares;

Procedure leerRegsitro(Var r: celulares);
Begin
  writeln('Ingresar el codigo del celular: ');
  readln(r.codigo);
  writeln('Ingresar el nombre del celular: ');
  readln(r.nombre);
  writeln('Ingresar la descripcion del celular: ');
  readln(r.descripcion);
  writeln('Ingresar la marca del celular: ');
  readln(r.marca);
  writeln('Ingresar el precio del celular: ');
  readln(r.precio);
  writeln('Ingresar el stock minimo del celular: ');
  readln(r.stockM);
  writeln('Ingresar el stock disponible del celular: ');
  readln(r.stockD);
End;

Procedure procesarArchivoI(Var arcL2: archivos);

Var 
  arcL: text;
  r: celulares;
  nom: string30;
Begin
  Assign(arcL, 'celulares.txt');    // Asigna archivo de texto 
  writeln('Ingresar el nombre del archivo: ');
  readln(nom);
  Assign(arcL2, nom);   // Asigna archivo binario 
  Reset(arcL);
  Rewrite(arcL2);   // Crea archivo binario 
  While (Not eof(arcL)) Do
    Begin
      readln(arcL, r.codigo, r.precio, r.marca);
      readln(arcL, r.stockD, r.stockM, r.descripcion);    // Lee datos archivo de texto
      readln(arcL, r.nombre);     
      write(arcL2, r);        // Los carga en el archivo binario 
    End;
  writeln('*Operacion realizada con exito');
  writeln('---Presionar Enter para volver---');
  readln();
  Close(arcL);
  Close(arcL2);
End;


Procedure procesarArchivoII(Var arcL: archivos);

Var 
  r: celulares;
Begin
  Reset(arcL);
  While (Not eof(arcL)) Do
    Begin
      read(arcL, r);    // Lee el registro, avanza al siguiente 
      If (r.stockD < r.stockM) Then
        Begin
          writeln('Codigo:  ', r.codigo);
          writeln('Nombre: ', r.nombre);
          writeln('Descripcion: ', r.descripcion);
          writeln('Marca: ', r.marca);
          writeln('Precio: ', r.precio:2:2);
          writeln('Stock disponible: ', r.stockD);
          writeln('Stock minimo: ', r.stockM);
        End;
    End;
  writeln('---Presionar Enter para volver---');
  readln();
  close(arcL);
End;

Procedure procesarArchivoIII(Var arcL: archivos);

Var 
  r: celulares;
  desc: string30;
Begin
  Reset(arcL);
  writeln('Ingresar la descripcion a buscar: ');
  readln(desc);
  While (Not eof(arcL)) Do
    Begin
      Read(arcL, r);
      If (Pos(desc, r.descripcion) <> 0) Then   // Si la descripcion ingresada por el usuario se encuentra dentro de la descripcion del celular
        Begin
          writeln('Codigo:  ', r.codigo);
          writeln('Nombre: ', r.nombre);
          writeln('Descripcion: ', r.descripcion);
          writeln('Marca: ', r.marca);
          writeln('Precio: ', r.precio:2:2);
          writeln('Stock disponible: ', r.stockD);
          writeln('Stock minimo: ', r.stockM);
        End;
    End;
  writeln('---Presionar Enter para volver---');
  readln();
  close(arcL);
End;

Procedure procesarArchivoIV(Var arcL2: archivos);

Var 
  arcL: text;
  r: celulares;
Begin
  Assign(arcL, 'celulares.txt');
  Rewrite(arcL);        // Crea archivo de texto
  Reset(arcL2);     // Abre archivo binario 
  While (Not eof(arcL2)) Do
    Begin
      read(arcL2, r);   // Lee el registro del archivo binario 
      writeln(arcL, r.codigo, ' ', r.precio:2:2, r.marca);
      writeln(arcL, r.stockD, ' ', r.stockM, r.descripcion);    // Carga los celulares en el archivo de texto
      writeln(arcL, r.nombre);
    End;
  writeln('*Operacion realizada con exito');
  writeln('---Presionar Enter para volver---');
  readln();
  Close(arcL);
  Close(arcL2);
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
    writeln('1: Cargar datos desde txt');
    writeln('2: Listado de Stock deficiente');
    writeln('3: Listado de busqueda por descripcion');
    writeln('4: Exportar a TXT');
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
          writeln('Eleccion Erronea pulse una tecla');
          readkey;
        End;
    Until tec In['1','2','3','4','5'];
    clrscr;
    Case tec Of 
      '1' :
            Begin
              procesarArchivoI(arcL);
            End;
      '2' :
            Begin
              procesarArchivoII(arcL);
            End;
      '3' :
            Begin
              procesarArchivoIII(arcL);
            End;
      '4' :
            Begin
              procesarArchivoIV(arcL);
            End;
      '5' : sal := true;
    End;
  Until sal = true;
End.
