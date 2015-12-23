function varargout = bestPredUI(varargin)
% BESTPREDUI MATLAB code for bestPredUI.fig
%      BESTPREDUI, by itself, creates a new BESTPREDUI or raises the existing
%      singleton*.
%
%      H = BESTPREDUI returns the handle to a new BESTPREDUI or the handle to
%      the existing singleton*.
%
%      BESTPREDUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BESTPREDUI.M with the given input arguments.
%
%      BESTPREDUI('Property','Value',...) creates a new BESTPREDUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bestPredUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bestPredUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bestPredUI

% Last Modified by GUIDE v2.5 20-Dec-2015 21:00:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bestPredUI_OpeningFcn, ...
                   'gui_OutputFcn',  @bestPredUI_OutputFcn, ...
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

% --- Executes just before bestPredUI is made visible.
function bestPredUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bestPredUI (see VARARGIN)

% Choose default command line output for bestPredUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

patchesDisplay = varargin{1};

targetP = patchesDisplay{1};
maxPixel = max(targetP(:));

axes(handles.axes1);
cla;
imagesc(patchesDisplay{1},[0 maxPixel]);
colorbar;

axes(handles.axes2);
cla;
imagesc(patchesDisplay{2},[0 maxPixel]);
colorbar;

axes(handles.axes3);
cla;
imagesc(patchesDisplay{3},[0 maxPixel]);
colorbar;

data = guidata(hObject);
data.buttonClicked = 0;
guidata(hObject,data);

% UIWAIT makes bestPredUI wait for user response (see UIRESUME)
uiwait(handles.figure1);
%uiwait();


% --- Outputs from this function are returned to the command line.
function varargout = bestPredUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
data = guidata(hObject);
varargout{1} = data.buttonClicked;


% --- Executes on button press in pushbutton1.
%   This is the one that says "right one is best"
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = guidata(hObject);
data.buttonClicked = 2;
guidata(hObject,data);
bestPredUI_OutputFcn(hObject, eventdata, handles)

close;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on button press in pushbutton4.
% one that says "Middle one is best"
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = guidata(hObject);
data.buttonClicked = 1;
guidata(hObject,data);
bestPredUI_OutputFcn(hObject, eventdata, handles)
close


% --- Executes on button press in pushbutton5.
% one that says "decide later"
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = guidata(hObject);
data.buttonClicked = -1;
guidata(hObject,data);
bestPredUI_OutputFcn(hObject, eventdata, handles)
close


% --- Executes on button press in pushbutton6.
% one that says "ambiguous"
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = guidata(hObject);
data.buttonClicked = -2;
guidata(hObject,data);
bestPredUI_OutputFcn(hObject, eventdata, handles)
close


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    %data = guidata(hObject);
    %data.buttonClicked = 'right';
    %guidata(hObject,data);
    delete(hObject);
end
%delete(hObject);
