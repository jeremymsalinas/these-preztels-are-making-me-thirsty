import javax.swing.*;
import java.awt.event.*;
import java.awt.*;
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
public class GameView extends JFrame
{
    // Initialize gameBoard to an 8x8 array of Buttons
    private JButton[][] buttonArray = new JButton[8][8];
    // Initialize int x and int y
    private int x,y;
    // Initialize text fields for treasureRemaining, turnsLeft, lastTurn, and gameStatus
    private JTextField treasureRemaining, turnsLeft, treasureFound, lastTurn, gameStatus;
    

    /**
     * Constructor for GameView 
     * Takes a TreasureHuntGame and creates a view for that game
     */
    public GameView(TreasureHuntGame game)
    {
        // Title for game window
        setTitle("Treasure Hunt Game");
        // Layout for game window
        setLayout(new GridBagLayout());
        // Create new GridBagConstraints gameView 
        GridBagConstraints gameView = new GridBagConstraints();
        
        
        // Set gameStatus to new JTextField
        gameStatus = new JTextField("Treasure Hunt Game");
        // Do not allow edits
        gameStatus.setEditable(false);
        // Set gameStatus font
        gameStatus.setFont(new Font("Arial", Font.BOLD, 28));
        
        // Set treasureRemaining to new JTextField
        treasureRemaining = new JTextField("Treasures remaining: " + game.getTreasureLeft());
        // Do not allow edits
        treasureRemaining.setEditable(false);
        
        // Set turnsLeft to new JTextField
        turnsLeft = new JTextField("Turns Left: " + game.getTurnsLeft());
        // Do not allow edits
        turnsLeft.setEditable(false);
        
        // Set treasuerFound to new JTextField
        treasureFound = new JTextField("Treasures found: " + game.getTreasureFound());
        // Do not allow edits
        treasureFound.setEditable(false);
        
        // lastTurn to new JTextField
        lastTurn = new JTextField("Last Move: ");
        
        // Create buttons in buttonArray, add to display, and add actionListeners
        for (x = 0; x < 8; x++)
        {
            for (y = 0; y < 8; y++)
            {
                gameView.gridx = x;
                gameView.gridy = y;
                buttonArray[x][y] = new JButton("Click Me");
                buttonArray[x][y].setForeground(Color.RED);
                add(buttonArray[x][y], gameView);
                
                
                addActionListener (x, y, game);
            }
        }
        
        // Add treasureRemaining at the corresponding position on gameView
        gameView.gridx = 4;
        gameView.gridy = 10;        
        add(treasureRemaining, gameView);
        
        // Add turnsLeft at the corresponding position on gameView
        gameView.gridx = 2;
        gameView.gridy = 10;
        add(turnsLeft, gameView);
        
        // Add treasureFound at the corresponding position on gameView
        gameView.gridx = 4;
        gameView.gridy = 12;
        add(treasureFound, gameView);
        
        // Add lastTurn at the corresponding position on gameView
        gameView.gridx = 2;
        gameView.gridy = 12;
        add(lastTurn, gameView);
        
        // Add gameStatus at the corresponding position on gameView
        gameView.gridx = 3;
        gameView.gridy = 100;
        add(gameStatus, gameView);
    }

    
    // Method to add an instance of ActionListener to a JButton in buttonArray
    public void addActionListener (int i, int j, TreasureHuntGame game)
    {
                // Button at index i,j 
                buttonArray[i][j].addActionListener(new ActionListener() 
                {
                    public void actionPerformed(ActionEvent e) 
                    {
                        // Update button to display the corresponding text from gameBoard
                        buttonArray[i][j].setText(game.getGameBoardPosition(i,j));
                        // Subtract from the movesLeft 
                        game.subtractMovesLeft();
                        // Set turnsLeft text field to current turnsLeft
                        turnsLeft.setText("Turns Left: " + game.getTurnsLeft());
                        // Change button text color from red to black
                        buttonArray[i][j].setForeground(Color.black);
                        // Update lastTurn to the corresponding text from gameBoard
                        lastTurn.setText("Last Move:  " + buttonArray[i][j].getText());
                        
                        // If gameBoard position is "treasure"
                        if (game.getGameBoardPosition(i,j).equals("treasure"))
                        {
                            // Call subtractTreasureLeft method
                            game.subtractTreasureLeft();
                            // Change text color in button to green
                            buttonArray[i][j].setForeground(Color.green);
                            // Update treasureRemaining text
                            treasureRemaining.setText("Treasures remaining: " + game.getTreasureLeft());
                            // Update treasureFound text
                            treasureFound.setText("Treasures found: " + game.getTreasureFound());
                        }
                        
                        // Else if turnsLeft is 0 or turnsLeft is less than remaining treasure
                        else if (game.getTurnsLeft() == 0 || game.getTurnsLeft() < game.getTreasureLeft())
                        {
                            // Update gameStatus with losing message
                            gameStatus.setText("YOU LOSE");
                            // Change gameStatus text to red
                            gameStatus.setForeground(Color.red);
                            // Set all buttons on gameView to be not enabled and update the text with the corresponding gameBoard text 
                            for (x = 0; x < 8; x++)
                            {
                                for (y = 0; y < 8; y++)
                                {
                                    buttonArray[x][y].setEnabled(false);
                                    buttonArray[x][y].setText(game.getGameBoardPosition(x,y));
                                }
                            }
                        }
                        else if (game.getTreasureLeft() == 0)
                        {
                            // Update gameStatus with winning message
                            gameStatus.setText("YOU WIN!!!");
                            // Change gameStatus text to green
                            gameStatus.setForeground(Color.green);
                            // Set all buttons on gameView to be not enabled and update the text with the corresponding gameBoard text 
                            for (x = 0; x < 8; x++)
                            {
                                for (y = 0; y < 8; y++)
                                {
                                    buttonArray[x][y].setEnabled(false);
                                    buttonArray[x][y].setText(game.getGameBoardPosition(x,y));
                                }
                            }
                        }
                        // Remove ActionListener so button will no longer respond after being clicked
                        buttonArray[i][j].removeActionListener(this);
                        
                    }
            
                });
                
    }
    
    public static void play()
    {
        // Create new instance of TreasureHuntGame
        TreasureHuntGame newGame= new TreasureHuntGame();
        // Create new instance of GameView and pass the newGame as an argument
        GameView viewNewGame = new GameView(newGame);
        // Make the game visible
        viewNewGame.setVisible(true);
        // Set default window size
        viewNewGame.setSize(1200,1200);
        // set default close action
        viewNewGame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
    
    /**
    * Main method for GameView
    */
    public static void main(String[] args)
    {
        GameView.play();
    }
}   
