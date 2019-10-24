static final int selR = 20;
static final int nselR = 300;
static final int colN = 12;
static final int dotN = 4;
static final PVector[] v = {new PVector(1.0/2.0, 1.0/2.0, 1.0/2.0),
                            new PVector(-1.0/2.0, -1.0/2.0, 1.0/2.0),
                            new PVector(1.0/2.0, -1.0/2.0, -1.0/2.0),
                            new PVector(-1.0/2.0, 1.0/2.0, -1.0/2.0)};
static final float Kref = 0.2;
static final float TH_REF = 5;

class TetraSetting{
  PVector p[] = new PVector[dotN];//for transient phase
  PVector ref_closed[] = new PVector[dotN];//for stationary phase
  PVector ref_opened = new PVector();//for stationary phase
  public PVector deg;//rotation degree
  public PVector omega;//rotation speed
  public PImage img;//image
  boolean isClose=true;
  boolean selected;
  float colAngle;
  
  
  TetraSetting(PVector o,float c_a,boolean b){
    deg = new PVector((int)(360.0*random(0,1.0)),(int)(360.0*random(0,1.0)),(int)(360.0*random(0,1.0)));
    
    omega = o;
    colAngle = c_a;
    setSelected(b);
    
    for(int i=0;i<dotN;i++){
      pushMatrix();
      rotateY(radians(deg.y));
      rotateX(radians(deg.x));
      rotateZ(radians(deg.z));
      PMatrix3D mat = (PMatrix3D)getMatrix();
      popMatrix();
      PVector e = new PVector();
      if(selected)
        mat.mult(new PVector(selR*v[i].x,selR*v[i].y,selR*v[i].z),e);
      else
        mat.mult(new PVector(nselR*v[i].x,nselR*v[i].y,nselR*v[i].z),e);
      p[i]=e;
      ref_closed[i]=e;
    }
    
    pushMatrix();
    rotateZ(radians(colAngle));
    PMatrix3D mat = (PMatrix3D)getMatrix();
    popMatrix();
    PVector e = new PVector();
    mat.mult(new PVector(nselR,0,0),e);
    ref_opened=e;
  }
  
  void setSelected(boolean b){
    selected = b;
    float[] Chsb = {colAngle,90,90};
    float[] Crgb = HSBtoRGB(Chsb);
    if(selected)
      img = createLight(Crgb[0]/255.0,Crgb[1]/255.0,Crgb[2]/255.0,50);
    else
      img = createLight(Crgb[0]/255.0,Crgb[1]/255.0,Crgb[2]/255.0,10);
  }
  
  float getColAngle(){
    return colAngle;
  }
  
  void draw(){
    for(int i=0;i<dotN;i++){
      pushMatrix();
      translate(p[i].x,p[i].y,p[i].z);
      image(img,0,0);
      popMatrix();
    }
  }
  
  void setState(boolean b){
    isClose = b;
  }
  
  boolean update(){
    if(isClose){
      deg.add(omega);
      if(deg.x>=360)
        deg.x=0;
      if(deg.y>=360)
        deg.y=0;
      if(deg.z>=360)
        deg.z=0;
      for(int i=0;i<dotN;i++){
        pushMatrix();
        rotateY(radians(deg.y));
        rotateX(radians(deg.x));
        rotateZ(radians(deg.z));
        PMatrix3D mat = (PMatrix3D)getMatrix();
        popMatrix();
      
        PVector e = new PVector();
        if(selected)
          mat.mult(new PVector(selR*v[i].x,selR*v[i].y,selR*v[i].z),e);
        else
          mat.mult(new PVector(nselR*v[i].x,nselR*v[i].y,nselR*v[i].z),e);
        ref_closed[i]=e;
      }
    }
    else{
      pushMatrix();
      rotateZ(radians(colAngle));
      PMatrix3D mat = (PMatrix3D)getMatrix();
      popMatrix();
      PVector e = new PVector();
      mat.mult(new PVector(nselR,0,0),e);
      ref_opened=e;
    }
    
    boolean equib = true;
    if(isClose){
      for(int i=0;i<dotN;i++){
        PVector def = PVector.sub(ref_closed[i], p[i]);
        def.mult(Kref);
        p[i].add(def);
        if(def.x*def.x+def.y*def.y+def.z*def.z>TH_REF){
          equib = false;
        }
      }
    }
    else{
      for(int i=0;i<dotN;i++){
        PVector def = PVector.sub(ref_opened, p[i]);
        def.mult(Kref);
        p[i].add(def);
        if(def.x*def.x+def.y*def.y+def.z*def.z>TH_REF){
          equib = false;
        }
      }
    }
    
    return equib;
  }
}


class FWMarker{
  PVector v[];
  PVector center;
  
  int selcol = 0;
  
  public int status = 0;
  
  boolean isClose = true;
  
  ArrayList<TetraSetting> settings = new ArrayList<TetraSetting>();
  
  FWMarker(PVector p){
    center = p;
    pushMatrix();
    translate(center.x,center.y,center.z);
    for(int i=0;i<colN;i++){
      settings.add(new TetraSetting(new PVector(0.5,0.5,0.5),360/colN*(i+1),i==selcol));
    }   
    popMatrix();
  }
  
  void setSelCol(int idx){
    if(0<=idx&&idx<colN){
      settings.get(selcol).setSelected(false);
      settings.get(idx).setSelected(true);
      selcol=idx;
    }
  }
  float getColAngle(){
    return settings.get(selcol).getColAngle();
  }
  void setCenter(PVector p){
    center=p;
  }
  PVector getCenter(){
    return center;
  }
  
  
  void draw(){
    pushMatrix();
    translate(center.x,center.y,center.z);
    for(int i=0;i<settings.size();i++){
      settings.get(i).draw();
    }
    popMatrix();
  }
  
  void update(){
    pushMatrix();
    translate(center.x,center.y,center.z);
    for(int i=0;i<settings.size();i++){
      settings.get(i).update();
    }
    popMatrix();
  }
  
  void setState(boolean b){
    isClose=b;
    
    for(int i=0;i<settings.size();i++){
      settings.get(i).setState(b);
    }
  }
  boolean getState(){
    return isClose;
  }
};
