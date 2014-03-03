function valid=isOK(p,diceNumbers,firstPair,secondPair,varargin)
%last argument is either empty (just check if isOK) or 'handles' (additionally update visibility settings)

update = false;
if ~isempty(varargin)
    update = true;
    handles = varargin{1};
end
removedNumber = sum(diceNumbers)-firstPair-secondPair;

valid = false;

if isOKremovedNumber(p,diceNumbers,removedNumber)
    %otherwise do not continue, valid remains false;
    %if removed number isOK it is deleted from diceNumbers
    %option '1' only finds and deletes first entry.
    diceNumbers(find(diceNumbers==removedNumber,1))=[];
    
    permutations = perms(diceNumbers); %get all possible firstPairs (fPair, to not confuse with function input)
    fPair = zeros(1,length(permutations)/2);
    for i = 1:length(permutations)/2 %the way permutations is set up nothing is lost if we skip every other permuation (addition is commutative)
        fPair(i) = permutations(2*i,1)+permutations(2*i,2);
    end
    fPair = unique(fPair);
    %element-wise compare if fPair == firstPair, and sPair (=left over from fPair) == secondPair);
    %if true (&) for both vector entries at the same time at least once, then choice is valid.
    valid = any(fPair == firstPair & sum(diceNumbers)-fPair == secondPair);
end

if update
    if valid
        set(handles.pushCommit,'Visible','on')
        set(handles.showRemovedNumber,'String',num2str(removedNumber));
    else
        set(handles.pushCommit,'Visible','off')
        set(handles.showRemovedNumber,'String',' ');
    end
end
end
