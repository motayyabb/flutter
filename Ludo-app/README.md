# Ludo Dice

## Overview
Ludo Dice is a simple and engaging Flutter application designed to simulate a dice-rolling game for up to four players. Players take turns rolling dice and accumulate scores, aiming to reach a score of 50 to win the game. The app features a user-friendly interface with animations for an enhanced gaming experience.

## Features
- **Multi-Player Support**: Supports up to four players.
- **Dice Rolling**: Players can roll the dice by clicking a button, and the results are displayed with animations.
- **Score Tracking**: Keeps track of each player's score and updates it after every roll.
- **Winner Announcement**: Alerts the winner with a dialog once a player reaches 50 points.
- **Play Again Option**: Allows players to restart the game after a winner is declared.

## Technologies Used
- **Flutter**: A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **Dart**: The programming language used to write the application.

## Usage
- Open the app on your device or emulator.
- Each player takes turns clicking the "Roll the Dice" button.
- The score for each player is updated after each roll.
- The game ends when a player reaches a score of 50, and a dialog will appear announcing the winner.
- Players can choose to play again by clicking the "Play Again" button in the dialog.

## Screenshots

| Screenshot 1 | Screenshot 2 |
|--------------|--------------|
| ![Ludo Dice - Screen 1](https://github.com/user-attachments/assets/e10edb15-3e65-439e-8916-dca02c2ba4dd) | ![Ludo Dice - Screen 2](https://github.com/user-attachments/assets/fd47dbd1-f204-4241-a2ad-05a22b8a2b6a) |

## Demo video 



https://github.com/user-attachments/assets/cdad124d-dffa-47f4-bff5-0c42702ee193



https://github.com/user-attachments/assets/ed3313a5-9135-477a-b700-1a0f5f950aef


https://github.com/user-attachments/assets/0cc6b337-9db4-443f-aa7a-1507cca4c368


## Code Structure
- `main.dart`: The main entry point of the application.
- `DiceApp`: A stateless widget that initializes the app and sets up the theme.
- `DiceScreen`: A stateful widget that manages the game logic, including dice rolling, score tracking, and determining the winner.

## Contributing
Contributions are welcome! Feel free to fork the repository and submit pull requests.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
