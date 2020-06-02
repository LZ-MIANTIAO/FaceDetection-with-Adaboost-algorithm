function varargout = FaceDetector(varargin)
% 初始化结构体
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FaceDetector_OpeningFcn, ...
                   'gui_OutputFcn',  @FaceDetector_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初始化结构体结束，该段代码不需要编辑
end

% --- Executes just before FaceDetector is made visible.
function FaceDetector_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

handles.imgfilename=[];  % 文件名
handles.imgdata=[];      % 图像数据
handles.imgoutput=[];    % 输出图像   

set( handles.axes1, 'box', 'on' );
set( handles.axes1, 'box', 'on' );

guidata(hObject, handles);   % 更新 handles 结构体
end
% UIWAIT makes FaceDetector wait for user response (see UIRESUME)uiresume
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = FaceDetector_OutputFcn(hObject, eventdata, handles) 

    varargout{1} = handles.output;

end

% 选择图像按钮
function pushbutton1_Callback(hObject, eventdata, handles)
global flag;
flag = 0;
[imgfilename, imgpathname]=uigetfile({'*.jpg; *.png; *.bmp; *.png'},'Select a RGB image');
if imgfilename
    set(handles.edit1, 'String', '图像待检测');
    imgdata = imread([imgpathname '\' imgfilename]);
    handles.imgdata = imgdata;
    image(handles.axes1,imgdata);
    set( handles.axes1, 'visible', 'off');
    handles.imgfilename = imgfilename;
end
guidata(hObject,handles); % 更新 handles 结构体
end

% 开始检测按钮
function pushbutton2_Callback(hObject, eventdata, handles)
global value;
if ~isempty(handles.imgfilename)
    set(handles.edit1, 'String', '检测中......');
%     Y_img = YCbCr(handles.imgdata);
    switch value
        case 1
            [imgoutput, Detection_time, face_num] = FaceDetection(handles.imgdata);
        case 2
            [imgoutput, Detection_time, face_num] = YCB(handles.imgdata);
    end
    set(handles.edit1, 'String', Detection_time);
    set(handles.edit2, 'String', ['检测到人脸数为：',num2str(face_num), '个']);
    image(handles.axes1,imgoutput);
    set( handles.axes1, 'visible', 'off');
    handles.imgoutput = imgoutput;
else
    set(handles.edit1, 'String', '无图像数据');
end
guidata(hObject,handles); % 更新 handles 结构体
end

% 开启摄像头按钮
function pushbutton3_Callback(hObject, eventdata, handles)
global flag value;
flag = 1;
% 'YUY2_160x120'，'YUY2_176x144'，'YUY2_320x240''YUY2_352x288'，'YUY2_640x480'
vid = videoinput('winvideo',1 ,'YUY2_176x144');
triggerconfig(vid,'manual'); % 设置触发为人为模式
start(vid); % 触发要求
try
    while flag == 1
        frame = getsnapshot(vid); % 捕获图像
        handles.imgdata = ycbcr2rgb(frame); % 色彩空间转换为彩色图
        %frame=rgb2gray(frame);
%         image(handles.axes1,handles.imgdata);
%         set(handles.axes1, 'visible', 'off');
        switch value
                case 1
                    [imgoutput, ~, face_num] = FaceDetection(handles.imgdata);
                case 2
                    [imgoutput, ~, face_num] = YCB(handles.imgdata);
        end
        set(handles.edit1, 'String', '实时检测中……');
        set(handles.edit2, 'String', ['检测到人脸数为：',num2str(face_num), '个']);
        image(handles.axes1,imgoutput);
        set(handles.axes1, 'visible', 'off');
        handles.imgoutput = imgoutput;        
        guidata(hObject,handles); % 更新 handles 结构体

        drawnow;        % 实时更新图像
    end
    delete(vid);
catch
    warning('runing has error');
    flag = 0;
    delete(vid);
    set(handles.edit1, 'String', '检测异常');        
end 
guidata(hObject,handles); % 更新 handles 结构体
end

% 关闭摄像头按钮
function pushbutton4_Callback(hObject, eventdata, handles)

set(handles.edit1, 'String', '检测结束');      
global flag;
flag = 0;
clc,clear; % 显示结束后清空变量，为下次运行节省内存
end

% 保存图像按钮
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile({'*.jpg','JPEG(*.jpg)';...
                                 '*.bmp','Bitmap(*.bmp)';...
                                 '*.gif','GIF(*.gif)';...
                                 '*.png','Png(*.png)';...
                                 '*.*',  'All Files (*.*)'},...
                                 'Save Picture','Untitled');
if FileName==0    
    return;
else
    imwrite(handles.imgoutput,[PathName,FileName]);
end
clc,clear; % 显示结束后清空变量，为下次运行节省内存
end

% 退出按钮
function pushbutton6_Callback(hObject, eventdata, handles)
close all;
global flag;
flag = 0;
clear;
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

end
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% 选择纯ada还是结合肤色
function kongjian_Callback(hObject, eventdata, handles)
global value;
value = get(handles.kongjian,'value');
guidata(hObject,handles); % 更新 handles 结构体
end
function kongjian_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
