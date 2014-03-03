function wuerfelText
%%%
%%% Wuerfelspiel Text Version
%%% to test AI
%%%

global player;

%share common functions with wuerfelGUI%
endOfTheGame = wuerfelGUI('endOfTheGame');
CPUmove = wuerfelGUI('CPUmove');
initializePlayer = initialDialog('initializePlayer');
%%

%%%
%Initialize Players
%%%

%
%Option 1: use this quick dialog to allow more players
%

numberHumans = str2double(input('How many human players are playing? \n','s'));
numberCPUs = str2double(input('How many CPU players are playing? \n','s'));
player = cell(1,numberHumans+numberCPUs);
for i=1:numberHumans
   playerName = input(['Please Enter Name of Human Player ' num2str(i) '\n'],'s');
   player{i} = initializePlayer(playerName);
end
for i=1:numberCPUs
   disp('For CPU players choose between Legal, Greedy, Snoopy, Smoothy, Harhar and Hyperbrain')
   playerName = input(['Please Enter Name of CPU Player ' num2str(i) '\n'],'s');
   playerName = [playerName ' (CPU)'];
   player{i+numberHumans} = initializePlayer(playerName);
end

%
%Option 2: hard code
%

% player = cell(1,1);
% player{1} = initializePlayer('Smoothy (CPU)');


roundNumber = 1;
while ~endOfTheGame(player)
%play game

    display('------------------')
    display(['<<<< ROUND ' num2str(roundNumber) ' >>>>'])
    rand('state',sum(100*clock))
    dice = ceil(rand(1,5)*6);
    
    for i=1:length(player)
        if ~player{i}.gameOver && player{i}.isHuman
            %let human play
            display('------------------')
            displayStats(player{i});
            display(['Dice roll: ' num2str(dice(1)) ',' num2str(dice(2)) ',' num2str(dice(3)) ',' num2str(dice(4)) ',' num2str(dice(5))])
            
            validChoice = false;
            while ~validChoice
                firstPair = str2double(input('Please enter your first pair: ','s'));
                secondPair = str2double(input('Please enter your second pair: ','s'));
                validChoice = isOK(player{i},dice,firstPair,secondPair);
            end
            player{i} = updatePlayer(player{i},firstPair,secondPair,sum(dice)-firstPair-secondPair);
            %
        elseif ~player{i}.gameOver && ~player{i}.isHuman
            %let CPU play
            display('------------------')
            displayStats(player{i});
            display(['Dice roll: ' num2str(dice(1)) ',' num2str(dice(2)) ',' num2str(dice(3)) ',' num2str(dice(4)) ',' num2str(dice(5))])
            
            player{i} = CPUmove(player{i},dice,'update');
            %
        else
             display([player{i}.name ' is game over with a final score of ' num2str(player{i}.score) '.'])
        end
    end
roundNumber = roundNumber+1;    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Below all function definitions exclusive to the text version %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function displayStats(p)
display(['Name: ' p.name])
display(['Removed Numbers: ' num2str(p.removedNumbersTable1) ' (' num2str(p.removedNumbersTable1howOften) ') ' num2str(p.removedNumbersTable2) ' (' num2str(p.removedNumbersTable2howOften) ') ' num2str(p.removedNumbersTable3) ' (' num2str(p.removedNumbersTable3howOften) ') '])
for number = {'Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten','Eleven','Twelve'}
    if ~eval(['p.number' number{1}])==0
        display(['Number ' number{1} ' has been chosen ' num2str(eval(['p.number' number{1}])) ' times.']) 
    end
end
display(['Current Total Score: ' num2str(p.score) '.'])
