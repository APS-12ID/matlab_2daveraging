function APS_12ID_specr_movemotor
    
hFigSpecr = findobj('Tag','specr_Fig');
hAxes = findobj(hFigSpecr,'Tag','specr_Axes');
hPopupmenuX = findobj(hFigSpecr,'Tag','specr_PopupmenuX');
popupmenuXString = get(hPopupmenuX,'String');
popupmenuXValue = get(hPopupmenuX,'Value');
selmot = popupmenuXString(popupmenuXValue);
val2go = get(hAxes,'CurrentPoint');
if exist('s12motor', 'var')
    move(s12motor.(selmot), val2go(1));
else
    disp('Define s12motor first, by running APS_12IDBmotor.m')
end