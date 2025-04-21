function varargout = CCD12ID(varargin)
% CCD12ID MATLAB code for CCD12ID.fig
%      CCD12ID, by itself, creates a new CCD12ID or raises the existing
%      singleton*.
%
%      H = CCD12ID returns the handle to a new CCD12ID or the handle to
%      the existing singleton*.
%
%      CCD12ID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CCD12ID.M with the given input arguments.
%
%      CCD12ID('Property','Value',...) creates a new CCD12ID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CCD12ID_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CCD12ID_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CCD12ID

% Last Modified by GUIDE v2.5 20-Jul-2014 21:50:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CCD12ID_OpeningFcn, ...
                   'gui_OutputFcn',  @CCD12ID_OutputFcn, ...
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


% --- Executes just before CCD12ID is made visible.
function CCD12ID_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CCD12ID (see VARARGIN)

% Choose default command line output for CCD12ID
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CCD12ID wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CCD12ID_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ed_detPV_Callback(hObject, eventdata, handles)
% hObject    handle to ed_detPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_detPV as text
%        str2double(get(hObject,'String')) returns contents of ed_detPV as a double


% --- Executes during object creation, after setting all properties.
function ed_detPV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_detPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_connect.
function pb_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PVbase = strtrim(get(handles.ed_detPV, 'string'));
det = Pilatus(PVbase);
det = connect(det);
det = get(det);
detall{1} = det;
set(gcbf, 'userdata', detall);


% --- Executes on button press in tg_monitor.
function tg_monitor_Callback(hObject, eventdata, handles)
% hObject    handle to tg_monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tg_monitor
detall = get(gcbf, 'userdata');
det = detall{1};

switch get(hObject, 'value')
    case 1
        mcamon(det.SeqNumber{2}, 'mcamoncallback');
        mcamontimer('start')
    case 0
        mcamontimer('stop');
        mcaclearmon(det.SeqNumber{2})
end

function mcamoncallback
    disp('TEST works')