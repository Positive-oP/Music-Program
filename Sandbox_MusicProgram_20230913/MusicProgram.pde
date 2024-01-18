import ddf.minim.*;

Minim minim;
AudioPlayer[] players = new AudioPlayer[3];
boolean[] isPlaying = new boolean[3];
boolean[] isMuted = new boolean[3];
float buttonWidth = 80;
float buttonHeight = 40;
float buttonGap = 20;
float columnGap = 150; // Adjusted gap between columns
int currentSong = 0;

void setup() {
  size(900, 700);
  minim = new Minim(this);

  String[] fileNames = {
    "✯call-of-duty-black-ops-zombies-main-menu-theme✯-made-with-Voicemod-technology.mp3",
    "01-main-theme-overworld.mp3",
    "main-theme-super-smash-bros-brawl-made-with-Voicemod-technology.mp3"
  };

  for (int i = 0; i < players.length; i++) {
    players[i] = minim.loadFile(fileNames[i]);
    createButton(20 + i * (buttonWidth + buttonGap + columnGap), 20, players[i]);
  }
}

void createButton(float x, float y, AudioPlayer player) {
  fill(0, 255, 0);
  rect(x, y, buttonWidth, buttonHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("Play", x + buttonWidth / 2, y + buttonHeight / 2);

  fill(255, 0, 0);
  rect(x, y + buttonHeight + buttonGap, buttonWidth, buttonHeight);
  fill(0);
  text("Pause", x + buttonWidth / 2, y + 2 * buttonHeight + buttonGap);

  fill(0, 0, 255);
  rect(x, y + 2 * (buttonHeight + buttonGap), buttonWidth, buttonHeight);
  fill(0);
  text("Restart", x + buttonWidth / 2, y + 3 * buttonHeight + 2 * buttonGap);

  fill(255, 165, 0);
  rect(x, y + 3 * (buttonHeight + buttonGap), buttonWidth, buttonHeight);
  fill(0);
  text("Skip 15s", x + buttonWidth / 2, y + 4 * buttonHeight + 3 * buttonGap);

  fill(150, 75, 0);
  rect(x, y + 4 * (buttonHeight + buttonGap), buttonWidth + 40, buttonHeight);
  fill(0);
  text("Go Back 15s", x + buttonWidth / 2, y + 5 * buttonHeight + 4 * buttonGap);

  fill(255);
  rect(x, y + 5 * (buttonHeight + buttonGap), buttonWidth, buttonHeight);
  fill(0);
  text("Mute", x + buttonWidth / 2, y + 6 * buttonHeight + 5 * buttonGap);
}

void draw() {
  fill(255);
  textSize(16);
  textAlign(LEFT, BOTTOM);
  text("Press 'P' to go to the Previous Song", 10, height - 30);
  text("Press 'N' to go to the Next Song", 10, height - 10);
}

void mousePressed() {
  for (int i = 0; i < players.length; i++) {
    float startX = 20 + i * (buttonWidth + buttonGap + columnGap);
    float startY = 20;
    float endX = startX + buttonWidth;
    float endY = startY + buttonHeight;

    if (mouseX > startX && mouseX < endX && mouseY > startY && mouseY < endY) {
      handleButtonClick(i);
    }
  }
}

void handleButtonClick(int index) {
  switch (index) {
    case 0: togglePlayPause(); break;
    case 1: players[index].pause(); isPlaying[index] = false; break;
    case 2: players[index].rewind(); players[index].skip(15); isPlaying[index] = false; break;
    case 3: skip15Seconds(); break;
    case 4: goBack15Seconds(); break;
    case 5: toggleMuteUnmute(); break;
  }
}

void togglePlayPause() {
  isPlaying[currentSong] = !isPlaying[currentSong];
  if (isPlaying[currentSong]) players[currentSong].play();
  else players[currentSong].pause();
}

void toggleMuteUnmute() {
  isMuted[currentSong] = !isMuted[currentSong];
  if (isMuted[currentSong]) players[currentSong].mute();
  else players[currentSong].unmute();
}

void skip15Seconds() {
  if (isPlaying[currentSong]) players[currentSong].skip(15);
}

void goBack15Seconds() {
  if (isPlaying[currentSong]) players[currentSong].skip(-15);
}

void keyPressed() {
  if (key == 'N' || key == 'n') skipSong();
  else if (key == 'P' || key == 'p') goBackSong();
}

void goBackSong() {
  players[currentSong].close();
  currentSong = (currentSong - 1 + players.length) % players.length;
  players[currentSong].rewind();
  players[currentSong].play();
  isPlaying[currentSong] = true;
}

void skipSong() {
  players[currentSong].close();
  currentSong = (currentSong + 1) % players.length;
  players[currentSong].rewind();
  players[currentSong].play();
  isPlaying[currentSong] = true;
}
