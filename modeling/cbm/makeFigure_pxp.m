% cd('C:\Users\katthagt\ownCloud\Shared\Reversal_Vol\scripts_cbm\')
cd('/Users/larawieland/ownCloud/Shared/Reversal_Vol/scripts_cbm')


load('hbi_8models_CT.mat');
pxp = cbm.output.protected_exceedance_prob; clear cbm;
pxp_CT = [pxp(end), pxp(1:end-1)]; %nullmodel first

load('hbi_bothCond_scaling_DU.mat');
pxp_both = cbm.output.protected_exceedance_prob;


figure
subplot(2,1,1)
barh(pxp_CT, 'k');
set(gca,'Color','w');
xlabel('Protected Exceedance Probability PXP','FontWeight', 'Bold');
yt=1:1:8;
yl={'NoLearning-Qbias', 'RW-SU-1al', 'RW-SU2-al', 'RW-iDU-1al', 'RW-iDU-2al', 'RW-DU-1al',...
'RW-DU-2al', 'PH-1LR'};
set(gca,'yTick', yt, 'yTicklabel', yl, 'xlim', [0 1]); 
hold on

subplot(2,1,2)
barh(pxp_both, 'k');
set(gca,'Color','w');
xlabel('Protected Exceedance Probability PXP','FontWeight', 'Bold');
yt=1:1:4;
yl={'RW-DU-2al-NoStress', 'RW-DU-2al-StressBetas', 'RW-DU-2al-StressLearning', 'RW-DU-2al-StressAll' };
set(gca,'yTick', yt, 'yTicklabel', yl);
set(gcf, 'PaperUnits', 'inches');
x_width=7.25 ;y_width=9.125

set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
print -dtiff -r600 plot_CT_both_pxp.tiff