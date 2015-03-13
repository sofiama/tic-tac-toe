#Tic-Tac-Toe

Command line interface tic-tac-toe game
 
##To start the game:

1. clone/fork this repo

2. `cd tic-tac-toe`

3. run `ruby bin/runner.rb`

##Game setup

* Can be played between 2 players
    * human vs human
    * human vs computer
* Allows player(s) to enter their names
* Allows player to select their marker
* Allows player to choose who can start the game first
* If playing against a computer, allows player to select whether they want to play against a 'smart' computer
    * if yes *(see 'smart' computer strategy)*
    * if no - computer will play by selecting a random position

##Game play
* Each player takes their turn to place their marker in the tic-tac-toe board by entering the position on the board
* Game is checked for winner when there are five or more markers on the board *(see algorithm for checking winners)*
* Winner/Tie is announced when a player:
    * succeeds in placing three respective markers in a horizontal, vertical, or diagonal row
    * or when there is a tie (no one succeeds in placing three respective markers in a horizontal, vertical, or diagonal row and no spaces are left on the board)
* When game ends, player is asked to play again

##'Smart' computer strategy

The order is as follows:

1. Win: If you have two in a row, play the third to get three in a row

2. Block: If the opponent has two in a row, play the third to block them

3. Center: Play the center

4. Opposite Corner: If the opponent is in the corner, play the opposite corner (the corner that would make a diagonal)

5. Empty Corner: Play an empty corner

6. Empty Side: Play an empty side

Note - a player can beat a 'smart' computer by creating a fork (an opportunity where there are two ways to win)

##Algorithm for checking winners
* The game checks to see if there is a winner when the turn number is >= five (when five or more markers have been placed on the board)
* The board has a class method wins that contains an array of eight arrays
    * each of the eight arrays represents a horizontal, vertical, or diagonal row (a possible win)
    * each of the eight arrays contains an array of three positions on the board (the three respective marks that would be needed to make a horizontal, vertical, or diagonal row to win)
* A loop is created to check each possible win in the class method wins
    * For each possible win, the values of each position are stored in local array called values
      * It then checks if the local array values has a uniq size of one (indicating that there are three respective marks)
      * If it does, then it is a win and a winner is announced
      * Otherwise it checks the next possible win for a win
    * If there is no winner found, then the next player takes a turn and the loop to check if there is a winner continues
* If when there are no more spaces on the board, and there is no winner, then a tie is announced
