import java.util.*;

import ddf.minim.*;
import com.leapmotion.leap.Controller; 
import com.leapmotion.leap.Frame; 
import com.leapmotion.leap.HandList; 
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.FingerList; 
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Vector;


static final float disN = 5;
static final float initR = 5;
static final int fireN = 512;





class Fireworks{
  int num=fireN;// num of light
  int L=50;// max length of trajectory
  
  PVector centerPosition;
  
  //initial velocity
  PVector velocity=new PVector(0,-14,0);
  PVector accel=new PVector(0,0.1,0);
  PVector accel_=new PVector(0,0.03,0);
  PImage img;
  PImage subimg1;
  PImage subimg2;
  PImage subimg3;

  float K = 15;
  float D = 0.85;
  float fluctuation = 8;

  PVector[] firePosition=new PVector[num];
  PVector[] fireVelocity=new PVector[num];
  int[] fireKind=new int[num];
  ArrayList<PVector> fireTrajectory= new ArrayList<PVector>();
  
  boolean opened=false;
  
  
  AudioPlayer don = minim.loadFile( "don.wav" );
  //AudioPlayer hu = minim.loadFile( "hu.wav" );


  Fireworks(PVector center,float colAngle){
    centerPosition = center;
    float cosTheta;
    float sinTheta;
    float phi;
    
    for (int i=0;i<num;i++){
      cosTheta = random(0,1) * 2 - 1;
      sinTheta = sqrt(1 - cosTheta*cosTheta);
      phi = random(0,1) * 2 * PI;
      float d;
      if(random(0,1)<0.7){
        fireKind[i]=0;
        d=initR;
      }
      else if(random(0,1)<0.5){
        fireKind[i]=1;
        d=initR*random(0.5,0.7);
      }
      else if(random(0,1)<0.5){
        fireKind[i]=2;
        d=initR*random(0.0,0.3);
      }
      else{
        fireKind[i]=3;
        d=initR*random(0.0,0.3);
      }
      firePosition[i]=new PVector(d * sinTheta * cos(phi),d * sinTheta * sin(phi),d * cosTheta);
    }
    
    float[] Chsb = {colAngle+5.0*(random(0,1)-0.5),random(80,100),random(80,100)};
    float[] Crgb = HSBtoRGB(Chsb);
    img=createLight(Crgb[0]/255.0,Crgb[1]/255.0,Crgb[2]/255.0,10);
    
    float sig;
    if(random(0,1)>0.5)
      sig = 1.0;
    else
      sig = -1.0;
    
    
    Chsb[0] = Chsb[0]+sig*random(40,100);
    Chsb[1] = random(80,100);
    Chsb[2] = random(80,100);
    Crgb = HSBtoRGB(Chsb);
    subimg1=createLight(Crgb[0]/255.0,Crgb[1]/255.0,Crgb[2]/255.0,10);
    
    Chsb[0] = Chsb[0]+sig*random(40,100);
    Chsb[1] = random(80,100);
    Chsb[2] = random(80,100);
    Crgb = HSBtoRGB(Chsb);
    subimg2=createLight(Crgb[0]/255.0,Crgb[1]/255.0,Crgb[2]/255.0,10);
    
    Chsb[0] = random(0,360);
    Chsb[1] = random(80,100);
    Chsb[2] = random(80,100);
    Crgb = HSBtoRGB(Chsb);
    subimg3=createLight(Crgb[0]/255.0,Crgb[1]/255.0,Crgb[2]/255.0,10);
  
    //hu.play();
  }

  void display(){
    if(opened){
      for (int i=0;i<num;i++){
        pushMatrix();
        translate(centerPosition.x,centerPosition.y,centerPosition.z);
        translate(firePosition[i].x,firePosition[i].y,firePosition[i].z);
        switch(fireKind[i]){
          case 0:
          image(img,0,0);
          break;
          case 1:
          image(subimg1,0,0);
          break;
          case 2:
          image(subimg2,0,0);
          break;
          case 3:
          image(subimg3,0,0);
          break;
        }
        popMatrix();
      }
    }
    else{
      for (int i=0;i<fireTrajectory.size();i++){
        pushMatrix();
        translate(fireTrajectory.get(i).x,fireTrajectory.get(i).y,fireTrajectory.get(i).z);
        image(img,0,0);
        popMatrix();
      }
    }
  }

  void update(){
    if(velocity.y>0&&!opened){
      for (int i=0;i<num;i++){
        fireVelocity[i]=PVector.mult(firePosition[i],K);
      }
      opened=true;
      don.play();
    }
    
    centerPosition.add(velocity);
    if(!opened){
      velocity.add(accel);
      fireTrajectory.add(new PVector(centerPosition.x+random(0,fluctuation)-fluctuation/2,centerPosition.y,centerPosition.z+random(0,fluctuation)-fluctuation/2));
      if(fireTrajectory.size()>=L)
        fireTrajectory.remove(0);
    }
    else{
      velocity.add(accel_);
      for(int i=0;i<num;i++){
        firePosition[i]=PVector.add(firePosition[i],fireVelocity[i]);
        fireVelocity[i]=PVector.mult(fireVelocity[i],D);
      }
      num-=(int)((float)disN*random((float)num/fireN,1));
    }
  }
};
