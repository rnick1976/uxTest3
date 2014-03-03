function valid=isOKremovedNumber(p,diceNumbers,removedNumber)
%This checks if correct number has been taken out.
%A little faster than isOK if you guarantee to only work with given diceNumbers.

%One of the three conditions needs to be fulfilled:
%a) 3rd p.removedNumbersTable is not chosen yet
%or
%b) one of the previously removed numbers is chosen again
%or
%c) it is not true that any of the dice numbers has previously been chosen as removed number
%
conditionA = 0==p.removedNumbersTable3;
conditionB = (p.removedNumbersTable1 == removedNumber || p.removedNumbersTable2 == removedNumber || p.removedNumbersTable3 == removedNumber);
conditionC = ~(any(p.removedNumbersTable1 == diceNumbers) || any(p.removedNumbersTable2 == diceNumbers) || any(p.removedNumbersTable3 == diceNumbers));

%need to take care of the special case removedNumber==0, since removedNumbers are initialized with 0.
conditionD = removedNumber~=0;

valid = (conditionA || conditionB || conditionC) && conditionD;
end
