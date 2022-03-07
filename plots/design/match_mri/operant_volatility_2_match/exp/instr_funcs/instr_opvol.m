fprintf('............. Displaying instructions \n');
i=0; clear tx ypos func;
func{1}=[];

if doscanner | doeeg
    i=i+1; 
	ypos{i}=yposm;
	tx{i}=['Willkommen zu diesem Gewinnspiel.\n\n Wir werden es Ihnen jetzt erkl�ren.\n\n Benutzen Sie bitte die rechte Taste, um vorw�rts zu bl�ttern und die linke Taste, um zur�ck zu bl�ttern.'];
else
    i=i+1; 
	ypos{i}=yposm;
	tx{i}=['Willkommen zu diesem Gewinnspiel.\n\n Wir werden es Ihnen jetzt erkl�ren.\n\n Benutzen Sie bitte die rechte Pfeiltaste, um vorw�rts zu bl�ttern und die linke Pfeiltaste, um zur�ck zu bl�ttern.'];
end
i=i+1; 
	ypos{i}=yposm;
	tx{i}=['Dieses Gewinnspiel ist ein einfaches Kartenspiel. Es geht darum, so viel Geld wie m�glich zu gewinnen.\n\n Ihren Geldgewinn bekommen Sie am Ende ausgezahlt!'];

i=i+1; 
	ypos{i}=yposm;
	tx{i}=['In jedem Durchgang w�hlen Sie zwischen zwei Spielkarten.'];

if  doscanner | doeeg
    i=i+1; 
	ypos{i}=ypost;
	tx{i}=['Immer, wenn Sie die zwei Karten sehen, haben Sie 1.5 Sekunden Zeit, eine der beiden auszuw�hlen.\n\n Dazu dr�cken Sie bitte die linke Taste f�r die linke Karte und die rechte Taste f�r die rechte Karte.'];
    func{i}='Screen(''DrawTexture'',wd,dreieck, [],box(1,:)); Screen(''DrawTexture'',wd,viereck, [],box(2,:));getleftrightarrow;';
else
    i=i+1; 
	ypos{i}=ypost;
	tx{i}=['Immer, wenn Sie die zwei Karten sehen, haben Sie 1.5 Sekunden Zeit, eine der beiden auszuw�hlen.\n\n Dazu dr�cken Sie bitte die Taste f f�r die linke Karte und die Taste j f�r die rechte Karte.'];
    func{i}='Screen(''DrawTexture'',wd,dreieck, [],box(1,:)); Screen(''DrawTexture'',wd,viereck, [],box(2,:));getleftrightarrow;';
end
    
i=i+1; 
	ypos{i}=ypost;
	tx{i}=['Sofort nach der Auswahl bekommen Sie eine R�ckmeldung. Entweder gewinnen Sie mit der gew�hlten Karte 10 Cent...'];
    func{i}='Screen(''DrawTexture'',wd,squareframe,[],boxl(1,:)); Screen(''DrawTexture'',wd,dreieck, [],box(1,:)); Screen(''DrawTexture'',wd,viereck, [],box(2,:));Screen(''DrawTexture'',wd,smiley,[],box_center);getleftrightarrow;';
    
i=i+1; 
	ypos{i}=ypost;
	tx{i}=['... oder Sie verlieren mit der ausgew�hlten Karte 10 Cent.'];
    func{i}='Screen(''DrawTexture'',wd,squareframe,[],boxl(1,:)); Screen(''DrawTexture'',wd,dreieck, [],box(1,:)); Screen(''DrawTexture'',wd,viereck, [],box(2,:));Screen(''DrawTexture'',wd,frowny,[],box_center);getleftrightarrow;';

i=i+1; 
	ypos{i}=yposm;
	tx{i}=['Wie bei einem Gewinnspiel so �blich ist auch ein bi�chen Gl�ck dabei, denn keine Karte gewinnt oder verliert immer.'];

si=i+1; 
	ypos{i}=yposm;
	tx{i}=['Sie sollen die Karte ausw�hlen, welche am h�ufigsten gewinnt, damit Sie insgesamt m�glichst viel Geld gewinnen, denn Ihren Gewinn bekommen Sie am Ende ausgezahlt.'];

if doeeg
i=i+1; 
	ypos{i}=yposm;
	tx{i}='Au�erdem m�chte wir Sie bitten w�hrend die Karten oder der Gewinn gezeigt werden nicht zu blinzeln. Bitte blinzeln Sie nur nach dem der Gewinn nicht mehr sichtbar ist!';
end

i=i+1; 
	ypos{i}=yposm;
	tx{i}='Lassen Sie uns das kurz �ben.';
    
instr_display;
