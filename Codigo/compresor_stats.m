function compresor_stats(fname)
jcom_dflt(fname,1);
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'.hud');
[RC1,MSE1]=jdes_dflt(nombrecomp);
jcom_dflt(fname,50);
[pathstr,name,ext] = fileparts(fname);
[RC50,MSE50]=jdes_dflt(nombrecomp);
jcom_dflt(fname,100);
[pathstr,name,ext] = fileparts(fname);
[RC100,MSE100]=jdes_dflt(nombrecomp);
jcom_dflt(fname,200);
[pathstr,name,ext] = fileparts(fname);
[RC200,MSE200]=jdes_dflt(nombrecomp);
jcom_dflt(fname,400);
[pathstr,name,ext] = fileparts(fname);
[RC400,MSE400]=jdes_dflt(nombrecomp);
jcom_dflt(fname,800);
[pathstr,name,ext] = fileparts(fname);
[RC800,MSE800]=jdes_dflt(nombrecomp);

mse_values=[MSE1,MSE50,MSE100,MSE200,MSE400,MSE800];
rc_values=[RC1,RC50,RC100,RC200,RC400,RC800];

jcom_custom(fname,1);
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'.huc');
[CRC1,CMSE1]=jdes_custom(nombrecomp);
jcom_custom(fname,50);
[pathstr,name,ext] = fileparts(fname);
[CRC50,CMSE50]=jdes_custom(nombrecomp);
jcom_custom(fname,100);
[pathstr,name,ext] = fileparts(fname);
[CRC100,CMSE100]=jdes_custom(nombrecomp);
jcom_custom(fname,200);
[pathstr,name,ext] = fileparts(fname);
[CRC200,CMSE200]=jdes_custom(nombrecomp);
jcom_custom(fname,400);
[pathstr,name,ext] = fileparts(fname);
[CRC400,CMSE400]=jdes_custom(nombrecomp);
jcom_custom(fname,800);
[pathstr,name,ext] = fileparts(fname);
[CRC800,CMSE800]=jdes_custom(nombrecomp);

Cmse_values=[CMSE1,CMSE50,CMSE100,CMSE200,CMSE400,CMSE800];
Crc_values=[CRC1,CRC50,CRC100,CRC200,CRC400,CRC800];

t = uitable('Data', [mse_values; Cmse_values; rc_values; Crc_values;], ...
    'RowName', {'RC_DFLT','RC_CUSTOM','MSE_DFLT','MSE_CUSTOM'}, ...
    'ColumnName', {'1', '50', '100', '200','400','800'}, ...
    'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);

% Ajustar el tama�o de la celda para que sea m�s legible
t.ColumnWidth = {50};

% A�adir etiquetas de los ejes
xlabel('RC (%)');
ylabel('MSE');

% Establecer el t�tulo de la tabla
title('Tabla de Valores');

% Crear el gr�fico
figure;
h1 = plot(mse_values, rc_values, 'o-', 'LineWidth', 2, 'DisplayName', 'Compresor dflt');
hold on;  % Mantener el gr�fico actual
h2 = plot(Cmse_values,Crc_values, 'o-', 'LineWidth', 2, 'Color', 'r', 'DisplayName', 'Compresor custom');

% Etiquetas y t�tulo
xlabel('RC (%)');
ylabel('MSE');
title('Gr�fico de RC vs. MSE');

% A�adir etiquetas a los puntos del gr�fico (opcional)
text(mse_values, rc_values, cellstr(num2str((1:length(mse_values))')), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

% Mostrar la cuadr�cula
grid on;

% A�adir leyenda
legend([h1, h2], 'Location', 'Best');  % Las etiquetas se toman de 'DisplayName'
end
