function RC=jcom_dflt(fname,caliQ)
% Comprime una imagen BMP. 

% Entradas
%   fname: Imagen a comprimir.
%   caliQ: Factor de calidad. 
% Salidas
%   RC: Relacion de compresion. 
%   Crea un archivo <fname>.hud con la informacion de la compresion

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

% Codifica los tres scans, con Huffman por defecto
[CodedY,CodedCb,CodedCr]=EncodeScans_dflt(XScan); 

% Creo el archivo para almacenar la informacion
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'.hud');

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

ulensbytesY=uint32(length(sbytesY)); 
uultlY=uint8(ultlY); 
usbytesY=sbytesY; 
ulensbytesCb=uint32(length(sbytesCb)); 
uultlCb=uint8(ultlCb); 
usbytesCb=sbytesCb; 
ulensbytesCr=uint32(length(sbytesCr)); 
uultlCr=uint8(ultlCr); 
usbytesCr=sbytesCr; 

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
fwrite(fid,uultlCb,'uint8');
fwrite(fid,usbytesCb,'uint8'); 
fwrite(fid,ulensbytesCr,'uint32'); 
fwrite(fid,uultlCr,'uint8'); 
fwrite(fid,usbytesCr,'uint8');

%Cierro el archivo
fclose(fid);

% Calculo el RC.
TC=dir(nombrecomp);
TC=TC.bytes;

RC= 100*(TO-TC)/TO; % TASA (rate) de compresión. 

disp("RC");
disp(RC);

end