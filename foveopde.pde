// Welcome to the Outreach Activity ~ FoveoFocus
// To begin, please refer to the activity documentation 

String txt_file = "song2.txt";
String song_name = "httyd_main.mp3";
int speed = 1200;
int hardMode = 0;

// Warning do not edit anything below --------------------------------------------- Edits may cause errors --------------------------------
float rate, width_cells, height_cells;
int cells_generated_per, gameStart, gameDuration;
color[] buttonColors = { #AFFF33, #5CE9F7, #C968FA, #FCA55D, #2A32E8, #DB2AE8};
int[][] song;
int[][] playerScore;
boolean completed;
String final_score = "";
char[] key_bindings ={ '1', '2', '3', '4'};
boolean[] keyStroke;
PImage bg;

import ddf.minim.*;
AudioPlayer player;
Minim minim; 

void setup() {
  size(700, 500);
  minim = new Minim(this); 
  player = minim.loadFile(song_name, 2048);
  bg = loadImage("background.jpeg");
  
  //Load "song file"
  String[] data = loadStrings(txt_file);
  song = new int[ data.length ][ data[0].length() ];
  
  //Create an algorithm for notes to spawn from song file
  // i index refers to each row of notes
  for( int i = 0; i < data.length; ++i )
  {
    // j index refers to columns of notes
    for( int j = 0; j < data[i].length(); ++j )
    {
      if( data[i].charAt(j) == '-' ){
        song[i][j] = -1;
      }
      else {
        song[i][j] = int( data[i].charAt(j) ) -48;
      }  
    }
  }
  //To record scoring, we will use an array that can be parsed as the end.
  playerScore = new int[ song.length ][ song[0].length ]; 
  for( int i = 0; i < song.length; ++i )
  {                              
    for( int j = 0; j < song[0].length; ++j )
    {                        
      playerScore[i][j] = -1;
    }
  }
  
  keyStroke = new boolean[key_bindings.length];
  rate = speed;
  width_cells = 500/ (float) song.length;
  height_cells = 0.8 * width_cells;
  cells_generated_per = ceil(height / height_cells) + 1;
  
  stroke(#A4BFBC);
  textSize(72);
  textAlign( CENTER, CENTER );
  
  gameDuration = 0;
  completed = true;
  final_score = "Press Any \n Key to Begin";
}

void draw() {
  background(bg);
  
  if( millis() < gameDuration )
  {
    float current_cell = (millis()-gameStart) / rate;
    int n = floor( current_cell );
    translate( 0, current_cell * height_cells ); 
    
    for( int i = 0; i < song.length; ++i )
    {
      float x = 50+(i*width_cells);
      
      for( int j = n; j < n+cells_generated_per && j < song[0].length; ++j )
      {
        if( j == n && keyStroke[i] )
        {
          fill(255);
        }
        else if(song[i][j] >= 0 ) 
        {
          fill( buttonColors[i]);
        }
        else
        {
          fill( 20 );
        }
        
        rect( x, height - ((j+1)*height_cells), width_cells, height_cells );
      }
    }
  }
  
  else
  {
    if(completed)
    {
      text(final_score, width/2f, height/2f);
      delay(2000);
      player.close();
      setup();
    }
    
    else
    {
      int max_score = 0, score = 0;
      for( int i = 0; i < song.length; ++i ){
        for( int j = 0; j < song[0].length; ++j ){
          if( song[i][j] >= 0 ){
            max_score += rate;
            if( playerScore[i][j] >= 0 ) score += rate - playerScore[i][j];
            else score -= rate; 
          }
          else{
            if( playerScore[i][j] >= 0 ){
              if( song[i][j+1] >= 0 );
              else score -= rate; 
            }
          }
        }
      }
      float S = constrain(map( score, -max_score, max_score, 0, 100 ), 0, 100);
      if(hardMode == 1)
      {
        final_score = nf(S, 2, 1) + "%";
      }
      else
      {  
        final_score =  "100%";
      }
      fill(buttonColors[ round( 0.05 * S )]);
      completed = true;
    }
    }
  }
    
void keyPressed(){
  if( millis() > gameDuration )
  {
    gameDuration = ceil( millis()+(rate * song[0].length) );
    gameStart = millis();
    player.play();
    completed = false;
    playerScore = new int[ song.length ][ song[0].length ];
    for( int i = 0; i < song.length; ++i )
    {
      for( int j = 0; j < song[0].length; ++j )
      {
        playerScore[i][j] = -1;
      }
    }
  }
  int n = floor( (millis()-gameStart) / rate );
  for( int i = 0; i < key_bindings.length; ++i )
  {
    if( key == key_bindings[i] )
    {
      playerScore[i][n] = round( (millis()-gameStart) - (n*rate) );
      keyStroke[i] = true;
    }
  }
}
void keyReleased()
{
  for( int i = 0; i < key_bindings.length; ++i )
  {
    if( key == key_bindings[i] )
    {
      keyStroke[i] = false;
    }
  }
} 
