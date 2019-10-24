ArrayList<Fireworks> fireworks=new ArrayList<Fireworks>();
ArrayList<FWMarker> markers=new ArrayList<FWMarker>();
Map<Integer, FWMarker> map = new HashMap<Integer, FWMarker>();

Minim minim = new Minim( this );
Controller leap = new Controller();

void setup () {
  fullScreen(P3D);
  frameRate(50); 
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);
  imageMode(CENTER);
  
  //markers.add(new FWMarker(new PVector(width/2, 4*height/5, 0))); 
}
boolean isExtended = false;
float S=0;
float T=0;

void draw () {
  background(0,0,20);
  for(int i=0;i<fireworks.size();i++){
    Fireworks art=fireworks.get(i);
    if(art.num<=0){
      fireworks.remove(i);
    }
    art.display();
    art.update();
  }
  
  /*for(int i=0;i<markers.size();i++){
    FWMarker marker=markers.get(i);
    marker.update();
    marker.draw(); 
  }*/
  
  Frame frame = leap.frame();
  HandList hands = frame.hands();
  for(int i = 0; i < hands.count(); i++) {
    Hand hand = hands.get(i);
    PVector p = new PVector(width/2+15*hand.palmPosition().get(0), 1.1*height-3*hand.palmPosition().get(1), hand.palmPosition().get(2));
    if(!map.containsKey(hand.id())){
      map.put(hand.id(),new FWMarker(p));
    }
    float pinchDist = hand.pinchStrength()*100;
    FWMarker marker = map.get(hand.id());
    marker.setCenter(p);
    if(pinchDist<50){
      marker.setState(true);
      FingerList fingers = hand.fingers();
      for(int j=0;j<fingers.count();j++){
        Finger finger = hand.fingers().get(i);
        if(finger.type()==Finger.Type.TYPE_THUMB){
          if(finger.isExtended()!=isExtended){
            if(!finger.isExtended())
              fireworks.add(new Fireworks(p,marker.getColAngle()));
            isExtended=finger.isExtended();
          }
          else if(!finger.isExtended()){
            T+=0.02;
            if(T>=1){
              fireworks.add(new Fireworks(p,marker.getColAngle()));
              T=0;
            }
          }
        }
      }
    }
    else{
      float roll = hand.palmNormal().roll();
      marker.setState(false);
      
      if(roll>0.2||roll<-0.2){
        S-=0.1*roll;
      }
      
      if(S>=colN)
        S-=colN;
      if(S<0)
        S+=colN;
      
      marker.setSelCol((int)S);
      textSize(40);
      text(hand.id() + "["+S+"]", 0, 40 * (i + 1));
    }
    
    marker.update();
    marker.draw();
    
    
  }
}
void stop(){
  minim.stop();
}


void keyPressed(){
  
  /*if(key==ENTER){
    for(int i=0;i<markers.size();i++){
      FWMarker marker=markers.get(i);
      marker.setState(!marker.getState());
    }
  }
  else if(key==' '){
    S++;
    if(S>=colN)
      S=0;
    for(int i=0;i<markers.size();i++){
      FWMarker marker=markers.get(i);
      marker.setSelCol(S);
    }
  }
  else if(key=='f'){
    for(int i=0;i<markers.size();i++){
      FWMarker marker=markers.get(i);
      PVector p = marker.getCenter();
      p.x-=10;
    }
  }
  else if(key=='j'){
    for(int i=0;i<markers.size();i++){
      FWMarker marker=markers.get(i);
      PVector p = marker.getCenter();
      p.x+=10;
    }
  }
  else{
    for(int i=0;i<markers.size();i++){
      FWMarker marker=markers.get(i);
      PVector p = marker.getCenter();
      fireworks.add(new Fireworks(new PVector(p.x,p.y,p.z),marker.getColAngle()));
    }
    
  }*/
}
