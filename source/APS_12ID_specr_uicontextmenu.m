function c = APS_12ID_specr_uicontextmenu(fighandle)
    c = uicontextmenu(fighandle);
    uimenu(c, 'label', 'move', 'callback', @moveselmotor);
    function moveselmotor(varargin)
        hFigSpecr = findobj('Tag','specr_Fig');
        hAxes = findobj(hFigSpecr,'Tag','specr_Axes');
        hPopupmenuX = findobj(hFigSpecr,'Tag','specr_PopupmenuX');
        popupmenuXString = get(hPopupmenuX,'String');
        popupmenuXValue = get(hPopupmenuX,'Value');
        selmot = popupmenuXString(popupmenuXValue);
        val2go = get(hAxes,'CurrentPoint');
        try
            s12motor = evalin('base', 's12motor');
        catch
            s12motor = [];
        end
        if isempty(s12motor)
            APS_12IDBmotor;
            assignin('base', 's12motor', s12motor);
        end
        try
            move(s12motor.(selmot{1}), val2go(1));
        catch
            fprintf('%s is not available in s12motor.\n', selmot);
        end
    end
end