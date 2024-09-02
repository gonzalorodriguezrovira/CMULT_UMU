function [MSE,RC]=jdes_custom(fname)
% Descomprime archivos .huc

% Entradas
%   fname: Srchivo que contiene la informacion de una imagen comprimida.
% Salidas
%   RC: Relacion de compresion.
%   MSE: Error cuadratico medio.
%   Genera de nuevo la imagen fname._des_custom.bmp

%Abro el archivo
fid = fopen(fname, 'r');
%Leo la informacion del archivo
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

lenBITS_Y_DC = double(fread(fid,1,'uint8'));
BITS_Y_DC = double(fread(fid, lenBITS_Y_DC, 'uint8'));
lenHUFFVAL_Y_DC = double(fread(fid, 1, 'uint8'));
HUFFVAL_Y_DC = double(fread(fid, lenHUFFVAL_Y_DC, 'uint8'));
lenBITS_Y_AC = double(fread(fid,1,'uint8'));
BITS_Y_AC = double(fread(fid, lenBITS_Y_AC, 'uint8'));
lenHUFFVAL_Y_AC = double(fread(fid, 1, 'uint8'));
HUFFVAL_Y_AC = double(fread(fid, lenHUFFVAL_Y_AC, 'uint8'));
lenBITS_C_DC = double(fread(fid,1,'uint8'));
BITS_C_DC = double(fread(fid, lenBITS_C_DC, 'uint8'));
lenHUFFVAL_C_DC = double(fread(fid, 1, 'uint8'));
HUFFVAL_C_DC = double(fread(fid, lenHUFFVAL_C_DC, 'uint8'));
lenBITS_C_AC = double(fread(fid,1,'uint8'));
BITS_C_AC = double(fread(fid, lenBITS_C_AC, 'uint8'));
lenHUFFVAL_C_AC = double(fread(fid, 1, 'uint8'));
HUFFVAL_C_AC = double(fread(fid, lenHUFFVAL_C_AC, 'uint8'));
%Cierro el fichero
fclose(fid);

% Se convierten las matrices binarias a strings binarias
CodedY=bytes2bits(sbytesY, ultlY);
CodedCb=bytes2bits(sbytesCb, ultlCb);
CodedCr=bytes2bits(sbytesCr, ultlCr);
 
% Decodifica los tres Scans a partir de strings binarios
XScanrec = DecodeScans_custom(CodedY, CodedCb, CodedCr, [mamp namp],BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC,HUFFVAL_Y_AC, BITS_C_DC,HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC);

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

%Creo el nuervo fichero de la imagen
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'._des_cus.bmp');

%Recupero el TO
nameOriginal = strcat(name, '','.bmp');
[X, ~, ~, ~, ~, ~, ~, TO] = imlee(nameOriginal);

imwrite(Xrec, nombrecomp);

%Calculo MSE y RC
MSE=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3); 

TC=dir(fname);
TC=TC.bytes;

RC= 100*(TO-TC)/TO; % TASA (rate) de compresión. 
    
disp("MSE");
disp(MSE);
disp("RC");
disp(RC);

end


