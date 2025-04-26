%- just these 3 lines to add current date @ the bottom-right corner of a plot
axes('position',[.01,.01,.99,.99],'Visible','off');
Tdate=text(0.9,0.02,date);
set(Tdate,'HorizontalAlignment','center','FontSize',7);
