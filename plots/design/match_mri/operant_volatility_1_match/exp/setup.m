fprintf('............ Setting up the screen   \n');

% colours (in RBG)
                        % black 		= [0 0 0]; 
                        % gray1   	= [70 70 70];
                        % purple		= [148 0 211];
                        % brown		= [205 133 63];
                        % chartreuse 	= [127 255 0];
                        % yellow		= [250 250 50]; 
                        % purple		= [150 0 150];

bgcol 		= [80 0];	% this is just in grayscale (each value separately)
white 		= [200 200 200];
hard_white  = [255 255 255];
red 		= [255 20 20]; 
blue 		= [120 0 255]; 
green 		= [0 135 00]; 
txtcolor 	= white;
txtsize     = 27; % text size
txtlarge    = 27;  
blw         = .2;                              % width of stimulus as fraction of **xfrac**
blh         = .2;                              % height of stimulus as fraction of **xfrac**
txt_fix     = 50; 

% open a screen
AssertOpenGL;
Screen('Preference','Verbosity',0);
if debug; 
	Screen('Preference','SkipSyncTests',2); % ONLY do this for quick debugging;
	wd=Screen('OpenWindow',0,bgcol(2),[0 0 600 400],[],2,[],[]); % Make small PTB screen on my large screen
else
    Screen('Preference','SkipSyncTests',2);
    %imagingmode=kPsychNeedFastBackingStore;	% flip takes ages without this
	wd=Screen('OpenWindow',0,bgcol(2),[],[],2,[],[],[]);	     % Get Screen. This is always size of the display. 
end 
Screen('TextSize',wd,txtsize);				% Set size of text
KbName('UnifyKeyNames');                    % need this for KbName to behave

% Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure
% they are loaded and ready when we need them - without delays
% in the wrong moment:
KbCheck;
WaitSecs(0.01);
GetSecs;

% AT MPI computers this priority level made KbCheck crash! 
% Set priority for script execution to realtime priority:
%priorityLevel = MaxPriority(wd, ['GetSecs'],['WaitSecs'],['KbCheck'],['KbWait']);
%Priority(priorityLevel);

%---------------------------------------------------------------------------
%                    SCREEN LAYOUT
%---------------------------------------------------------------------------
[wdw, wdh]=Screen('WindowSize', wd);	% Get screen size 

%................... Presentation coordinates 
xfrac=.7; 				% fraction of x width to use 
yfrac=.5; 				% fraction of y height to use 
xl0=xfrac*wdw; 			% width to use in pixels
yl0=yfrac*wdh; 			% height to use in pixels
x0=(1-xfrac)/2*wdw; 	% zero point along width 
y0=(1-yfrac)/2*wdh;		% zero point along height

%.................... The squares 
boxc = x0+round([xl0*1/6  xl0*5/6]);                    % x centres left and right third of fracdisplay
box0 = round([-blw*xl0 -blh*xl0 blw*xl0 blh*xl0]/2);    % boxlines 

% each box
for k=1:2;
	box (k,:) =     box0 + [boxc(k) wdh/2.1 boxc(k) wdh/1.8];	% main boxes 
	boxl(k,:) = 1.2*box0 + [boxc(k) wdh/2.1 boxc(k) wdh/1.8];	% slightly larger box 
end
box_center    = 1.2*box0 + [wdw/2 wdh/2 wdw/2 wdh/2];

squareframe= Screen('MakeTexture',wd,repmat(reshape(blue,[1 1 3]),[5 5 1]));
if doinstr
	eval(['tmp=imread(''imgs' filesep 'card_1.png'');'])
	dreieck=Screen('MakeTexture',wd,tmp);
    eval(['tmp=imread(''imgs' filesep 'card_2.png'');'])
	viereck=Screen('MakeTexture',wd,tmp);
else
    eval(['tmp=imread(''imgs' filesep 'card_3.png'');'])
    dreieck_blau=Screen('MakeTexture',wd,tmp);
	eval(['tmp=imread(''imgs' filesep 'card_4.png'');'])
	viereck_gelb=Screen('MakeTexture',wd,tmp);
end

%.................... The feedback 
eval(['tmp=imread(''imgs' filesep '10ct_x.bmp'');'])
frowny=Screen('MakeTexture',wd,tmp);
eval(['tmp=imread(''imgs' filesep '10ct.bmp'');'])
smiley=Screen('MakeTexture',wd,tmp);
text_fb_too_slow = 'Zu langsam!';

% position to display feedback too slow
xpos_fb = x0+xl0* .2; ypos_fb = y0+yl0* .1; 
    
% write outcome explicitly, too 
txt_win   = 'Gewonnen!';
cent_win  = ['+ 10 Cent'];
col_gr    = green;
txt_loss  = 'Verloren!';
cent_loss = ['- 10 Cent'];
col_re    = red;

% arrows 
eval(['tmp=imread(''imgs' filesep 'arrows.tif'');'])
arrow=Screen('MakeTexture',wd,tmp);
arrowsquare(1,:)=[wdw*.02 wdh*.92 wdw*.16 wdh*.98];

% instructions positions
addpath('instr_funcs');
yposm = 'center'; 
yposb = .8*wdh; 
ypost = .1*wdh; 
ypostt=.05*wdh;

% monitor frame rate
[monitorFlipInterval nrValidSamples stddev] = Screen('GetFlipInterval', wd);
 