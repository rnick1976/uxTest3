function player = initialDialog(varargin)


%This loop is to allow testing
for functionName = {'initializePlayer','select'}
    if ~isempty(varargin)
        if ischar(varargin{1}) && strcmp(varargin{1},functionName{1})
            player = eval(['{@' varargin{1} '};']);
            player = player{1}; %extra line necessary since output is cell otherwise
            return   
        end
    end
end
%done testing. See main file wuerfelGUI for details.


mainWindow = figure('MenuBar','none',...
                    'Name','Choose CPU players',...
                    'NumberTitle','off',...
                    'Toolbar','none',...
                    'Visible','on',...
                    'Units','centimeters',...
                    'Position',[10,10,10,12]);

dialog = uipanel('Parent',mainWindow,'Position',[0,0,1,1],'BackgroundColor',[1 0.84 0]);


%Human Players
uicontrol(dialog,'Style','edit','String','Type your name','FontSize',17.0,'FontWeight','bold',...
          'Units','normalized','pos',[0,6/7,1,1/7],'BackgroundColor',[0.68 1 0.18]);
uicontrol(dialog,'Style','edit','String','-','FontSize',17.0,'FontWeight','bold',...
          'Units','normalized','pos',[0,5/7,1,1/7],'BackgroundColor',[0.2 0.8 0.2]);
uicontrol(dialog,'Style','edit','String','-','FontSize',17.0,'FontWeight','bold',...
          'Units','normalized','pos',[0,4/7,1,1/7],'BackgroundColor',[0.15 0.55 0.15]);

      
%CPUs (Make sure to keep the leading blank in the CPU-name string!)
uicontrol(dialog,'Style','checkbox','String',' Legal','FontSize',16.0,'FontWeight','bold',...
          'Units','normalized','pos',[0,3/7,1/2,1/7],'BackgroundColor',[1 0.95 1]);
uicontrol(dialog,'Style','checkbox','String',' Greedy','FontSize',16.0,'FontWeight','bold',...
          'Units','normalized','pos',[1/2,3/7,1,1/7],'BackgroundColor',[1 0.90 1]);
uicontrol(dialog,'Style','checkbox','String',' Smoothy', 'FontSize',16.0,'FontWeight','bold',...
          'Units','normalized','pos',[0,2/7,1,1/7],'BackgroundColor',[1 0.80 1]);
uicontrol(dialog,'Style','checkbox','String',' Snoopy', 'FontSize',16.0,'FontWeight','bold',...
          'Units','normalized','pos',[1/3,2/7,1,1/7],'BackgroundColor',[1 0.75 1]);
uicontrol(dialog,'Style','checkbox','String',' Harhar', 'FontSize',16.0,'FontWeight','bold',...
          'Units','normalized','pos',[2/3,2/7,1,1/7],'BackgroundColor',[1 0.70 1]);
uicontrol(dialog,'Style','checkbox','String',' Hyperbrain', 'FontSize',16.0,'FontWeight','bold',...
          'Units','normalized','pos',[0,1/7,2,1/7],'BackgroundColor',[1 0.50 1]);
%CPU strength      
uicontrol(dialog,'Style','text','String','Easy','FontSize',12.0,'FontWeight','bold',...
          'Units','normalized','pos',[0.5-1/16,3.7/7,1/8,1/25],'BackgroundColor',[1 1 1]);
uicontrol(dialog,'Style','text','String','Medium','FontSize',12.0,'FontWeight','bold',...
          'Units','normalized','pos',[0.5-1/8,2.7/7,1/4,1/25],'BackgroundColor',[1 .75 1]);
uicontrol(dialog,'Style','text','String','Hard','FontSize',12.0,'FontWeight','bold',...
          'Units','normalized','pos',[0.5-1/16,1.7/7,1/8,1/25],'BackgroundColor',[1 .5 1]);

 
%Start button
uicontrol(dialog,'Style','togglebutton' ,'String','Start','FontSize',20.0,'FontWeight','bold',...
    'Unit','normalized','pos',[1/3,0,1/3,1/7],'Callback','uiresume(gcbf)','BackgroundColor',[1 1 0]);
uiwait(gcf); 
player = select;
close;
end 


function player=select

humanNames = get(findobj('Style','edit'),'String');
humanNames = humanNames(~logical(strcmp('-',humanNames)) & ~logical(strcmp('Type your name',humanNames)));
numberHumans = length(humanNames);
player = cellfun(@initializePlayer,humanNames,'UniformOutput',false);

CPUsChecked = get(findobj('Style','checkbox'),'Value');
CPUnames = get(findobj('Style','checkbox'),'String');
CPUnames = CPUnames(logical(cell2mat(CPUsChecked)));
    
for i=1:length(CPUnames)
    name = CPUnames{i};
    name = [name(2:end) ' (CPU)'];
    player{numberHumans+i} = initializePlayer(name);
end

end



function p=initializePlayer(name)

p.name = name;
p.score = 0;
p.gameOver=0;
p.winner=0;
p.isHuman = isempty(strfind(name,'(CPU)'));

p.removedNumbersTable1=0;
p.removedNumbersTable1howOften=0;
p.removedNumbersTable2=0;
p.removedNumbersTable2howOften=0;
p.removedNumbersTable3=0;
p.removedNumbersTable3howOften=0;

for number = {'Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten','Eleven','Twelve'}
    eval(['p.number' number{1} ' = 0;']);
    eval(['p.score' number{1} ' = 0;']);
end

end