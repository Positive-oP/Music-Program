import ddf.minim.*;

Minim minim;
AudioPlayer[] players = new AudioPlayer[3];
boolean[] isPlaying = new boolean[3];
boolean[] isMuted = new boolean[3];
float[] restartButtonX = new float[3];
int currentSong = 0; // Track the current playing song

void setup() {
  size(900, 700);
  minim = new Minim(this);

  players[0] = minim.loadFile("✯call-of-duty-black-ops-zombies-main-menu-theme✯-made-with-Voicemod-technology.mp3");
  players[1] = minim.loadFile("01-main-theme-overworld.mp3");
  players[2] = minim.loadFile("main-theme-super-smash-bros-brawl-made-with-Voicemod-technology.mp3");

  for (int i = 0; i < 3; i++) {
    restartButtonX[i] = createUI(20, 20 + 80 * i, players[i], i + 1);
  }
}

float createUI(float x, float y, AudioPlayer player, int songNumber) {
  float buttonWidth = 80;
  float buttonHeight = 40;

  // Play button
  fill(0, 255, 0);
  rect(x, y, buttonWidth, buttonHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("Play", x + buttonWidth / 2, y + buttonHeight / 2);

  // Pause button
  float pauseButtonX = x + buttonWidth + 20;
  fill(255, 0, 0);
  rect(pauseButtonX, y, buttonWidth, buttonHeight);
  fill(0);
  text("Pause", pauseButtonX + buttonWidth / 2, y + buttonHeight / 2);

  // Restart button
  float restartButtonX = pauseButtonX + buttonWidth + 20;
  fill(0, 0, 255);
  rect(restartButtonX, y, buttonWidth, buttonHeight);
  fill(0);
  text("Restart", restartButtonX + buttonWidth / 2, y + buttonHeight / 2);

  // Skip 15 seconds button
  float skipButtonX = restartButtonX + buttonWidth + 20;
  fill(255, 165, 0); // Orange color
  rect(skipButtonX, y, buttonWidth, buttonHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("Skip 15s", skipButtonX + buttonWidth / 2, y + buttonHeight / 2);

  // Go Back 15 seconds button
  float goBackButtonX = skipButtonX + buttonWidth + 20;
  fill(150, 75, 0); // Brown color
  rect(goBackButtonX, y, buttonWidth, buttonHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("Go Back 15s", goBackButtonX + buttonWidth / 2, y + buttonHeight / 2);

  // Mute button
  float muteButtonX = width - buttonWidth - 20;
  fill(255);
  rect(muteButtonX, y, buttonWidth, buttonHeight);
  fill(0);
  text("Mute", muteButtonX + buttonWidth / 2, y + buttonHeight / 2);

  return restartButtonX;
}

void draw() {
  // Your drawing code here
 fill(255);
  textSize(16);
  textAlign(LEFT, BOTTOM);
  text("Press 'P' to go to the Previous Song", 10, height - 30);
  text("Press 'N' to go to the Next Song", 10, height - 10);
}

void mousePressed() {
  float playButtonWidth = 80;
  float playButtonHeight = 40;
  float pauseButtonWidth = 80;
  float skipButtonWidth = 80;
  float goBackButtonWidth = 120; // Adjusted width for the new button

  for (int i = 0; i < 3; i++) {
    float currentRestartButtonX = restartButtonX[i];

    // Check if the mouse is clicked within the play button
    if (mouseX > 20 && mouseX < 20 + playButtonWidth && mouseY > 20 + 80 * i && mouseY < 20 + 80 * i + playButtonHeight) {
      togglePlayPause(players[i], isPlaying[i]);
      isPlaying[i] = !isPlaying[i];
    }

    // Check if the mouse is clicked within the pause button
    if (mouseX > 20 + playButtonWidth + 20 && mouseX < 20 + playButtonWidth + 20 + pauseButtonWidth && mouseY > 20 + 80 * i && mouseY < 20 + 80 * i + playButtonHeight) {
      players[i].pause();
      isPlaying[i] = false;
    }

    // Check if the mouse is clicked within the restart button
    if (mouseX > currentRestartButtonX && mouseX < currentRestartButtonX + playButtonWidth && mouseY > 20 + 80 * i && mouseY < 20 + 80 * i + playButtonHeight) {
      players[i].rewind();
      players[i].skip(15); // Skip 15 seconds into the song
      isPlaying[i] = false;
    }

    // Check if the mouse is clicked within the mute button
    if (mouseX > width - playButtonWidth - 20 && mouseX < width - 20 && mouseY > 20 + 80 * i && mouseY < 20 + 80 * i + playButtonHeight) {
      toggleMuteUnmute(players[i], isMuted[i]);
      isMuted[i] = !isMuted[i];
    }

    // Check if the mouse is clicked within the skip 15 seconds button
    if (mouseX > currentRestartButtonX + playButtonWidth + 20 && mouseX < currentRestartButtonX + playButtonWidth + 20 + skipButtonWidth && mouseY > 20 + 80 * i && mouseY < 20 + 80 * i + playButtonHeight) {
      skip15Seconds(players[i], isPlaying[i]);
    }

    // Check if the mouse is clicked within the go back 15 seconds button
    if (mouseX > currentRestartButtonX + playButtonWidth + 20 + skipButtonWidth + 20 && mouseX < currentRestartButtonX + playButtonWidth + 20 + skipButtonWidth + 20 + goBackButtonWidth && mouseY > 20 + 80 * i && mouseY < 20 + 80 * i + playButtonHeight) {
      goBack15Seconds(players[i], isPlaying[i]);
    }
  }
}

void togglePlayPause(AudioPlayer player, boolean isPlaying) {
  if (isPlaying) {
    player.pause();
  } else {
    player.play();
  }
}

void toggleMuteUnmute(AudioPlayer player, boolean isMuted) {
  if (isMuted) {
    player.unmute();
  } else {
    player.mute();
  }
}

void skip15Seconds(AudioPlayer player, boolean isPlaying) {
  if (isPlaying) {
    player.skip(15);
  }
}

void goBack15Seconds(AudioPlayer player, boolean isPlaying) {
  if (isPlaying) {
    player.skip(-15); // Go back 15 seconds
  }
}

void keyPressed() {
  if (key == 'N' || key == 'n') {
    skipSong();
} else if (key == 'P' || key == 'p') {
    goBackSong();
  }
}

void goBackSong() {
  // Stop the current song
  players[currentSong].close();

  // Decrement the currentSong index
  currentSong = (currentSong - 1 + players.length) % players.length;

  // Load and play the previous song
  players[currentSong].rewind();
  players[currentSong].play();
  isPlaying[currentSong] = true;
}

void skipSong() {
  // Stop the current song
  players[currentSong].close();

  // Increment the currentSong index
  currentSong = (currentSong + 1) % players.length;

  // Load and play the next song
  players[currentSong].rewind();
  players[currentSong].play();
  isPlaying[currentSong] = true;
}
