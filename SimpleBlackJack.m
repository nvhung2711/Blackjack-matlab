%SimpleBlackJack
%This code runs a simple game of blackjack for the user to play in the
%command window, treating Aces as a value of 11. The code was written
clear
clc

%Create counters for the number of Dealer wins and user wins
dealerWins = 0;
userWins = 0;
%Establish the amount of money in the user's bank & bet
userMoney = 500;
bet = 0;
%Get user input to decide whether to play or not
playStatus = input('\nWould you like to play a round of Blackjack? [Y/N]: ', 's');
playStatus = lower(playStatus);
charAt = @(playStatus,idx)playStatus(idx);

%Start an error loop if user enters an invalid response.
while (charAt(playStatus,1) ~= 'y' && charAt(playStatus,1) ~= 'n')
    %Print error response and prompt for input again
    fprintf('\nThat is not an appropriate response, please try again.');
    playStatus = input('\nWould you like to play a round of Blackjack? [Y/N]: ', 's');
end

%Create a loop for play while the user chooses to play (gameStatus == Y)
while (charAt(playStatus,1) == 'y' && userMoney > 0)
    
    %Display the user's total money
    fprintf('\nYour total current money is $%.0f', userMoney);

    %Ask for a bet amount & check its availability
    bet = input('\nPlace your bet for this round: $');
    while (bet <= 0 || bet > userMoney || bet == ' ')
        if (bet > userMoney)
            fprintf('\nYou cannot bet more than you have!')
            bet = input('\nPlace your bet for this round: $');
        elseif (bet < 0)
            fprintf('\nYou cannot bet a negative amount!');
            bet = input('\nPlace your bet for this round: $');
        elseif (bet == 0)
            fprintf('\nYou can''t play if your bet is zero!');
            bet = input('\nPlace your bet for this round: $');
        elseif (bet == '')
            fprintf('\nYou must enter a valid bet number');
            bet = input('\nPlace your bet for this round: $');
        end
    end

    %Create numerical deck values, images, and shuffle
    deckPosition = 5;
    load('CardDeck.mat');
    deckImg = RedDeck;
    cardDeck = randperm(52);
    deckValues = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10];

    %Deal out hands for user and dealer
    userHand = cardDeck(:,[1,3]);
    dealerHand = cardDeck(:,[2,4]);
    
    %Determine values of the cards in hands
    userValue = sum(deckValues(userHand));
    dealerValue = sum(deckValues(dealerHand));
    
    %Display user's cards to the user
    userDisplay = figure('Name','Your Current Hand','NumberTitle','off','Color','green');
        set(userDisplay,'MenuBar','none');
        set(userDisplay,'ToolBar','none');
        imshow([deckImg{userHand}]);
        linkdata on;
        linkdata(userDisplay);
        drawnow;
        
    %Create loop for while both dealer and user are <= 21 in valiue
    while (userValue <= 21 && dealerValue <= 21)
      
        %Ask for user input / action
        action = input('\nChoose your response [HIT|STAND|DOUBLE|SURRENDER]: ','s');
        action = lower(action);
        actionCheck = @(action,index)action(index);

        %Loop for action input error or mismatch
        while (actionCheck(action,1) ~= 'h' && actionCheck(action,1) ~= 's' && actionCheck(action,1) ~= 'd')
            fprintf('\nThat doesn''t seem to be a recognized action, try again.');
            action = input('\nChoose your response [HIT|STAND|DOUBLE|SURRENDER]: ','s');
        end

        %Determine result of the user action
        userAction = ' ';
        if (actionCheck(action,1) == 'h')
            fprintf('\nYou decided to hit, here''s another card!');
            userHand = [userHand(1:end) cardDeck(deckPosition)];
            deckPosition = deckPosition + 1;
            userAction = 'hit';
        elseif (actionCheck(action,1) == 'd')
            bet = bet * 2;
            fprintf('\nYou doubled your bet, here''s another card!');
            userHand = [userHand(1:end) cardDeck(deckPosition)];
            deckPosition = deckPosition + 1;
            userAction = 'double';
        elseif (strcmp(action,'stand') == 1)
            fprintf('\nYou decided to keep your current hand.')
            userAction = 'stand';
        elseif (strcmp(action,'surrender') == 1)
            fprintf('\nYou surrendered, how sad...');
            userAction = 'surrender';
            break;
        end
        
        %Refresh current hand display
        close(gcf);
        userDisplay = figure('Name','Your Current Hand','NumberTitle','off','Color','green');
            set(userDisplay,'MenuBar','none');
            set(userDisplay,'ToolBar','none');
            imshow([deckImg{userHand}]);
            linkdata on;
            linkdata(userDisplay);
            drawnow;
        %Refresh hand values
        clear sum
        userValue = sum(deckValues(userHand));
        dealerValue = sum(deckValues(dealerHand));
           
        %Determine the action of the dealer
        dealerAction = ' ';
        if (dealerValue < 17)
            dealerHand = [dealerHand(1:end) cardDeck(deckPosition)];
            fprintf('\nDealer decided to hit...');
            dealerAction = 'hit';
        elseif (dealerValue >= 17 && dealerValue <= 21)
            fprintf('\nThe Dealer decided to stand...');
            dealerAction = 'stand';
        end
    
        %Determine if both dealer and user have stood and are done
        if (strcmp(dealerAction,'stand') == 1 && strcmp(userAction,'stand') == 1)
            break;
        end
    end
    
    %Print hands as well as disply them
    fprintf('\n\nThe Dealer''s Hand: %.0f', dealerValue);
    fprintf('\nYour Hand: %.0f', userValue);
    
    %Determine winner of the round and who gets the bet money
    if (dealerValue > 21)
        fprintf('\nThe dealer busted, you won that round!');
        userMoney = userMoney + bet;
        userWins = userWins + 1;
    elseif(userValue > 21)
        fprintf('\nYou busted, the Dealer won that round!');
        userMoney = userMoney - bet;
        dealerWins = dealerWins + 1;
    elseif(dealerValue > userValue)
        fprintf('\nThe Dealer''s hand was worth more, the Dealer won!');
        userMoney = userMoney - bet;
        dealerWins = dealerWins + 1;
    elseif(userValue > dealerValue)
        fprintf('\nYour hand was worth more, you won that round!');
        userMoney = userMoney + bet;
        userWins = userWins + 1;
    elseif(userValue == dealerValue)
        fprintf('\nLooks like you tied with the dealer, you get your bet back!');
    end
        
    %Display the dealers hand and results to the user
    dealerDisplay = figure('Name','Dealer''s Hand','NumberTitle','off','Color','red');
        set(dealerDisplay,'MenuBar','none');
        set(dealerDisplay,'ToolBar','none');
        imshow(([deckImg{dealerHand}]));
        linkdata on;
        linkdata(dealerDisplay);
        drawnow;
    if(userMoney >= 0)
        %Ask again for user decision to play or, end game if no
        playStatus = input('\n\nWould you like to play another round of Blackjack? [Y/N]: ', 's');
        %Error handle for if input isnt a correct form
        while (charAt(playStatus,1) ~= 'y' && charAt(playStatus,1) ~= 'n')
            %Print error response and prompt for input again
            fprintf('\nThat is not an appropriate response, please try again.');
            playStatus = input('\nWould you like to play a round of Blackjack? [Y/N]: ', 's');
        end
    end
    
    close(userDisplay);
    close(dealerDisplay);
end

fprintf('\nBlackjack Score Summary:')
%Print ending results and congratulatory statements
fprintf('\n*****************************************');
fprintf('\nGoodbye! Thanks for playing!');
fprintf('\nYou left the table with $%.0f\n', userMoney); 
fprintf('*****************************************');
fprintf('\nYou won a total of %.0f time(s).', userWins);
fprintf('\nThe Dealer won a total of %.0f time(s).', dealerWins);

%Determing who won the most rounds
if (userWins > dealerWins)
    fprintf('\nYou won!\n');
elseif (userWins == dealerWins)
    fprintf('\nIt was a tie!\n');
else
    fprintf('\nYou beat the dealer!\n');
end
fprintf('*****************************************\n');
