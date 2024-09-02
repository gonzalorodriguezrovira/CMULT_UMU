function [CodedY, CodedCb, CodedCr,BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC, HUFFVAL_Y_AC, BITS_C_DC,HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC] = EncodeScans_custom(XScan);

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion EncodeScans_dflt:');
end

% Instante inicial
tc=cputime;

% Separa las matrices bidimensionales 
%  para procesar separadamente
YScan=XScan(:,:,1);
CbScan=XScan(:,:,2);
CrScan=XScan(:,:,3);

% Recolectar valores a codificar
[Y_DC_CP, Y_AC_ZCP]=CollectScan(YScan);
[Cb_DC_CP, Cb_AC_ZCP]=CollectScan(CbScan);
[Cr_DC_CP, Cr_AC_ZCP]=CollectScan(CrScan);

[scod1,BITS_Y_DC,HUFFVAL_Y_DC]=StCompressor((Y_DC_CP(:, 1)));
[scod2,BITS_Y_AC,HUFFVAL_Y_AC]=StCompressor((Y_AC_ZCP(:, 1)));
[scod3,BITS_C_DC,HUFFVAL_C_DC]=StCompressor([Cb_DC_CP(:, 1);Cr_DC_CP(:, 1)]);
[scod4,BITS_C_AC,HUFFVAL_C_AC]=StCompressor([Cb_AC_ZCP(:, 1);Cr_AC_ZCP(:, 1)]);



ehuf_Y_DC = HufCodTables_custom(BITS_Y_DC,HUFFVAL_Y_DC);
% Tabla Y_AC
ehuf_Y_AC = HufCodTables_custom(BITS_Y_AC,HUFFVAL_Y_AC);
% Tablas de crominancia
% Tabla C_DC
ehuf_C_DC = HufCodTables_custom(BITS_C_DC,HUFFVAL_C_DC);
% Tabla C_AC
ehuf_C_AC = HufCodTables_custom(BITS_C_AC,HUFFVAL_C_AC);

% Codifica en binario cada Scan
% Las tablas de crominancia, ehuf_C_DC y ehuf_C_AC, se aplican, tanto a Cb, como a Cr
CodedY=EncodeSingleScan(YScan, Y_DC_CP, Y_AC_ZCP, ehuf_Y_DC, ehuf_Y_AC);
CodedCb=EncodeSingleScan(CbScan, Cb_DC_CP, Cb_AC_ZCP, ehuf_C_DC, ehuf_C_AC);
CodedCr=EncodeSingleScan(CrScan, Cr_DC_CP, Cr_AC_ZCP, ehuf_C_DC, ehuf_C_AC);

% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Componentes codificadas en binario');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado EncodeScans_dflt');
end