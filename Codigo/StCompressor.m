function [scod,BITS,HUFFVAL]=StCompressor(x)
% Obtiene frecuencias de mensajes contenidos en x
% Hay un offset: FREQ(1) es frecuencia del entero 0
FREQ = Freq256(x);
% Construye Tablas de Especificacion Huffman
[BITS, HUFFVAL] = HSpecTables(FREQ);
% Construye Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
% Construye Tablas de Codificacion Huffman
[EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE,HUFFVAL);
scod = EncodeString2(x, EHUFCO, EHUFSI);