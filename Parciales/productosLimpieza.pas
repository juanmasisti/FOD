{Una empresa de productos de limpieza posee un archivo conteniendo informacion sobre los productos que tiene a la venta al público. 
De cada procucto se registra: código de producto, precio, stock actual y stock mínimo. Diaramente se efectuan envios a cada uno de las 2 sucursales que posee. 
Para esto, cada sucursal envía un archivo con los pedidos de los procutos que necesita cada sucursal. Cada pedido contiene código de producto, fecha y cantidad pedida. 
Se pide realizar el proceso de actualización del archivo maestro con los dos archivos detalle, obteniendo un informe en pantalla de aquellos productos que quedaron debajo del stock 
mínimo y de aquellos pedidos que no pudieron satisfacerse totalmente, informando:
la sucursal, el producto y la cantidad que no pudo ser enviada (diferencia entre lo que pidió y lo que se tiene en stock)}

program Parcial_Heguiabehere_Nicolas;

// supongo que los assign se hicieron en el programa principal

const valoralto = 9999;
type
    producto = record
        cod:integer;
        precio:real;
        stock:integer;
        s_min:integer;
    end;
    pedido = record
        cod:integer;
        fecha:string;
        cant:integer;
    end;
    detalle = file of pedido;
    maestro = file of producto;

procedure leer(var det:detalle; var regdet:pedido);
begin
    if(not eof(det))
        then read(det,regdet)
        else regdet.cod:= valoralto;
end;

{ Obs: es buena práctica realizar la operación de mínimo para n archivos }
procedure minimo(var rmin:pedido; var regd1:pedido; var regd2:pedido; var det1:detalle; var det2:detalle; var suc:integer);
begin
    if(regd1.cod <= regd2.cod) then begin
        rmin:=regd1;
        leer(det1,regd1); // Avanzo para despues al llamar a minimo este posicionado sobre la venta siguiente 
        suc:=1;
    end
    else begin
        rmin:=regd2;
        leer(det2,regd2); // Avanzo para despues al llamar a minimo este posicionado sobre la venta siguiente 
        suc:=2;
    end;
end;

procedure actualizarStock(var regm:producto; rmin:pedido; var cantnoenviada:integer);
begin
    regm.stock := regm.stock - rmin.cant;
    if(regm.stock < 0) then begin
        cantnoenviada := - regm.stock;
        regm.stock := 0;
    end;
end;

procedure actualizarMaestro(var mae:maestro; var det1:detalle; var det2:detalle);
var
    rmin,regd1,regd2:pedido;
    regm:producto;
    cantnoenviada, suc:integer;
begin
    reset(mae);
    reset(det1); reset(det2);

    leer(det1, regd1); leer(det2, regd2);
    minimo(rmin,regd1,regd2,det1,det2,suc);
    read(mae,regm);

    while(rmin.cod <> valoralto) do begin
        while(regm.cod <> rmin.cod) do 
            read(mae,regm); //Avanza en el maestro hasta posicionarse en el mismo Codigo de producto del archivo detalle.
        while(regm.cod = rmin.cod) do begin // Puede haber varias ventas de un mismo producto
            cantnoenviada := 0;
            actualizarStock(regm,rmin,cantnoenviada);
            if(cantnoenviada > 0) then begin
                writeln('El pedido no pudo satisfacerse totalmente. Sucursal: ',suc,' - Producto: ',rmin.cod,' - Cantidad no enviada: ',cantnoenviada);
            end;
            minimo(rmin,regd1,regd2,det1,det2,suc);
        end;
        seek(mae,(filepos(mae)-1)); // Me posiciono en el producto procesado
        write(mae,< ); // Actualizo datos
        if(regm.stock < regm.s_min) then writeln('El producto ',regm.cod,' quedo debajo del stock minimo.');
    end;
    close(det1); close(det2);
    close(mae);
end;