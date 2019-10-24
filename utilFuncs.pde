import java.awt.Color;

static final int[] rgbRange = {255, 255, 255};
static final int[] hsbRange = {360, 100, 100};

PImage createLight(float rPower,float gPower,float bPower,float dist){
  int side=64;
  float center=side/2.0;

  PImage img=createImage(side,side,RGB);

  for(int y=0;y<side;y++){
    for(int x=0;x<side;x++){
      float distance=(sq(center-x)+sq(center-y))/dist;
      int r=int((255*rPower)/distance);
      int g=int((255*gPower)/distance);
      int b=int((255*bPower)/distance);
      img.pixels[x+y*side]=color(r,g,b);
    }
  }
  return img;
}

float[] RGBtoHSB(float[] rgb){
  float[] hsb = new float[3];
  float[] hsb_temp = Color.RGBtoHSB((int)(rgb[0] * (255.0 / (float)rgbRange[0])), 
                                   (int)(rgb[1] * (255.0 / (float)rgbRange[1])), 
                                   (int)(rgb[2] * (255.0 / (float)rgbRange[2])), null);
  hsb[0] = (hsb_temp[0] * (float)hsbRange[0]);
  hsb[1] = (hsb_temp[1] * (float)hsbRange[1]);
  hsb[2] = (hsb_temp[2] * (float)hsbRange[2]);                                                             
  return hsb;
}

float[] HSBtoRGB(float[] hsb){
  float[] rgb = new float[3];
  if(hsb[0]>360)hsb[0]-=360.0;
  if(hsb[0]<0)hsb[0]+=360.0;
  Color colorRGB = new Color(Color.HSBtoRGB(hsb[0] / (float)hsbRange[0], 
                                            hsb[1] / (float)hsbRange[1], 
                                            hsb[2] / (float)hsbRange[2]));  
  rgb[0] = ((float)colorRGB.getRed() * ((float)rgbRange[0] / 255.0));
  rgb[1] = ((float)colorRGB.getGreen() * ((float)rgbRange[1] / 255.0));
  rgb[2] = ((float)colorRGB.getBlue() * ((float)rgbRange[2] / 255.0));
  return rgb;
}
