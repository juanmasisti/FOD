program parcial;
const
	df = 30;valorAlto = 999;
type

	municipalidad = record
		codigo: integer;
		nombre: string[20];
		positivos: integer;
	end;
	
	reg_det = record
		codigo : integer;
		positivos: integer;
	end;
	
	detail = file of reg_det;
	master = file of municipalidad;
	v_detalles = array[1..df] of detail;
	v_actuales = array[1..df] of reg_det;
	
procedure leer(var detalle:detail;var dato:reg_det);
begin
	if(not eof(detalle))then
		read(detalle,dato)
	else
		dato.codigo := valorAlto;
end;

procedure leer_maestro(var maestro:master;dato:municipalidad);
begin
	if(not eof(maestro))then
		read(maestro,dato)
	else
		dato.codigo:= valorAlto;
end;

procedure minimo (var detalles:v_detalles;var act:v_actuales;var min:reg_det);
var
	i,pos: integer;
begin
	min.codigo:= valorAlto;
	for i:= 1 to df do
		if(act[i].codigo < min.codigo)then begin
			min:= act[i];
			pos:= i;
		end;
	if(min.codigo <> valorAlto)then
		leer(detalles[pos],act[pos])
end;

procedure actualizarMaestro(var m:master;var detalles:v_detalles);
var
	i,aux,acu:integer;min:reg_det;act:v_actuales;reg_maestro:municipalidad;
begin
	reset(m);
	for i:= 1 to df do begin
		reset(detalles[i]);
		read(detalles[i],act[i]);
	end;
	minimo(detalles,act,min);
	while(min.codigo <> valorAlto)do begin
		acu:= 0;
		aux:= min.codigo;
		while((min.codigo = aux)and(min.codigo <> valorAlto))do begin
			acu:= acu + min.positivos;
			minimo(detalles,act,min);
		end;
		leer_maestro(m,reg_maestro);
		while(reg_maestro.codigo <> aux)do begin
			if(reg_maestro.positivos > 15)then begin
				writeln(reg_maestro.nombre);
				writeln(reg_maestro.codigo);
			end;
			leer_maestro(m,reg_maestro);
		end;
		reg_maestro.positivos:= reg_maestro.positivos + acu;
		if(reg_maestro.positivos > 15)then begin
			writeln(reg_maestro.nombre);
			writeln(reg_maestro.codigo);
		end;
		seek(m,filepos(m)-1);
		write(m,reg_maestro);
	end;
	close(m);
	for i:=1 to df do
		close(detalles[i]);
end;

var
	m:master;detalles:v_detalles;nom:string;i:integer;
begin
	write('Ingresar nombre de maestro :');
	readln(nom);
	assign(m,nom);
	for i:=1 to df do begin
		write('Ingresar nombre del archivo detalle ',i);
		readln(nom);
		assign(detalles[i],nom);
	end;
	actualizarMaestro(m,detalles);
end.