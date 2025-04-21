function varargout = APS_findcenter(varargin)
% PLS_FINDCENTER MATLAB code for PLS_findcenter.fig
%      PLS_FINDCENTER, by itself, creates a new PLS_FINDCENTER or raises the existing
%      singleton*.
%
%      H = PLS_FINDCENTER returns the handle to a new PLS_FINDCENTER or the handle to
%      the existing singleton*.
%
%      PLS_FINDCENTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLS_FINDCENTER.M with the given input arguments.
%
%      PLS_FINDCENTER('Property','Value',...) creates a new PLS_FINDCENTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PLS_findcenter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PLS_findcenter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PLS_findcenter

% Last Modified by GUIDE v2.5 28-Apr-2015 15:07:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PLS_findcenter_OpeningFcn, ...
                   'gui_OutputFcn',  @PLS_findcenter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PLS_findcenter is made visible.
function PLS_findcenter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PLS_findcenter (see VARARGIN)

% Choose default command line output for PLS_findcenter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
init_slider(handles)
% UIWAIT makes PLS_findcenter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PLS_findcenter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edTiltangle_Callback(hObject, eventdata, handles)
% hObject    handle to edTiltangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edTiltangle as text
%        str2double(get(hObject,'String')) returns contents of edTiltangle as a double


% --- Executes during object creation, after setting all properties.
function edTiltangle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edTiltangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edAzimAngle_Callback(hObject, eventdata, handles)
% hObject    handle to edAzimAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edAzimAngle as text
%        str2double(get(hObject,'String')) returns contents of edAzimAngle as a double


% --- Executes during object creation, after setting all properties.
function edAzimAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edAzimAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edCenter_Callback(hObject, eventdata, handles)
% hObject    handle to edCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edCenter as text
%        str2double(get(hObject,'String')) returns contents of edCenter as a double


% --- Executes during object creation, after setting all properties.
function edCenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function init_slider(handles)
set(handles.slider1, 'Userdata', str2num(get(handles.edcenterX, 'string')));
set(handles.slider2, 'Userdata', str2num(get(handles.edcenterY, 'string')));
for i=1:2
    set(handles.(['slider', num2str(i)]), 'value', 0.5);
    set(handles.(['slider', num2str(i)]), 'callback', @slider_callback);
end


function slider_callback(varargin)
sv = get(gcbo, 'value');
pv = get(gcbo, 'Userdata');
if abs(sv-0.5) > 0.05
    f = pv*(sv-0.5)/0.5*0.1;
else
    f = 0.2*sign(sv-0.5);
end

cv = pv + f;
    
tg = get(gcbo, 'tag');
switch tg
    case 'slider1'
        hd = findobj(gcbf, 'tag', 'edcenterX');
    case 'slider2'
        hd = findobj(gcbf, 'tag', 'edcenterY');
end
set(hd, 'string', num2str(cv));

%if (sv == 1) || (sv == 0)
    set(gcbo, 'value', 0.5);
    set(gcbo, 'Userdata', cv);
%end
handles = guihandles(gcbf);
pbCutlines_Callback(varargin{1}, varargin{2}, handles);
warning off

% --- Executes on button press in pbCutlines.
function pbCutlines_Callback(hObject, eventdata, handles)
% hObject    handle to pbCutlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear previous lines first.
global PLS_linecut
PLS_linecut = [];
try
    pbClearlines_Callback(hObject, eventdata, handles)
catch
    
end

tiltangle = eval(get(handles.edTiltangle, 'string'));
AzimAng = eval(char(cellstr(get(handles.edAzimAngle, 'string')))); % [0, 90, ...];
%tCenter = eval(char(cellstr(get(handles.edCenter, 'string')))); % [1024, 1038];
tCenter = [str2double(get(handles.edcenterX, 'string')), str2double(get(handles.edcenterY, 'string'))]; % [1024, 1038];

saxs = getgihandle;
saxs.tiltangle = tiltangle;
saxs.center = tCenter;

if numel(AzimAng) < 1
    AzimAng = 0;
    %error('The number of azim angles selected is less than 1')
end
if numel(tCenter) ~= 2
    error('The number of center should be 2')
end
findcenterfigTag = 'findcenter_linecutplot';
%FigH = figure;
%FigH = str2double(get(handles.ed_graphNum, 'string'));
figHandle = findobj('tag', findcenterfigTag);

if isempty(figHandle)
    FigH = str2double(get(handles.ed_graphNum, 'string'));
    figHandle = figure(FigH);
    set(figHandle, 'tag', findcenterfigTag);
    FigAxis = axes;
else
    FigAxis = findobj(figHandle, 'type', 'axes');
end
%figure(FigH);clf;
%newlines = [];
newlines = get(gcbf, 'userdata');
newplotlines = getappdata(gcbf, 'newplotline');
if ~isempty(newplotlines)
    if ~ishandle(newplotlines(1))
        newplotlines = [];
    end
end
if ~isempty(newlines)
    if ~ishandle(newlines(1))
        newlines = [];
    end
end

for i=1:numel(AzimAng)
    linen = i;
    %[R, xn, yn, cut] = linecut(saxs.image, tCenter, tiltangle + AzimAng(linen));
    saxsimagehandle = evalin('base', 'SAXSimagehandle');
    saxs.imgaxeshandle = saxsimagehandle;
    saxs.imghandle = get(saxsimagehandle, 'children');

 %   t = find(xn < 0);
 %   t2 = find(yn < 0);
 %   if isempty(t);
 %       indx = t2;
 %   else
 %       indx = t;
 %   end
 %   xn(indx) = [];
 %   yn(indx) = [];
 %   cut.X(indx) = [];
 %   cut.Y(indx) = [];
 %   R(indx) = [];
    if isfield(saxs, 'frame')
        frameN = saxs.frame;
    else
        frameN = 1;
    end
    img = saxs.image(:,:,frameN);
    [q, th, R, px, py] = linecut_polar(img, AzimAng(i), saxs);
%    [R, xn, yn] = PLS_lineplot3(saxs.image, tCenter, tiltangle + AzimAng(linen));
    cut.X = px; %xn-tCenter(1);
    cut.Y = py; %-tCenter(2);
    xn = px - tCenter(1);
    yn = py - tCenter(2);
    
    switch linen
        case 1
            col = 'r';
        case 2
            col = 'g';
        case 3
            col = 'b';
        case 4
            col = 'k';
        otherwise
            col = 'm';
    end
    dist = sqrt(xn.^2 + yn.^2);
    if numel(newlines)<4
        h = APS_plotcut(saxsimagehandle, saxs, R, dist, cut, FigAxis, col);
        %newlines = [newlines, PLS_linecut.Lineh];
        newlines = PLS_linecut.Lineh;
        newplotlines = [newplotlines, PLS_linecut.cutploth];
    else
        set(newplotlines(i), 'xdata', dist);
        set(newplotlines(i), 'ydata', R);
    end
end
set(gcbf, 'userdata', newlines);
setappdata(gcbf, 'newplotline', newplotlines)

ROI1 = str2double(get(handles.edROI1, 'string'));
ROI2 = str2double(get(handles.edROI2, 'string'));

set(FigAxis, 'xlim', [ROI1, ROI2]);

function handles = APS_plotcut(handles, saxs, R, X, cut, NewfigH, color)
% handles = PLS_plotcut(handles, saxs, R, X, cut, NewfigH, color)
% X is the distance from center to pixels.
global PLS_linecut
if ~isfield(saxs, 'imgaxeshandle')
    saxs.imgaxeshandle = get(saxs.imghandle, 'parent');
end
currentFig = saxs.imgaxeshandle;
if isfield(PLS_linecut, 'Lineh')
    nl = line(cut.X, cut.Y, 'parent', currentFig, 'color', color);
    PLS_linecut.Lineh = [PLS_linecut.Lineh, nl];
else
%    get(currentFig)
    PLS_linecut.Lineh = line(cut.X, cut.Y, 'parent', currentFig, 'color', color);
end
PLS_linecut.cutploth = line(X, R, 'parent', NewfigH, 'color', color);


% --- Executes on button press in pbClearlines.
function pbClearlines_Callback(hObject, eventdata, handles)
% hObject    handle to pbClearlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = get(gcbf, 'userdata');
h2 = getappdata(gcbf, 'newplotline');
delete(h);
delete(h2);



function ed_graphNum_Callback(hObject, eventdata, handles)
% hObject    handle to ed_graphNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_graphNum as text
%        str2double(get(hObject,'String')) returns contents of ed_graphNum as a double


% --- Executes during object creation, after setting all properties.
function ed_graphNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_graphNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edROI1_Callback(hObject, eventdata, handles)
% hObject    handle to edROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edROI1 as text
%        str2double(get(hObject,'String')) returns contents of edROI1 as a double


% --- Executes during object creation, after setting all properties.
function edROI1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edROI2_Callback(hObject, eventdata, handles)
% hObject    handle to edROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edROI2 as text
%        str2double(get(hObject,'String')) returns contents of edROI2 as a double


% --- Executes during object creation, after setting all properties.
function edROI2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbGuessCenter.
function pbGuessCenter_Callback(hObject, eventdata, handles)
% hObject    handle to pbGuessCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FigH = str2double(get(handles.ed_graphNum, 'string'));
lines = findobj(FigH, 'type', 'line');
ROI1 = str2double(get(handles.edROI1, 'string'));
ROI2 = str2double(get(handles.edROI2, 'string'));
lineRed = findobj(lines, 'color', 'r');
lineBlue = findobj(lines, 'color', 'b');
lineGreen = findobj(lines, 'color', 'g');
lineBlack = findobj(lines, 'color', 'k');
peakR = [];
peakB = [];
peakG = [];
peakK = [];
try
    if ~isempty(lineRed)
        xdata = get(lineRed, 'XData');
        ydata = get(lineRed, 'Ydata');
        xdata = xdata(ROI1:ROI2);
        ydata = ydata(ROI1:ROI2);
        [ym, ind] = max(ydata);
        ym=ym(1);peakR = xdata(ind(1));
        %peakR = xdata(ydata == ym);

        f = ezfit(xdata, ydata, sprintf('y = b + A * exp(-(x-c)^2/s^2); b=10;A=%f; c = %f; s=3', ym, peakR));
        showfit(f)
        peakR = f.m(3);
    end

    if ~isempty(lineBlue)
        xdata = get(lineBlue, 'XData');
        ydata = get(lineBlue, 'Ydata');
        xdata = xdata(ROI1:ROI2);
        ydata = ydata(ROI1:ROI2);
        [ym, ind] = max(ydata);
        ym=ym(1);peakB = xdata(ind(1));
        %peakB = xdata(ydata == max(ydata));
        f = ezfit(xdata, ydata, sprintf('y = b + A * exp(-(x-c)^2/s^2); b=10;A=%f; c = %f; s=3', ym, peakB));
        showfit(f)
        peakB = f.m(3);
    end

    if ~isempty(lineGreen)
        xdata = get(lineGreen, 'XData');
        ydata = get(lineGreen, 'Ydata');
        xdata = xdata(ROI1:ROI2);
        ydata = ydata(ROI1:ROI2);
        [ym, ind] = max(ydata);
        ym=ym(1);peakG = xdata(ind(1));
        %peakG = xdata(ydata == max(ydata));
        f = ezfit(xdata, ydata, sprintf('y = b + A * exp(-(x-c)^2/s^2); b=10;A=%f; c = %f; s=3', ym, peakG));
        showfit(f)
        peakG = f.m(3);
    end

    if ~isempty(lineBlack)
        xdata = get(lineBlack, 'XData');
        ydata = get(lineBlack, 'Ydata');
        xdata = xdata(ROI1:ROI2);
        ydata = ydata(ROI1:ROI2);
        [ym, ind] = max(ydata);
        ym=ym(1);peakK = xdata(ind(1));
        %peakK = xdata(ydata == max(ydata));
        f = ezfit(xdata, ydata, sprintf('y = b + A * exp(-(x-c)^2/s^2); b=10;A=%f; c = %f; s=3', ym, peakK));
        showfit(f)
        peakK = f.m(3);
    end
catch
    
end
%tCenter = eval(char(cellstr(get(handles.edCenter, 'string'))));
tCenter = [str2double(get(handles.edcenterX, 'string')), str2double(get(handles.edcenterY, 'string'))]; % [1024, 1038];
AzimAng = eval(char(cellstr(get(handles.edAzimAngle, 'string')))); % [0, 90, ...];

if ~isempty(peakR) && ~isempty(peakB) && ~isempty(peakG) && ~isempty(peakK)
    meanH = (peakR+peakB)/2;
    tCenter(1) = tCenter(1) - (peakB - meanH);

    meanV = (peakG+peakK)/2;
    tCenter(2) = tCenter(2) - (peakK - meanV);
    temp = [peakR, peakB, peakG, peakK]; R = mean(temp);
    fprintf('Recommended center is [%0.2f, %0.2f] and distance is %0.2f', tCenter(1), tCenter(2), R)
elseif ~isempty(peakR) && ~isempty(peakG) && isempty(peakB) && isempty(peakK)
    meanH = (peakR+peakG)/2;
    if abs(AzimAng(1)-90) < 45
        tC = tCenter(2) - (peakG - meanH);
    else
        tC = tCenter(1) - (peakG - meanH);
    end
    temp = [peakR, peakG]; R = mean(temp);
    fprintf('Recommended center is %0.2f and distance is %0.2f', tC, R)
end
    



function edcenterX_Callback(hObject, eventdata, handles)
% hObject    handle to edcenterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edcenterX as text
%        str2double(get(hObject,'String')) returns contents of edcenterX as a double
init_slider(handles)

% --- Executes during object creation, after setting all properties.
function edcenterX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edcenterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edcenterY_Callback(hObject, eventdata, handles)
% hObject    handle to edcenterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edcenterY as text
%        str2double(get(hObject,'String')) returns contents of edcenterY as a double
init_slider(handles)

% --- Executes during object creation, after setting all properties.
function edcenterY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edcenterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
