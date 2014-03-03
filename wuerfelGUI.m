function varargout = wuerfelGUI(varargin)

%%%The following for loop is for test purposes with xUnit test only.%%%
%add functions that you want to be able to test
for functionName = {'playerSettings','CPUmove','endOfTheGame'}
    if ~isempty(varargin)
        if ischar(varargin{1}) && strcmp(varargin{1},functionName{1})
            varargout = eval(['{@' varargin{1} '};']); 
            return
        end
    end
end
%%%Now tests are run the following way. Type in command line:%%%
%>> addpath 'xunit' %only necessary once per session, of course.
%>> runtests
% Note: Matlab2013 has its own unit testing. This is not used here.
%%%


% WUERFELGUI MATLAB code for wuerfelGUI.fig
%      wuerfelGUI, by itself, creates a new WUERFELGUI or raises the existing
%      singleton*.
%
%      H = WUERFELGUI returns the handle to a new WUERFELGUI or the handle to
%      the existing singleton*.
%
%      WUERFELGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WUERFELGUI.M with the given input arguments.
%
%      WUERFELGUI('Property','Value',...) creates a new WUERFELGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wuerfelGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wuerfelGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wuerfelGUI

% Last Modified by GUIDE v2.5 11-Jun-2013 17:52:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wuerfelGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @wuerfelGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_wurfelfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Below all interactions with GUI %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Function definitions at the end of the file %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes just before wuerfelGUI is made visible.
function wuerfelGUI_OpeningFcn(hObject, eventdata, handles, varargin)
global player;
global scoreMatrix;

% Choose default command line output for wuerfelGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

%dialog to get the players 
player = initialDialog;
scoreMatrix = zeros(1+length(player),25); %expect 24 rounds of play, keep first row as zeros.

%%%Now prepare for first die roll%%%
set(handles.showPlayer,'Value',1);
set(handles.showPlayer,'String',player{1}.name);
set(handles.pushNextPlayer,'Visible','off');
set(handles.showWinner,'Visible','off');
set(handles.textChooseYourTwoNumberPairs,'Visible','off');
set(handles.firstPair,'Visible','off');
set(handles.secondPair,'Visible','off');
set(handles.showRemovedNumber,'Visible','off');



% --- Outputs from this function are returned to the command line.
function varargout = wuerfelGUI_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushRollDice.
function pushRollDice_Callback(hObject, eventdata, handles)
global player;
global scoreMatrix;

scoreMatrix = plotScoreMatrix(scoreMatrix,player);

set(handles.pushRollDice,'Visible','off');

%%%First check if end of the game is reached%%%
endOfGame = endOfTheGame(player,handles);

%%%If not, game goes on. So roll die%%%
if ~endOfGame;
%rng('shuffle') %newer Matlab versions should use shuffle instead of state
rand('state',sum(100*clock))
dice = ceil(rand(1,5)*6);
for i=1:5
    eval(['set(handles.dice' num2str(i) ', ''String'', num2str(dice(' num2str(i) ')))'])
    eval(['set(handles.dice' num2str(i) ', ''Value'', dice(' num2str(i) '))'])
end
%%%

%%%Now prepare for 1st player to play%%%
%%%activate choice buttons for 1st player if and only if he is human and not game over%%%
if player{1}.isHuman && ~player{1}.gameOver
	set(handles.textChooseYourTwoNumberPairs,'Visible','on');
    set(handles.firstPair,'Visible','on');
    set(handles.secondPair,'Visible','on');
    set(handles.showRemovedNumber,'Visible','on');
    isOK(player{1},dice,get(handles.firstPair,'Value')+1,get(handles.secondPair,'Value')+1,handles);    
else
    set(handles.pushNextPlayer,'Visible','on')
    set(handles.textChooseYourTwoNumberPairs,'Visible','off');
    set(handles.firstPair,'Visible','off');
    set(handles.secondPair,'Visible','off');
    set(handles.showRemovedNumber,'Visible','off');
    %additionally, make computer move if 1st player is not human and not game over
    if ~player{1}.isHuman && ~player{1}.gameOver 
        player{1} = CPUmove(player{1},dice,'update');
    end
    %need to take care of a special case: Only one CPU player
    if ~player{1}.isHuman && length(player)==1
        set(handles.pushNextPlayer,'Visible','off');
        set(handles.pushRollDice,'Visible','on');
    end

end
%%%
set(handles.showPlayer,'Value',1);
playerSettings(handles,player{1});
end



% --- Executes on button press in pushCommit.
function pushCommit_Callback(hObject, eventdata, handles)
global player;

set(handles.pushCommit,'Visible','off');
set(handles.textChooseYourTwoNumberPairs,'Visible','off');
set(handles.firstPair,'Visible','off');
set(handles.secondPair,'Visible','off');
set(handles.showRemovedNumber,'Visible','off');

%%%update current player and display%%%
current = get(handles.showPlayer,'Value');

removedNumber = get(handles.dice1,'Value') + get(handles.dice2,'Value') + get(handles.dice3,'Value') + get(handles.dice4,'Value') + get(handles.dice5,'Value') - (get(handles.firstPair,'Value')+1) - (get(handles.secondPair,'Value')+1);

player{current} = updatePlayer(player{current},get(handles.firstPair,'Value')+1,get(handles.secondPair,'Value')+1,removedNumber);
playerSettings(handles,player{current});
%%%

%%%prepare for pushNextPlayer or pushRollDice%%%
if current == length(player)
    set(handles.pushRollDice,'Visible','on');
else
    set(handles.pushNextPlayer,'Visible','on');
end




% --- Executes on button press in pushNextPlayer.
function pushNextPlayer_Callback(hObject, eventdata, handles)
global player;

set(handles.pushNextPlayer,'Visible','off');
endOfGame = endOfTheGame(player,handles);

if ~endOfGame

current=get(handles.showPlayer,'Value'); %Note: current can not be last player, pushCommit takes care of this
playerSettings(handles,player{current+1});
set(handles.showPlayer,'Value',current+1);

if player{current+1}.gameOver
    if current+1==length(player)
        set(handles.pushRollDice,'Visible','on');
    else
        set(handles.pushNextPlayer,'Visible','on');
    end
else
    dice = [get(handles.dice1,'Value'), get(handles.dice2,'Value'), get(handles.dice3,'Value'), get(handles.dice4,'Value'), get(handles.dice5,'Value')];
    if player{current+1}.isHuman %next player not gameOver and human
        set(handles.textChooseYourTwoNumberPairs,'Visible','on')
        set(handles.firstPair,'Visible','on');
        set(handles.secondPair,'Visible','on');
        set(handles.showRemovedNumber,'Visible','on');
        isOK(player{current+1}, dice, get(handles.firstPair,'Value')+1, get(handles.secondPair,'Value')+1, handles);
    else %next player not gameOver and not human
        player{current+1} = CPUmove(player{current+1},dice,'update');
        playerSettings(handles,player{current+1});
        if current+1 == length(player)
           set(handles.pushRollDice,'Visible','on');
        else
            set(handles.pushNextPlayer,'Visible','on');
        end
    end    
end

else
current=get(handles.showPlayer,'Value');
if current == length(player)
    current=0;
end
allScores = zeros(1,length(player));
for i = 1:length(player)
    allScores(i) = player{i}.score;
end
winningIndex = find(allScores==max(allScores),1,'first');
player{winningIndex}.winner = 1;
playerSettings(handles,player{current+1});
set(handles.showPlayer,'Value',current+1);  
set(handles.pushNextPlayer,'Visible','on');
end


% --- Executes on selection change in firstPair.
function firstPair_Callback(hObject, eventdata, handles)
global player;
current=get(handles.showPlayer,'Value');
        isOK(player{current}, [get(handles.dice1,'Value'), get(handles.dice2,'Value'), get(handles.dice3,'Value'), get(handles.dice4,'Value'), get(handles.dice5,'Value')], get(handles.firstPair,'Value')+1, get(handles.secondPair,'Value')+1, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns firstPair contents as cell array
%        contents{get(hObject,'Value')} returns selected item from firstPair

% --- Executes during object creation, after setting all properties.
function firstPair_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in secondPair.
function secondPair_Callback(hObject, eventdata, handles)
global player;
current=get(handles.showPlayer,'Value');
        isOK(player{current}, [get(handles.dice1,'Value'), get(handles.dice2,'Value'), get(handles.dice3,'Value'), get(handles.dice4,'Value'), get(handles.dice5,'Value')], get(handles.firstPair,'Value')+1, get(handles.secondPair,'Value')+1, handles);


        
% --- Executes during object creation, after setting all properties.
function secondPair_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Below all function definitions that are called by the GUI %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function playerSettings(handles,p)
counter=2;

%%%%%Disp name in the box
set(handles.showPlayer,'String',p.name);

%%%%Set color orange if player is gameover.
if (~p.gameOver) || p.winner
    set(handles.showPlayer,'BackgroundColor',[0 1 0]);
    set(handles.score,'BackgroundColor',[0 1 0]);
else
     set(handles.showPlayer,'BackgroundColor',[0.85 0.5 0]);
     set(handles.score,'BackgroundColor',[0.85 0.5 0]);
end

%%%Update strings and colors on score sheet%%%
for number = {'Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten','Eleven','Twelve'}
    text1=eval(['num2str(p.number' number{1} ')']);
    text2=eval(['num2str(p.score' number{1} ')']);
    text3=['Number ' num2str(counter) ' has been chosen ' text1 ' times for a score of ' text2];
    set(eval(['handles.number' number{1} ]),'String',text3);
    
    if eval(['p.score' number{1}]) == 0 && eval(['p.number' number{1}]) ~= 0
    set(eval(['handles.number' number{1} ]),'ForegroundColor','k');
    elseif eval(['p.score' number{1}]) == 0 && eval(['p.number' number{1}]) == 0
    set(eval(['handles.number' number{1} ]),'ForegroundColor',[0.5 0.5 0.5]);
    elseif eval(['p.score' number{1}]) == -200
    set(eval(['handles.number' number{1} ]),'ForegroundColor','r');
    elseif eval(['p.score' number{1}]) >0
    set(eval(['handles.number' number{1} ]),'ForegroundColor',[0 0.7 0]);
    end

    counter=counter+1;
end
%%%

%%%Update strings of removedNumbersTable. Remove string if value == 0
for number = 1:3
    if eval(['p.removedNumbersTable' num2str(number)]) == 0
        set(eval(['handles.removedNumbersTable' num2str(number)]),'String',' ');
        set(eval(['handles.removedNumbersTable' num2str(number) 'howOften']),'String',' ');
    else
        set(eval(['handles.removedNumbersTable' num2str(number)]),'String',num2str(eval(['p.removedNumbersTable' num2str(number)])));
        set(eval(['handles.removedNumbersTable' num2str(number) 'howOften']),'String',num2str(eval(['p.removedNumbersTable' num2str(number) 'howOften'])));  
    end
end
%%%

%%%Update score
set(handles.score,'String',['Current Total Score: ' num2str(p.score)]);




function vectorORplayer=CPUmove(p,dice,varargin)
%last argument is either empty (return vector: [firstPair,secondPair,removedNumber]) or 'update' (returns struct: updated player)

checkForFoulPlayers = getAllPlayers();

[firstPair, secondPair, removedNumber]=cpu_moves(p,dice);

if ~isOK(p,dice,firstPair,secondPair) || ~isequal(checkForFoulPlayers,getAllPlayers())
    disp(['Warning: This is a non-legal move. Better double check' p.name])
end 

disp(['My name is ' p.name '. I choose ' num2str(firstPair) ' and ' num2str(secondPair) ', which leaves ' num2str(removedNumber) '.'])

if isempty(varargin)
    vectorORplayer = [firstPair, secondPair, removedNumber];
else
    vectorORplayer = updatePlayer(p,firstPair,secondPair,removedNumber);
end




function theEnd = endOfTheGame(player,varargin)

theEnd=0;
for i = 1:length(player)
    theEnd = theEnd+player{i}.gameOver;
end

if theEnd == length(player)  
    alreadyEnded = 'off';
    allScores = zeros(1,length(player));
    for i = 1:length(player)
        allScores(i) = player{i}.score;
    end
    winningIndex = find(allScores==max(allScores),1,'first');
    winnerName = player{winningIndex}.name;
    winnerScore = player{winningIndex}.score;
    
    if ~isempty(varargin)
        handles = varargin{1};
        alreadyEnded = get(handles.showWinner,'Visible');
        set(handles.showWinner,'String', ['Winner: ' winnerName]);
        set(handles.showWinner,'Visible','on');
        set(handles.score,'String',['Winner Score: ' num2str(winnerScore)]);
        set(handles.score,'BackgroundColor',[0 1 0]);
        set(handles.pushNextPlayer,'Visible','on');
    end
 
     if strcmp(alreadyEnded,'off')
        display('======================')
        display(['The winner is ' winnerName ' with a score of ' num2str(winnerScore) '.'])
        display('======================')
    end

    theEnd=1;
else
    theEnd=0;
end


function scoreMatrix=plotScoreMatrix(scoreMatrix,player)
%updates and plots scoreMatrix, then returns updated scoreMatrix
numberPlayedRounds = max(scoreMatrix(1,:));
scoreMatrix(2:length(player)+1,1+numberPlayedRounds) = cellfun(@(x) x.score,player,'UniformOutput',true);
if numberPlayedRounds ~= 0
    plotMatrix = scoreMatrix(:,1:1+numberPlayedRounds);  
    plot(plotMatrix(1,:),plotMatrix(2:length(player)+1,:)','LineWidth',3);
    legend(cellfun(@(x) x.name,player,'UniformOutput',false),'Location','SouthWest');
    set(gca,'XTick',0:numberPlayedRounds);
    xlim([0,numberPlayedRounds]);
end
scoreMatrix(1,2+numberPlayedRounds) = numberPlayedRounds+1;
