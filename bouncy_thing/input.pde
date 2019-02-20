

void keyPressed(){
  if (key == ' ') {
    player.addJump();
  }
  
  player.moveSideways(key);
  
}