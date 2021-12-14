import java.util.Random;
import java.util.Arrays;
/**
 * 
 * Lead Author: 
 * Jeremy Salinas; 5713282
 * 
 * References:
 * Gaddis, T. (2015). Starting Out With Java Myprogramming Lab 
 * From Control Structures Through Objects. (6th ed.). Addison-Wesley. 
 * 
 * Version: 
 * 8/14/21
 */
public class TreasureHuntGame
{
    // Initialize treasure, movesLeft, and treasureFound to their default values
    private int treasure = 20, movesLeft = 50, treasureFound = 0;
    // Initialize gameBoard to an 8x8 array of Strings
    private String[][] gameBoard = new String[8][8];

    //Constructor for gameBoard
    public TreasureHuntGame()
    {
        createGameBoard();
    }
    
    //
    public void createGameBoard()
    {
        // Create instance of Random to use for treasure placement
        Random boardIndex = new Random();
        
        // Create a random position array to use for treasure placement
        int[] randomPosition = {boardIndex.nextInt(8),boardIndex.nextInt(8)};
        int i = 0;
        
        //Create Blank Game Board
        for (int j = 0; j < gameBoard.length; j ++)
        {
            for (int k = 0; k < gameBoard.length; k++)
            {
                gameBoard[j][k] = "nothing";
            }
        }
        
        // Randomly place treasure on the gameBoard while i < 20
        do 
        {
            // If no treasure is at this position add treasure here and add 1 to the counter (i)
            if (!gameBoard[randomPosition[0]][randomPosition[1]].equals("treasure"))
            {
                gameBoard[randomPosition[0]][randomPosition[1]] = "treasure";
                i++;
            }
            // Else get another random position
            else
            {
                randomPosition [0] = boardIndex.nextInt(8);
                randomPosition [1] = boardIndex.nextInt(8);
            }
        }
        while (i < treasure);
    }
    
    // Setter for movesLeft
    public void subtractMovesLeft()
    {
        movesLeft--;
    }
    
    // Setter for treasureLeft and treasureFound
    public void subtractTreasureLeft()
    {
        treasure--;
        treasureFound++;
    }
    
    // Getter for treasureLeft
    public int getTreasureLeft()
    {
        return treasure;
    }
    
    // Getter for treasureFound
    public int getTreasureFound()
    {
        return treasureFound;
    }
    
    // Getter for movesLeft
    public int getTurnsLeft()
    {
        return movesLeft;
    }
    
    // Getter for the position on the board
    public String getGameBoardPosition(int i, int j)
    {
        return gameBoard[i][j];
    }
    
    
}
