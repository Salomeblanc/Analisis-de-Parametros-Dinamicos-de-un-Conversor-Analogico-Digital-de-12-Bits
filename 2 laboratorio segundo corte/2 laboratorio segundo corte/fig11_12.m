clear; clc; close all;

M = [128 256 512 1024];                       

piso_ideal  = [-90.300890 -93.311190 -96.321490 -99.331790];  
piso_medido = [-69.675700 -73.503108 -75.847000 -78.746050];  
SNR_medido  = [58.757090 52.329512 49.382760 49.411624];      
ENOB_medido = [8.407956 8.325352 7.842477 7.880414];           

SNR_ideal_dB = 74.0;                                          
ENOB_ideal_bits = (SNR_ideal_dB - 1.76) / 6.02;               

color_azul = [0.16 0.32 0.62];
color_rojo = [0.80 0.18 0.18];
fuente_texto = 'Times New Roman'; 

fig1 = figure('Color','w','Position',[100 100 620 400]);
ax1 = axes(fig1);
hold(ax1,'on'); box(ax1,'on');

hMedido = plot(ax1,M,piso_medido,'-s', 'Color',color_rojo, ...
    'MarkerFaceColor',color_rojo, 'MarkerEdgeColor',color_rojo, ...
    'MarkerSize',6, 'LineWidth',1.3);

hIdeal = plot(ax1,M,piso_ideal,'-o', 'Color',color_azul, ...
    'MarkerFaceColor',color_azul, 'MarkerEdgeColor',color_azul, ...
    'MarkerSize',6, 'LineWidth',1.3);

for k = 1:numel(M)
    text(ax1,M(k),piso_medido(k)+1.5, sprintf('%.1f',piso_medido(k)), ...
        'Color',color_rojo, 'FontSize',8.5, 'HorizontalAlignment','center', 'FontName', fuente_texto);
    text(ax1,M(k),piso_ideal(k)-1.5, sprintf('%.1f',piso_ideal(k)), ...
        'Color',color_azul, 'FontSize',8.5, 'HorizontalAlignment','center', 'FontName', fuente_texto);
end

set(ax1, 'XScale','log', 'XTick',M, 'XTickLabel',string(M), 'FontName', fuente_texto);
xlim(ax1,[115 1150]); ylim(ax1,[-102 -65]);

grid(ax1,'on');
ax1.GridLineStyle = '-';
ax1.GridColor = [0.8 0.8 0.8];
ax1.GridAlpha = 0.4;

xlabel(ax1,'Puntos de la FFT, M', 'FontName', fuente_texto);
ylabel(ax1,'Piso de ruido (dBFS/bin)', 'FontName', fuente_texto);
title(ax1,'Piso de ruido ideal vs. medido', 'FontName', fuente_texto, 'FontWeight', 'normal');
legend(ax1,[hIdeal hMedido], {'Piso ideal (AN693)','Piso medido'}, ...
    'Location','east', 'Box','off', 'FontName', fuente_texto);
hold(ax1,'off');


fig2 = figure('Color','w','Position',[100 100 600 350]); 
ax2 = axes(fig2);
hold(ax2,'on'); box(ax2,'on');

ylim_SNR = [48 75.5]; 
ylim_ENOB = (ylim_SNR - 1.76) / 6.02;

yyaxis(ax2,'left');
yline(ax2, SNR_ideal_dB, ':', 'Color', color_rojo, 'LineWidth', 1.2, 'HandleVisibility', 'off');

hSNR = plot(ax2,M,SNR_medido,'-o', 'Color',color_azul, ...
    'MarkerFaceColor',color_azul, 'MarkerEdgeColor',color_azul, ...
    'MarkerSize',6.5, 'LineWidth',1.5);

ylabel(ax2,'SNR [dB]', 'FontName', fuente_texto);
ax2.YColor = color_azul;
ylim(ax2, ylim_SNR);
yticks(ax2, 50:5:75);


yyaxis(ax2,'right');
hENOB = plot(ax2,M,ENOB_medido,'-s', 'Color',color_rojo, ...
    'MarkerFaceColor',color_rojo, 'MarkerEdgeColor',color_rojo, ...
    'MarkerSize',6.5, 'LineWidth',1.5);

ylabel(ax2,'ENOB [bits]', 'FontName', fuente_texto);
ax2.YColor = color_rojo;
ylim(ax2, ylim_ENOB); 
yticks(ax2, 8:1:12);


set(ax2, 'XScale','log', 'XTick',M, 'XTickLabel',{'128','256','512','1024'}, ...
    'FontName', fuente_texto, 'FontSize', 10);
xlim(ax2,[115 1150]); 
xlabel(ax2,'Puntos de la FFT, M', 'FontName', fuente_texto);


ax2.XGrid = 'on'; 
ax2.YGrid = 'on';
ax2.GridLineStyle = '-'; 
ax2.GridColor = [0.8 0.8 0.8];
ax2.GridAlpha = 0.4;


title(ax2, 'SNR y ENOB medidos vs. M (líneas punteadas: límites ideales)', ...
    'FontWeight', 'normal', 'FontName', fuente_texto, 'FontSize', 10);

legend([hSNR hENOB], {'SNR medido [dB]','ENOB medido [bits]'}, ...
    'Location','east', 'Box','off', 'FontSize', 8.5, 'FontName', fuente_texto);

hold(ax2,'off');

exportgraphics(fig1, 'piso_ruido_ideal_vs_medido.png', 'Resolution',300);
exportgraphics(fig2, 'SNR_ENOB_vs_M.png', 'Resolution',300);