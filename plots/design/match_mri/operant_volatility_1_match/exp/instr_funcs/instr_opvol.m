fprintf('............. Displaying instructions \n');
i=0; clear tx ypos func;
func{1}=[];

if doscanner | doeeg
    i=i+1; 
	ypos{i}=yposm;
	tx{i}=['Willkommen zu diesem Gewinnspiel.\n\n Wir werden es Ihnen jetzt erklären.\n\n Benutzen Sie bitte die rechte Taste, um vorwärts zu blättern und die linke Taste, um zurück zu blättern.'];
else
    i=i+1; 
	ypos{i}=yposm;
	tx{i}=['Willkommen zu diesem Gewinnspiel.\n\n Wir werden es Ihnen jetzt erklären.\n\n Benutzen Sie bitte die rechte Pfeiltaste, um vorwärts zu blättern und die linke Pfeiltaste, um zurück zu blättern.'];
end
i=i+1; 
	ypos{i}=yposm;
	tx{i}=['Dieses Gewinnspiel ist ein einfaches Kartenspiel. Es geht darum, so viel Geld wie möglich zu gewinnen.\n\n Ihren Geldgewinn bekommen Sie am Ende ausgezahlt!'];

i=i+1; 
	ypos{i}=yposm;
	tx{i}=['In jedem Durchgang wählen Sie zwischen zwei Spielkarten.'];

if  doscanner | doeeg
    i=i+1; 
	ypos{i}=ypost;
	tx{i}=['Immer, wenn Sie die zwei Karten sehen, haben Sie 1.5 Sekunden Zeit, eine der beiden auszuwählen.\n\n Dazu drücken Sie bitte die linke Taste für die linke Karte und die rechte Taste für die rechte Karte.'];
    func{i}='Screen(''DrawTexture'',wd,dreieck, [],box(1,:)); Screen(''DrawTexture'',wd,viereck, [],box(2,:));getleftrightarrow;';
else
    i=i+1; 
	ypos{i}=ypost;
	tx{i}=['Immer, wenn Sie die zwei Karten sehen, haben Sie 1.5 Sekunden Zeit, eine der beiden auszuwählen.\n\n Dazu drücken Sie bitte die Taste f für die linke Karte und die Taste j für die rechte Karte.'];
    func{i}='Screen(''DrawTexture'',wd,dreieck, [],box(1,:)); Screen(''DrawTexture'',wd,viereck, [],box(2,:));getleftrightarrow;';
end
    
i=i+1; 
	ypos{i}=ypost;
	tx{i}=['Sofort nach der Auswahl bekommen Sie eine Rückmeldung. Entweder gewinnen Sie mit der gewählten Karte 10 Cent...'];
    func{i}='Screen(''DrawTexture'',wd,squareframe,[],boxl(1,:)); Screen(''DrawTexture'',wd,dreieck, [],box(1,:)); Screen(''DrawTexture'',wd,viereck, [],box(2,:));Screen(''DrawTexture'',wd,smiley,[],box_center);getleftrightarrow;';
    
i=i+1; 
	ypos{i}=ypost;
	tx{i}=['... oder Sie verlieren mit der ausgewählten Karte 10 Cent.'];
    func{i}='Screen(''DrawTexture'',wd,squareframe,[],boxl(1,:)); Screen(''DrawTexture'',wd,dreieck, [],box(1,:)); Screen(''DrawTexture'',wd,viereck, [],box(2,:));Screen(''DrawTexture'',wd,frowny,[],box_center);getleftrightarrow;';

i=i+1; 
	ypos{i}=yposm;
	tx{i}=['Wie bei einem Gewinnspiel so üblich ist auch ein bißchen Glück dabei, denn keine Karte gewinnt oder verliert immer.'];

si=i+1; 
	ypos{i}=yposm;
	tx{i}=['Sie sollen die Karte auswählen, welche am häufigsten gewinnt, damit Sie insgesamt möglichst viel Geld gewinnen, denn Ihren Gewinn bekommen Sie am Ende ausgezahlt.'];

if doeeg
i=i+1; 
	ypos{i}=yposm;
	tx{i}='Außerdem möchte wir Sie bitten während die Karten oder der Gewinn gezeigt werden nicht zu blinzeln. Bitte blinzeln Sie nur nach dem der Gewinn nicht mehr sichtbar ist!';
end

i=i+1; 
	ypos{i}=yposm;
	tx{i}='Lassen Sie uns das kurz üben.';
    
instr_display;
