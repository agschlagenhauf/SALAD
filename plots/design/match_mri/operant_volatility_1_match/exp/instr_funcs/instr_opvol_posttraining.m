i=0; clear tx ypos func;
func{1}=[];


i=i+1; 
	ypos{i}=yposm;
	tx{i}='Die �bung ist jetzt zu Ende.';
    
i=i+1; 
	ypos{i}=yposm;
	tx{i}='Wie bei den meisten Gewinnspielen mischt der Zufall auch mit und es kann passieren, dass eine Karte die zun�chst h�ufig gewonnen hat schlechter wird. Im Gegenzug wird dann die andere Karte besser. \n\n Achten Sie stets wachsam auf solche Ver�nderungen, um so viel Geld wie m�glich zu gewinnen!';

i=i+1; 
	ypos{i}=yposm;
	tx{i}='Gleich haben Sie f�r dieses Gewinnspiel 15 Minuten Zeit. Ihren Gewinn bekommen Sie danach ausgezahlt!';
    
i=i+1; 
	ypos{i}=yposm;
	tx{i}='Wir m�chten jetzt sicher stellen, dass Sie alles verstanden haben. Bitte erkl�ren Sie, was Ihre Aufgabe in diesem Gewinnspiel ist.';
    
if doeeg
i=i+1; 
	ypos{i}=yposm;
	tx{i}='Au�erdem m�chte wir Sie bitten w�hrend die Karten oder der Gewinn gezeigt werden nicht zu blinzeln. Bitte blinzeln Sie nur nach dem der Gewinn nicht mehr sichtbar ist!';
end

instr_display;
checkabort;