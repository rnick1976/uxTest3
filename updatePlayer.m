function p=updatePlayer(varargin)
%This loop is to allow testing
for functionName = {'addNumbers','addRemovedNumber'}
    if ~isempty(varargin)
        if ischar(varargin{1}) && strcmp(varargin{1},functionName{1})
            p = eval(['{@' varargin{1} '};']);
            p = p{1}; %extra line necessary since output is cell otherwise
            return
        end
    end
end
%done testing. See mein file wuerfelGUI for details.

p=varargin{1};
firstPair=varargin{2};
secondPair=varargin{3};
removedNumber=varargin{4};

p = addNumbers(p,firstPair,secondPair);
p.score = p.scoreTwo+p.scoreThree+p.scoreFour+p.scoreFive+p.scoreSix+p.scoreSeven+p.scoreEight+p.scoreNine+p.scoreTen+p.scoreEleven+p.scoreTwelve;
p = addRemovedNumber(p,removedNumber);
p.gameOver = any([p.removedNumbersTable1howOften,p.removedNumbersTable2howOften,p.removedNumbersTable3howOften] > 7);
end




function p=addNumbers(p,firstPair,secondPair)

playerNumberVector = [p.numberTwo p.numberThree p.numberFour p.numberFive p.numberSix p.numberSeven p.numberEight p.numberNine p.numberTen p.numberEleven p.numberTwelve];

playerNumberVector(firstPair-1) = playerNumberVector(firstPair-1)+1;
playerNumberVector(secondPair-1) = playerNumberVector(secondPair-1)+1;

scoreVector = [0,100,70,60,50,40,30,40,50,60,70,100];
numberDice = 2;
for number = {'Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten','Eleven','Twelve'} 
        eval(['p.number' number{1} ' = playerNumberVector(' num2str(numberDice-1) ');'])
        howOften = eval(['p.number' number{1}]);
        eval(['p.score' number{1} '=0;']);
        if logical(howOften)
            if howOften<5
                eval(['p.score' number{1} '= -200;']) ;
            else
                eval(['p.score' number{1} '= (min(10,howOften)-5)*scoreVector(numberDice);']) ;
            end
        end
        numberDice = numberDice+1;
end
end




function p=addRemovedNumber(p,removedNumber)
if p.removedNumbersTable1==0
    p.removedNumbersTable1 = removedNumber;
    p.removedNumbersTable1howOften = 1;
elseif p.removedNumbersTable1==removedNumber
    p.removedNumbersTable1howOften = p.removedNumbersTable1howOften+1;
elseif p.removedNumbersTable2==0
    p.removedNumbersTable2 = removedNumber;
    p.removedNumbersTable2howOften = 1;
elseif p.removedNumbersTable2==removedNumber
    p.removedNumbersTable2howOften = p.removedNumbersTable2howOften+1;
elseif p.removedNumbersTable3==0
    p.removedNumbersTable3 = removedNumber;
    p.removedNumbersTable3howOften = 1;
elseif p.removedNumbersTable3==removedNumber
    p.removedNumbersTable3howOften = p.removedNumbersTable3howOften+1;
end
end