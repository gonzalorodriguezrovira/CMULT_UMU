function ehuf = HufCodTables_custom(BITS,HUFFVAL) 
% Construye Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
% Construye Tablas de Codificacion Huffman
[EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL);
ehuf=[EHUFCO EHUFSI];
end