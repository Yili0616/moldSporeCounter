function varargout = moldcounter(varargin)
% MOLDCOUNTER MATLAB code for moldcounter.fig
%      MOLDCOUNTER, by itself, creates a new MOLDCOUNTER or raises the existing
%      singleton*.
%
%      H = MOLDCOUNTER returns the handle to a new MOLDCOUNTER or the handle to
%      the existing singleton*.
%
%      MOLDCOUNTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOLDCOUNTER.M with the given input arguments.
%
%      MOLDCOUNTER('Property','Value',...) creates a new MOLDCOUNTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before moldcounter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to moldcounter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help moldcounter

% Last Modified by GUIDE v2.5 24-Nov-2016 23:29:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @moldcounter_OpeningFcn, ...
                   'gui_OutputFcn',  @moldcounter_OutputFcn, ...
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


% --- Executes just before moldcounter is made visible.
function moldcounter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to moldcounter (see VARARGIN)

% Choose default command line output for moldcounter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes moldcounter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = moldcounter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
[a ,b] = uigetfile('*.*');
img1 = imread([b a]);
imshow(img1,'Parent',handles.axes1);
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
[a1 ,b1] = uigetfile('*.*');
img2 = imread([b1 a1]);
imshow(img2,'Parent',handles.axes2);
guidata(hObject,handles);



% --- calculate the number of pixels.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
A = getimage(handles.axes1);
B = getimage(handles.axes2);
[result] = moldcounter_NEW(A, B);

set(handles.text3,'string',result);
function [moldvolume] = moldcounter_NEW(filenametop, filenameside)
%%read in both images and extract matrix representing r values
    %top = imread(filenametop);
    %side = imread(filenameside);
    top = filenametop;
    side = filenameside;
    size1=size(top);
    size2=size(side);
    %mask=uint8(ones(size1(1),size1(2)).*255);
    topr = double(top(:,:,1));
    sider = double(side(:,:,1));
    topg = double(top(:,:,2));
    sideg = double(side(:,:,2));
    topb = double(top(:,:,3));
    sideb = double(side(:,:,3));

    %create mask representing pixels from top view with high mold concentrations
    tophighmoldmask = (topr<=95);
    %count number of pixels using this mask
    tophighmoldpix = sum(sum(tophighmoldmask));
    
    %create a mask which counts the number of white pixels from top view;

    test=(topr>=230)&(topg>=100)&(topb>=100);
    whiteTopPixel=sum(sum(test));
   
    
    %create mask representing pixels from side view with high mold concentrations
    sidemoldmask = (sider<=95);
    
    %create a mask which counts the number of white pixels from side view;

    test2=(sider>=230)&(sideg>=100)&(sideb>=100);
    %count number of pixels using this mask
    whiteSidePixel = sum(sum(test2));
    
    %calculate the average height of the mold on the sample
    sumcols = sum(sidemoldmask+whiteSidePixel);
    heightvec = nonzeros(sumcols);
    avgHeight = sum(heightvec)/length(heightvec);
   
    %compute volume
    moldvolume = (tophighmoldpix+whiteTopPixel) * avgHeight;
    
    %convert from cubic pixels to cubic mm
   
    
    
    


