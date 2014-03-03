Dice Game
---------

Coded up for Matlab by Bernhard Konrad (bernhard.konrad@gmail.com) and Isabell Graf (grafisab@gmail.com).


Fork me on github: https://github.com/IsabellGraf/DiceGame.git

Trivia: 'wuerfel' is german for 'dice'.


How to use the Matlab files (with GUI)
---------
Put all files in the same folder.
Type 'wuerfelGUI' in the Matlab console OR open the file wuerfelGUI.m and press RUN.
Have fun!

How to use the Matlab files (without GUI)
---------
Put all files in the same folder.
Type 'wuerfelText' in the Matlab console OR open the file wuerfelText.m and press RUN.
Have fun!


Game Instructions
---------
The game is played in rounds. A round starts by rolling five dice, say {d1,d2,d3,d4,d5}.
Every player forms three sets with these dice. Two of the sets contain two dice each; the third set contains the remaining die, say set1={d1,d3}, set2={d2,d5} and set3={d4}.
The player adds up the dice in the sets containing two dice; the die in the third set is called removed number, i.e. here first pair=d1+d3, second pair=d2+d5 and removed number=d4.
Every player forms and records his two pairs (numbers) and removed number separately on his score sheet. 
When every player is done the round is complete and the next round begins with rolling the five dice.

A player gets a score for his first pair (number) and second pair (number). These numbers are elements of {2,3,...,12}. 
The table below shows the individual value v for each possible number n. 

Numbers n	 2	 3	 4	 5	 6	 7	 8	 9	 10	 11	 12
-----------------------------------------------------------------------------------------------------
Value v(n)	 100	 70	 60	 50	 40	 30	 40	 50	 60	 70	 100


However, the table (of positive scores) above only takes effect if a player chooses that number several times. 
The table below illustrates how many points one gets for the times a number has been chosen. 

Times choosing number n	 0         1   	   2	   3	  4	 5	   6	        7	   8	       9	   10	       10 +
----------------------------------------------------------------------------------------------------------------------------------
Score s         	 0	 -200	 -200	 -200	 -200	 0	 1 x v(n)    2 x v(n)	 3 x v(n)    4 x v(n)	 5 x v(n)    5 x v(n)


Example: You have chosen the number 4 for 3 times (-200 points), the number 5 for 8 times (3 x 50 = 150 points), the number 10 for 6 times (1 x 60 = 60 points), and the number 12 for 5 times (0 points). For all numbers that have never been chosen you get 0 points. Hence, your total score is 10 points.

In each round the player also records his removed number. Each player can collect at most three different removed numbers throughout the game.

If a player still has less than three different removed numbers, he can freely choose which number to remove this round. 
If this removed number has never been chosen before he records it at one of the empty removed number spots and sets the counter to 1. Otherwise, the corresponding counter is increased by 1.
Once a player has collected three different removed numbers he must remove one of these numbers in every following round (for the only exception, see below). This will restrict some combinations of two pairs this player can choose.

Example: In the first, second and third round your removed number was 3, 2 and 6, respectively. Now, in the fourth round, the five dice are {3,1,5,5,3}. You now have to remove a 3 again (and set its counter to 2), hence the only legal options for [firstPair,secondPair,removedNumber] are [4,10,3] or [6,8,3] (Yes, [10,4,3] and [8,6,4] are equivalent and hence also legal).

It is possible that none of the dice numbers corresponds to any of your three removed numbers. In this lucky case you can choose your sets without any restrictions and your removed number will not be recorded.

The counters on the removed numbers determine the end of your game. Your last round, which you still play as normal, will be the first round in which you removed a number for the eighths time. After this you leave the game and calculate your final score. Since this may happen in different rounds for different players, also the last round can be different.

Once every player reached the end of his game, the player with the highest score wins (this final rule can hardly come as a surprise).