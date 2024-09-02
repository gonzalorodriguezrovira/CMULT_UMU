function TxCompressor(nombre)

[x, lenx] = ReadTextFile(nombre);
% Genera nombre archivo comprimido <name>.huf
[pathstr,name,ext] = fileparts(nombre);
nombrecomp=strcat(name,'.huf');
% Codifica mediante la funcion StCompressor
[scod,BITS,HUFFVAL]=StCompressor(x);
[sbytes, ultl]=bits2bytes(scod);

ulenBITS=uint8(length(BITS)); % N� de filas de BITS
uBITS=uint8(BITS); % N� de palabras codigo de cada longitud
ulenHUFFVAL=uint8(length(HUFFVAL));% N� de filas de HUFFVAL
uHUFFVAL=uint8(HUFFVAL); % Mensajes ordenados por long. de palabra
ulensbytes=uint32(length(sbytes)); % Longitud de sbytes
uultl=uint8(ultl); % Longitud de ultimo segmento de sbytes
usbytes=sbytes; % Entrada comprimida y segmentada. Ya esta en uint8.

fid = fopen(nombrecomp,'w');
fwrite(fid,ulenBITS,'uint8'); % N� de filas de BITS
fwrite(fid,uBITS,'uint8'); % N� de palabras codigo de cada longitud
fwrite(fid,ulenHUFFVAL,'uint8'); % N� de filas de HUFFVAL
fwrite(fid,uHUFFVAL,'uint8'); % Mensajes ordenados por long. de palabra
fwrite(fid,ulensbytes,'uint32'); % % Longitud de sbytes. Ocupa 4 bytes
fwrite(fid,uultl,'uint8'); % Longitud de ultimo segmento de sbytes
fwrite(fid,usbytes,'uint8'); % Mensaje comprimido y segmentado.
fclose(fid);

TO=lenx; % Longitud del fichero original.
 % TCabecera incluye uBITS,ulenBITS,uHUFFVAL,ulenHUFFVAL:
TCabecera=length(BITS)+1+length(HUFFVAL)+1;
 % TDatos incluye ulensbytes,uultlon,usbytes
TDatos=4+1+length(sbytes);
TC=TCabecera+TDatos; % Tama�o del fichero comprimido
 % Mostrar la(s) Relacion(es) de compresi�n.
RCfil= 100*(TO-TC)/TO; % TASA (rate) de compresi�n. 
FCfil=TO/TC;
PCfil=TC/TO*100;

disp('-----------------');
fprintf('%s %s\n', 'Archivo comprimido:', nombrecomp);
fprintf('%s %d %s %d\n', 'Tama�o original =', TO, 'Tama�o comprimido =', TC);
fprintf('%s %d %s %d\n', 'Tama�o cabecera y codigo =', TCabecera, 'Tama�o dato=', TDatos);
fprintf('%s %2.2f %s\n', 'RC archivo =', RCfil, '%.');
if RCfil<0
 disp('El archivo original es demasiado peque�o. No se comprime.');
 fprintf('%s %2.2f %s\n','La cabecera provoca un aumento de tama�o de un ',abs(RCfil), '%.');
 end




