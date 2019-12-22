function varargout = SAPIKU(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAPIKU_OpeningFcn, ...
                   'gui_OutputFcn',  @SAPIKU_OutputFcn, ...
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


% --- Executes just before SAPIKU is made visible.
function SAPIKU_OpeningFcn(hObject, eventdata, handles, varargin)
% 
% Choose default command line output for SAPIKU
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = SAPIKU_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% mengekstrasi fitur-fitur HSV
function ekstrasiHSV_Callback(hObject, eventdata, handles)
    global gambarnya HSV
    HSV
    a = [1 2 3; 3 4 5; 6 7 8];
    [mean, deviasi, kewnya] = fungsi_ekstrasi(a);

    hasilHSV(1,1)=mean
    hasilHSV(1,2)=deviasi
    hasilHSV(1,3)=kewnya
    set(handles.tabelhasil,'Data',hasilHSV);


% --- Executes on button press in EkstrakDS.
% mengekstrasi Semua Data
function EkstrakDS_Callback(hObject, eventdata, handles)
    set(handles.status_ekstrasi,'String','On Proses Bro');
    global fitur_hsv
    fitur_hsv = zeros(200,4);
    
    for x=1:100
        I = strcat('C:\Users\NanK\Documents\MATLAB\PCD\SEGAR\',int2str(x),'.jpg');
        I = imread(I);
        I = rgb2hsv(I);
        [mean, deviasi, kewnya] = fungsi_ekstrasi(I);

        fitur_hsv(x,1)=mean
        fitur_hsv(x,2)=deviasi
        fitur_hsv(x,3)=kewnya
        fitur_hsv(x,4)=2
    end

    for x=1:100
        I = strcat('C:\Users\NanK\Documents\MATLAB\PCD\NON SEGAR\',int2str(x),'.jpg');
        I = imread(I);
        I = rgb2hsv(I);
        [mean, deviasi, kewnya] = fungsi_ekstrasi(I);

        fitur_hsv(x+100,1)=mean
        fitur_hsv(x+100,2)=deviasi
        fitur_hsv(x+100,3)=kewnya
        fitur_hsv(x+100,4)=1
    end

        set(handles.status_ekstrasi,'String','Selesai');
        set(handles.tabelhasil,'Data',fitur_hsv);

    hasinya = strcat('C:\Users\NanK\Documents\MATLAB\PCD\Ekstraksi.xlsx');
    xlswrite(hasinya,fitur_hsv);


% --- Executes on button press in TrainingData.
function TrainingData_Callback(hObject, eventdata, handles)
    global fitur_hsv HasilTraining
    HasilTraining = svmtrain(fitur_hsv(:,1:2),fitur_hsv(:,4));
    hasilnya = strcat('C:\Users\NanK\Documents\MATLAB\PCD\Training.mat');
    save(hasilnya,'HasilTraining');


% --- Executes on button press in DataTest.
function DataTest_Callback(hObject, eventdata, handles)
    global gambar_tes HSV
    [filename,pathname] = uigetfile('*.jpg');
    gambar_tes = imread(fullfile(pathname,filename));
    axes(handles.GambarTest);
    imshow(gambar_tes);
    HSV = rgb2hsv(gambar_tes);
    axes(handles.testHSV);
    imshow(HSV);
    
    [mean, deviasi, kewnya] = fungsi_ekstrasi(HSV);

    hasilHSV(1,1)=mean
    hasilHSV(1,2)=deviasi
    hasilHSV(1,3)=kewnya
    set(handles.hasiltest,'Data',hasilHSV);


% --- Executes on button press in TestData.
function TestData_Callback(hObject, eventdata, handles)
   

    global gambar_tes HasilTraining
    HSV_testing = rgb2hsv(gambar_tes);
    [mean, deviasi, kewnya] = fungsi_ekstrasi(HSV_testing);
    testing_hsv(1,1)=mean
    testing_hsv(1,2)=deviasi
    testing_hsv(1,3)=kewnya
    HasilTraining
    svm = svmclassify(HasilTraining,testing_hsv(:,1:2))
    if svm == 2
        status = 'SEGAR';
    else
        status = 'BURUK';
    end
    set(handles.hasil_tes,'String',status);
