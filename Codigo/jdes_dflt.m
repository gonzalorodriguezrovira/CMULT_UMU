function [MSE,RC]=jdes_dflt(fname)
% Descomprime archivos .hud

% Entradas
%   fname: Srchivo que contiene la informacion de una imagen comprimida.
% Salidas
%   RC: Relacion de compresion.
%   MSE: Error cuadratico medio.
%   Genera de nuevo la imagen fname._des_def.bmp

% Abro el archivo
fid = fopen(fname, 'r');

% Leo la informacion del archivo
caliQ = double(fread(fid,1,'uint32'));
m = double(fread(fid,1,'uint32'));
n = double(fread(fid,1,'uint32'));
mamp = double(fread(fid,1,'uint32'));
namp = double(fread(fid,1,'uint32'));

lensbytesY = double(fread(fid, 1, 'uint32'));
ultlY = double(fread(fid, 1, 'uint8'));
sbytesY = double(fread(fid, lensbytesY, 'uint8'));
lensbytesCb = double(fread(fid, 1, 'uint32'));
ultlCb = double(fread(fid, 1, 'uint8'));
sbytesCb = double(fread(fid, lensbytesCb, 'uint8'));
lensbytesCr = double(fread(fid, 1, 'uint32'));
ultlCr = double(fread(fid, 1, 'uint8'));
sbytesCr = double(fread(fid, lensbytesCr, 'uint8'));

% Cierro el archivo
fclose(fid);

% Se convierten las matrices binarias a strings binarias
CodedY=bytes2bits(sbytesY, ultlY);
CodedCb=bytes2bits(sbytesCb, ultlCb);
CodedCr=bytes2bits(sbytesCr, ultlCr);
 
% Decodifica los Scans a partir de strings binarios
XScanrec=DecodeScans_dflt(CodedY,CodedCb,CodedCr,[mamp namp]);

% Recupera matrices de etiquetas en orden natural
%  a partir de orden zigzag
Xlabrec=invscan(XScanrec);

% Descuantizacion de etiquetas
Xtransrec=desquantmat(Xlabrec, caliQ);

% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Como resultado, reconstruye una imagen YCbCr con tamaño ampliado
Xamprec = imidct(Xtransrec,m, n);

% Convierte a espacio de color RGB
% Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
Xrecrd=round(ycbcr2rgb(Xamprec/255)*255);
Xrec=uint8(Xrecrd);

% Repone el tamaño original
Xrec=Xrec(1:m,1:n, 1:3);

% Creo de nuevo mi archivo de imagen
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'._des_def.bmp');
imwrite(Xrec, nombrecomp);

%Recupero el TO
nameOriginal = strcat(name, '','.bmp');
[X, Xamp, tipo, m, n, mamp, namp, TO]=imlee(nameOriginal);

% Calculo RC y MSE
TC=dir(fname);
TC=TC.bytes;
MSE=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3); 

RC= 100*(TO-TC)/TO; % TASA (rate) de compresión. 

disp("MSE:");
disp(MSE);
disp("RC:");
disp(RC);
end


