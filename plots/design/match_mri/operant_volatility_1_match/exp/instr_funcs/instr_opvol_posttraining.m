i=0; clear tx ypos func;
func{1}=[];


i=i+1; 
	ypos{i}=yposm;
	tx{i}='Die Übung ist jetzt zu Ende.';
    
i=i+1; 
	ypos{i}=yposm;
	tx{i}='Wie bei den meisten Gewinnspielen mischt der Zufall auch mit und es kann passieren, dass eine Karte die zunächst häufig gewonnen hat schlechter wird. Im Gegenzug wird dann die andere Karte besser. \n\n Achten Sie stets wachsam auf solche Veränderungen, um so viel Geld wie möglich zu gewinnen!';

i=i+1; 
	ypos{i}=yposm;
	tx{i}='Gleich haben Sie für dieses Gewinnspiel 15 Minuten Zeit. Ihren Gewinn bekommen Sie danach ausgezahlt!';
    
i=i+1; 
	ypos{i}=yposm;
	tx{i}='Wir möchten jetzt sicher stellen, dass Sie alles verstanden haben. Bitte erklären Sie, was Ihre Aufgabe in diesem Gewinnspiel ist.';
    
if doeeg
i=i+1; 
	ypos{i}=yposm;
	tx{i}='Außerdem möchte wir Sie bitten während die Karten oder der Gewinn gezeigt werden nicht zu blinzeln. Bitte blinzeln Sie nur nach dem der Gewinn nicht mehr sichtbar ist!';
end

instr_display;
checkabort;