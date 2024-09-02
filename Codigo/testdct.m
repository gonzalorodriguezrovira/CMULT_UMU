function [mse,dmaxdifer]=testdct(fname) 
[X, Xamp, tipo, m, n, mamp, namp, TO]=imlee(fname);
Xtrans=imidct(Xamp, m, n);
Xamprec = imidct(Xtrans, m, n);
[Xrec, nombrecomp]=imescribe(Xamprec,m,n, fname);
mse=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3); 
% Test de valor de diferencias double
ddifer=abs(double(Xrec)-double(X));
dmaxdifer=max(max(max(ddifer)));

[m,n,p] = size(X);
figure('Units','pixels','Position',[100 100 n m]);
set(gca,'Position',[0 0 1 1]);
image(X);
set(gcf,'Name','Imagen original X');
figure('Units','pixels','Position',[100 100 n m]);
set(gca,'Position',[0 0 1 1]);
image(Xrec);
set(gcf,'Name','Imagen reconstruida Xrec');

