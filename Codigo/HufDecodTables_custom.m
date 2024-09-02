function [MINCODE,MAXCODE,VALPTR,HUFFVAL] = HufDecodTables_custom(BITS,HUFFVAL)

% Construye Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
% Construye Tablas de Decodificacion Huffman
[MINCODE,MAXCODE,VALPTR]=HDecodingTables(BITS, HUFFCODE);


