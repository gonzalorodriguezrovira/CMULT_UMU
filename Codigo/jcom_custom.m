function RC=jcom_custom(fname,caliQ)
% Comprime una imagen BMP, usando tablas Huffman custom. 

% Entradas
%   fname: Imagen a comprimir.
%   caliQ: Factor de calidad. 
% Salidas
%   RC: Relacion de compresion. 
%   Crea un archivo <fname>.huc con la informacion de la compresion

% Lee archivo de imagen
% Convierte a espacio de color YCbCr
% Amplia dimensiones a multiplos de 8
% X: Matriz original de la imagen en espacio RGB
% Xamp: Matriz ampliada de la imagen en espacio YCbCr
[X, Xamp, tipo, m, n, mamp, namp, TO]=imlee(fname);

% Calcula DCT bidimensional en bloques de 8 x 8 pixeles
Xtrans = imdct(Xamp);

% Cuantizacion de coeficientes
Xlab=quantmat(Xtrans, caliQ);

% Genera un scan por cada componente de color
%  Cada scan es una matriz mamp x namp
%  Cada bloque se reordena en zigzag
XScan=scan(Xlab);

% Codifica los scans, usando Huffman por defecto
[CodedY, CodedCb, CodedCr,BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC, HUFFVAL_Y_AC, BITS_C_DC,HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC] = EncodeScans_custom(XScan);

% Conversion a matrices binarias
[sbytesY, ultlY]=bits2bytes(CodedY);
[sbytesCb, ultlCb]=bits2bytes(CodedCb);
[sbytesCr, ultlCr]=bits2bytes(CodedCr);

% Preparo la informacion para introfucirla en el archivo.
uCaliQ = uint32(caliQ);
uM = uint32(m);
uN = uint32(n);
uMamp = uint32(mamp);
uNamp = uint32(namp);

ulenBITS_Y_DC=uint8(length(BITS_Y_DC)); % Nº de filas de BITS
uBITS_Y_DC=uint8(BITS_Y_DC); % Nº de palabras codigo de cada longitud
ulenHUFFVAL_Y_DC=uint8(length(HUFFVAL_Y_DC));% Nº de filas de HUFFVAL
uHUFFVAL_Y_DC=uint8(HUFFVAL_Y_DC); % Mensajes ordenados por long. de palabra
ulenBITS_Y_AC=uint8(length(BITS_Y_AC)); % Nº de filas de BITS
uBITS_Y_AC=uint8(BITS_Y_AC); % Nº de palabras codigo de cada longitud
ulenHUFFVAL_Y_AC=uint8(length(HUFFVAL_Y_AC));% Nº de filas de HUFFVAL
uHUFFVAL_Y_AC=uint8(HUFFVAL_Y_AC); % Mensajes ordenados por long. de palabra
ulenBITS_C_DC=uint8(length(BITS_C_DC)); % Nº de filas de BITS
uBITS_C_DC=uint8(BITS_C_DC); % Nº de palabras codigo de cada longitud
ulenHUFFVAL_C_DC=uint8(length(HUFFVAL_C_DC));% Nº de filas de HUFFVAL
uHUFFVAL_C_DC=uint8(HUFFVAL_C_DC); % Mensajes ordenados por long. de palabra
ulenBITS_C_AC=uint8(length(BITS_C_AC)); % Nº de filas de BITS
uBITS_C_AC=uint8(BITS_C_AC); % Nº de palabras codigo de cada longitud
ulenHUFFVAL_C_AC=uint8(length(HUFFVAL_C_AC));% Nº de filas de HUFFVAL
uHUFFVAL_C_AC=uint8(HUFFVAL_C_AC); % Mensajes ordenados por long. de palabra

ulensbytesY=uint32(length(sbytesY)); % Longitud de sbytes
uultlY=uint8(ultlY); % Longitud de ultimo segmento de sbytes
usbytesY=sbytesY; % Entrada comprimida y segmentada. Ya esta en uint8.
ulensbytesCb=uint32(length(sbytesCb)); % Longitud de sbytes
uultlCb=uint8(ultlCb); % Longitud de ultimo segmento de sbytes
usbytesCb=sbytesCb; % Entrada comprimida y segmentada. Ya esta en uint8.
ulensbytesCr=uint32(length(sbytesCr)); % Longitud de sbytes
uultlCr=uint8(ultlCr); % Longitud de ultimo segmento de sbytes
usbytesCr=sbytesCr; % Entrada comprimida y segmentada. Ya esta en uint8.

%Creo el archivo para almacenar la informacion
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'.huc');
%Abro el archivo ya creado
fid = fopen(nombrecomp,'w');
%Introduzco la informacion en el archivo
fwrite(fid, uCaliQ, 'uint32');
fwrite(fid, uM, 'uint32');
fwrite(fid, uN, 'uint32');
fwrite(fid, uMamp, 'uint32');
fwrite(fid, uNamp, 'uint32');

fwrite(fid,ulensbytesY,'uint32'); 
fwrite(fid,uultlY,'uint8'); 
fwrite(fid,usbytesY,'uint8'); 
fwrite(fid,ulensbytesCb,'uint32');
disp(numel(fname));
fwrite(fid,uultlCb,'uint8');
fwrite(fid,usbytesCb,'uint8'); 
fwrite(fid,ulensbytesCr,'uint32'); 
fwrite(fid,uultlCr,'uint8'); 
fwrite(fid,usbytesCr,'uint8');

fwrite(fid,ulenBITS_Y_DC,'uint8'); % Nº de filas de BITS
fwrite(fid,uBITS_Y_DC,'uint8'); % Nº de palabras codigo de cada longitud
fwrite(fid,ulenHUFFVAL_Y_DC,'uint8'); % Nº de filas de HUFFVAL
fwrite(fid,uHUFFVAL_Y_DC,'uint8'); % Mensajes ordenados por long. de palabra
fwrite(fid,ulenBITS_Y_AC,'uint8'); % Nº de filas de BITS
fwrite(fid,uBITS_Y_AC,'uint8'); % Nº de palabras codigo de cada longitud
fwrite(fid,ulenHUFFVAL_Y_AC,'uint8'); % Nº de filas de HUFFVAL
fwrite(fid,uHUFFVAL_Y_AC,'uint8'); % Mensajes ordenados por long. de palabra
fwrite(fid,ulenBITS_C_DC,'uint8'); % Nº de filas de BITS
fwrite(fid,uBITS_C_DC,'uint8'); % Nº de palabras codigo de cada longitud
fwrite(fid,ulenHUFFVAL_C_DC,'uint8'); % Nº de filas de HUFFVAL
fwrite(fid,uHUFFVAL_C_DC,'uint8'); % Mensajes ordenados por long. de palabra
fwrite(fid,ulenBITS_C_AC,'uint8'); % Nº de filas de BITS
fwrite(fid,uBITS_C_AC,'uint8'); % Nº de palabras codigo de cada longitud
fwrite(fid,ulenHUFFVAL_C_AC,'uint8'); % Nº de filas de HUFFVAL
fwrite(fid,uHUFFVAL_C_AC,'uint8'); % Mensajes ordenados por long. de palabra
%Cierro el archivo

fclose(fid);
% Calculo el RC.
TC=dir(nombrecomp);
TC=TC.bytes;

RC= 100*(TO-TC)/TO; % TASA (rate) de compresión. 

disp("RC:");
disp(RC);

end