function varargout = face_points(varargin)
% FACE_POINTS MATLAB code for face_points.fig
%      FACE_POINTS, by itself, creates a new FACE_POINTS or raises the existing
%      singleton*.
%
%      H = FACE_POINTS returns the handle to a new FACE_POINTS or the handle to
%      the existing singleton*.
%
%      FACE_POINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACE_POINTS.M with the given input arguments.
%
%      FACE_POINTS('Property','Value',...) creates a new FACE_POINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before face_points_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to face_points_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help face_points

% Last Modified by GUIDE v2.5 20-Feb-2017 21:08:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @face_points_OpeningFcn, ...
                   'gui_OutputFcn',  @face_points_OutputFcn, ...
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


% --- Executes just before face_points is made visible.
function face_points_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to face_points (see VARARGIN)

% Choose default command line output for face_points
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%定义两个全局变量  
global ButtonDown pos1;  
ButtonDown =[];  
pos1=[];  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


% Update handles structure
root_name = '.\dataset\';
handles.root_name = root_name;

picture_num = 1;
handles.picture_num = picture_num;
pts = zeros(68,2);
handles.pts = pts;
std_pts = zeros(68,2);
handles.std_pts = std_pts;

picture_name = '';
handles.picture_name=picture_name;
wrong_point = [0 0];
% wrong_points = zeros(68,2);
handles.wrong_point=wrong_point;
num_wrong_point = 0;
handles.num_wrong_point=num_wrong_point;
% wrong_points_seq = zeros(68,1);
% handles.wrong_points_seq = wrong_points_seq;
correct_seq = zeros(68,3);
handles.correct_seq = correct_seq;
handles.correct_times = 0;

% right_point = [0 0];
% handles.right_point=right_point;

guidata(hObject, handles);
% UIWAIT makes face_points wait for user response (see UIRESUME)
set(gca,'xtick',[])%去掉x轴的刻度

set(gca,'ytick',[]) %去掉xy轴的刻度

set(gca,'xtick',[],'ytick',[]) %同时去掉x轴和y轴的刻度
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = face_points_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Show_image.
function Show_image_Callback(hObject, eventdata, handles)
% hObject    handle to Show_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global threshold;
root_name = handles.root_name;
picture_num = handles.picture_num;
% image_name = compose_name(picture_name,picture_num);
image_name = [root_name num2str(picture_num)];
img = imread([image_name '.jpg']);
pts = read_points([image_name '.txt']);
handles.picture_name=image_name;
handles.pts = pts;

axes(handles.axes1)
imshow(img);
hold on;
h1=plot(pts(:,1), pts(:,2), 'b.','Markersize',8);
for i = 1:5:size(pts,1)
    text(pts(i,1), pts(i,2), num2str(i));
end
handles.point_graph = h1;
handles.correct_times = 0;
dis = 1000*ones(68*68,1);
for i = 1:1:68
    for j = 1:1:68
        if i ~=j
        dis(68*(i-1)+j) = abs(pts(i,1)-pts(j,1))+abs(pts(i,2)-pts(j,2));
        end        
    end
end
threshold = min(dis);

% wrong_points_seq = zeros(68,1);
% handles.wrong_points_seq = wrong_points_seq;
% right_points_seq = zeros()
correct_seq = zeros(68,3);
handles.correct_seq = correct_seq;
guidata(hObject,handles)
% hold on;
% for i = 1:size(pts,1)
%     text(pts(i,1), pts(i,2), num2str(i));
% end
% main(h1)
% a=get(gca,'Currentpoint');
% plot(a(1,1),a(1,2),'r*')
% hold off;

% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%鼠标按下事件响应
global pos0 threshold std;
threshold
pts = handles.pts;
global ButtonDown pos1;  
if(strcmp(get(gcf,'SelectionType'),'normal'))%判断鼠标按下的类型，mormal为左键     
    pos1=get(handles.axes1,'CurrentPoint');%获取坐标轴上鼠标的位置
    pos0 = pos1;
    x=pos1(1,1);
    y=pos1(1,2);
    for i = 1:1:68
        dis(i) = abs(x-pts(i,1))+abs(y-pts(i,2));
    end
    [min_dis,n]=min(dis);
    %%%% 上传错误点号 %%%%
    handles.num_wrong_point=n;
    correct_times = handles.correct_times;
    std_pts = handles.std_pts;
    
    correct_seq = handles.correct_seq;
    n
    guidata(hObject,handles);
    
    if min_dis < threshold
        correct_times = correct_times + 1; % 改正次数加一，未考虑点没有移动的情况，所以在后面添加了取消的操作
        correct_seq(correct_times,1) = n;
        
        axes(handles.axes2);    
        std = plot(std_pts(n,1),std_pts(n,2),'r*');
        axes(handles.axes1);
        ButtonDown=1;
%         set(handles.edit1,'string',['选定点为' num2str(n)]);
    else
%         set(handles.edit1,'string',['选定失败，请重新选定']); 
    end
    handles.correct_seq=correct_seq;
    handles.correct_times = correct_times;
%     correct_times
%     plot(pos1(1,1),pos1(1,2),'y+')
    guidata(hObject,handles);
end

% ButtonDown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%鼠标运动事件的响应 
% global lines;
global ButtonDown pos1 pos0;
correct_times = handles.correct_times;
if ButtonDown == 1  
    pos = get(handles.axes1, 'CurrentPoint');%获取当前位置  
    pos1 = pos;%更新  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% --- Executes on mouse press over figure background, over a disabled or  
% --- inactive control, or over an axes background.  
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)  
% hObject    handle to figure1 (see GCBO)  
% eventdata  reserved - to be defined in a future version of MATLAB  
% handles    structure with handles and user data (see GUIDATA)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%鼠标按键抬起的响应事件  
global ButtonDown;
global show_points;
global pos1;
global pos0;
global lines;
global std;
correct_times = handles.correct_times;
if ButtonDown == 1
    pos = get(handles.axes1, 'CurrentPoint');%获取当前位置            
    show_points(correct_times) = plot(pos(1,1),pos(1,2),'b.','Markersize',8); 
    handles.right_point=[pos(1,1) pos(1,2)];
    correct_seq = handles.correct_seq;
    correct_times = handles.correct_times;
    correct_seq(correct_times,2) = pos(1,1);
    correct_seq(correct_times,3) = pos(1,2);
    handles.correct_seq = correct_seq;
    lines(correct_times) = line([pos1(1, 1) pos0(1, 1)], [pos1(1, 2) pos0(1, 2)], 'LineWidth', 0.5,'LineStyle','-');%划线
    delete(std);
    if pos0 ==pos1 %如果位置位置不动，就取消上次
        Undo_Callback(hObject, eventdata, handles);
    end
    guidata(hObject,handles);    
end
% delete(std);
ButtonDown = 0;

% ButtonDown

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  



% --- Executes on button press in Sure_to_correct.
function Sure_to_correct_Callback(hObject, eventdata, handles)
% hObject    handle to Sure_to_correct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 确定修改，将修改写入文件中
picture_name = handles.picture_name;
correct_seq = handles.correct_seq;
correct_times = handles.correct_times;
for i = 1:1:correct_times
    n=handles.correct_seq(i,1);
    n
    newData = [correct_seq(i,2) correct_seq(i,3)];
    replace(n,newData,picture_name)
end
 
Show_image_Callback(hObject, eventdata, handles)

% --- Executes on button press in Next_picture.
function Next_picture_Callback(hObject, eventdata, handles)
% hObject    handle to Next_picture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%% 下一张图片
picture_num = handles.picture_num;
picture_num = picture_num + 1;
handles.picture_num = picture_num;
guidata(hObject,handles)
Show_image_Callback(hObject, eventdata, handles)




%%% Add new function %%%% 
function replace(n,newData,picture_name)
%% 替代某一个点
replaceLine = n+1;
myformat = '%.6f %.6f\n';
% move the file position marker to the correct line
fid = fopen([picture_name '.txt'],'rt+');
for k=1:(replaceLine-1)
   fgetl(fid);
end
% call fseek between read and write operations
fseek(fid, 0, 'cof');
fprintf(fid, myformat, newData);
fclose(fid);    

function image_name=compose_name(name,picture_num)
    %% 合成文件名
    if picture_num<10
        image_name = [name '000' num2str(picture_num)];
    elseif picture_num<100
        image_name = [name '00' num2str(picture_num)];
    elseif picture_num<1000
        image_name = [name '0' num2str(picture_num)];
    else 
        image_name = [name num2str(picture_num)];
    end

                
           
function pts = read_points(file)
% 读取点
    data = importdata(file);
    all_num=data(1); 
    for i = 1:1:all_num
        pts(i,1)=data(2*i);
        pts(i,2)=data(2*i+1);
    end


% --- Executes on button press in Undo.
function Undo_Callback(hObject, eventdata, handles)
% hObject    handle to Undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 取消上次标记
global lines show_points

correct_times = handles.correct_times;
correct_times
if correct_times > 0
    delete(lines(correct_times));
    delete(show_points(correct_times));
    correct_times = correct_times - 1;
    handles.correct_times = correct_times;
    guidata(hObject,handles);
end
correct_times


% --- Executes on button press in Show_std.
function Show_std_Callback(hObject, eventdata, handles)
% hObject    handle to Show_std (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 显示标准图片
img = imread('.\dataset\std.jpg');
std_pts = read_points('.\dataset\std.txt');
handles.std_pts = std_pts;
axes(handles.axes2)
imshow(img);
hold on;
plot(std_pts(:,1), std_pts(:,2), 'b.','MarkerSize',8);
% scatter(std_pts(:,1),std_pts(:,2),'b.','MarkerSize','18')
guidata(hObject,handles);
