float c; //cost
float x; 
float m; // multapier for the pionts in the file 
float t; // run time
float tvc; // call for the time used vector cutting
float tve; // call for the time used vector etching
float tre; // call for the time used of raster etching
float RE; // raster etch SQ

//********** lookups from the admin window  **********

float cP = .10;  //percent increase 0-1
float cSre = 30;  //Speed of the laser when raster etching
float cSvc = 0; //Speed of the laser when vector cutting
float cSve = 0;  //Speed of the laser when vector etching
float cPM = .85; // cost per minute

//**************************** Change ******************************

float p = 100; // pionts in the Vector
float REw = 10; // raster etch width 
float REh = 10; // raster etch  height
float VE = 0; // Vector etch length
float VC = 0; // Vector cut length
float H = 0;  // Special handling charge 

//**************************** Change ******************************

void setup() {

  if (p <= 12000) {
    if (p <= 11000 ) {
      if (p <= 10000) {
        if (p <= 9000) {
          if (p <= 8000) {
            if (p <= 7000) {
              if (p <= 6000) {
                if (p <= 5000) {
                  if (p <= 4000) {
                    if (p <= 3000) {
                      if (p <= 2000) {
                        if (p <= 1000) {
                          m = 2.1;
                        }
                        m = 2;
                      }
                      m = 1.9;
                    }
                    m = 1.8;
                  }
                  m = 1.7;
                }
                m = 1.6;
              }
              m = 1.5;
            }
            m = 1.4;
          }
          m = 1.3;
        }
        m = 1.2;
      }
      m = 1.1;
    }
    m = 1;
  }

  //**************************** Vector cut Cal ******************************

  if (cSvc >= 10) {
    if (cSvc >= 20) {
      if (cSvc >= 30) {
        if (cSvc >= 40) {
          if (cSvc > 50) {
            tvc = VC * .36;
          }
          tvc = VC * .37;
        }
        tvc = VC * .38;
      }
      tvc = VC * .44;
    }
    tvc = VC * .64;
  }
  if (cSvc == 9) {
    tvc = VC * 1.4;
  }
  if (cSvc == 8) {
    tvc = VC * 1.4;
  }
  if (cSvc == 7) {
    tvc = VC * 1.6;
  }
  if (cSvc == 6) {
    tvc = VC * 1.6;
  }
  if (cSvc == 5) {
    tvc = VC * 1.8;
  }
  if (cSvc == 4) {
    tvc = VC * 2.1;
  }
  if (cSvc == 3) {
    tvc = VC * 2.6;
  }
  if (cSvc == 2) {
    tvc = VC * 3.4;
  }
  if (cSvc == 1) {
    tvc = VC * 6;
  }
  if (cSvc == .9) {
    tvc = VC * 12;
  }
  if (cSvc == .8) {
    tvc = VC * 13;
  }
  if (cSvc == .7) {
    tvc = VC * 13;
  }
  if (cSvc == .6) {
    tvc = VC * 15;
  }
  if (cSvc == .5) {
    tvc = VC * 15;
  }
  if (cSvc == .4) {
    tvc = VC * 16;
  }
  if (cSvc == .3) {
    tvc = VC * 21;
  }
  if (cSvc == .2) {
    tvc = VC * 27;
  }
  if (cSvc == .1) {
    tvc = VC * 45;
  }

  //**************************** Vector Etching Cal ******************************


  if (cSve >= 10) {
    if (cSve >= 20) {
      if (cSve >= 30) {
        if (cSve >= 40) {
          if (cSve > 50) {
            tve = VE * .36;
          }
          tve = VE * .37;
        }
        tve = VE * .38;
      }
      tve = VE * .44;
    }
    tve = VE * .64;
  }
  if (cSve == 9) {
    tve = VE * 1.4;
  }
  if (cSve == 8) {
    tve = VE * 1.4;
  }
  if (cSve == 7) {
    tve = VE * 1.6;
  }
  if (cSve == 6) {
    tve = VE * 1.6;
  }
  if (cSve == 5) {
    tve = VE * 1.8;
  }
  if (cSve == 4) {
    tve = VE * 2.1;
  }
  if (cSve == 3) {
    tve = VE * 2.6;
  }
  if (cSve == 2) {
    tve = VE * 3.4;
  }
  if (cSve == 1) {
    tve = VE * 6;
  }
  if (cSve == .9) {
    tve = VE * 12;
  }
  if (cSve == .8) {
    tve = VE * 13;
  }
  if (cSve == .7) {
    tve = VE * 13;
  }
  if (cSve == .6) {
    tve = VE * 15;
  }
  if (cSve == .5) {
    tve = VE * 15;
  }
  if (cSve == .4) {
    tve = VE * 16;
  }
  if (cSve == .3) {
    tve = VE * 21;
  }
  if (cSve == .2) {
    tve = VE * 27;
  }
  if (cSve == .1) {
    tve = VE * 45;
  }



  //**************************** Raster Etching Cal ******************************

  RE = REw * REh;

  if (cSre >= 20) {
    if (cSre >= 25) {
      if (cSre >= 30) {
        if (cSre >= 35) {
          if (cSre > 40) {
            if (cSre > 50) {
              tre = RE * 63;
            }
            tre = RE * 66;
          }
          tre = RE * 69;
        }
        tre = RE * 73;
      }
      tre = RE * 70;
    }
    tre = RE * 75;
  }
  if (cSre == 19) {
    tre = RE * 119;
  }
  if (cSre == 18) {
    tre = RE * 121;
  }
  if (cSre == 17) {
    tre = RE * 124;
  }
  if (cSre == 16) {
    tre = RE * 227;
  }
  if (cSre == 15) {
    tre = RE * 130;
  }
  if (cSre == 14) {
    tre = RE * 134;
  }
  if (cSre == 13) {
    tre = RE * 139;
  }
  if (cSre == 12) {
    tre = RE * 143;
  }
  if (cSre == 11) {
    tre = RE * 150;
  }
  if (cSre == 10) {
    tre = RE * 156;
  }
  if (cSre == 9) {
    tre = RE * 165;
  }
  if (cSre == 8) {
    tre = RE * 175;
  }
  if (cSre == 7) {
    tre = RE * 188;
  }
  if (cSre == 6) {
    tre = RE * 204;
  }
  if (cSre == 5) {
    tre = RE * 227;
  }
  if (cSre == 4) {
    tre = RE * 257;
  }
  if (cSre == 3) {
    tre = RE * 304;
  }
  if (cSre == 2) {
    tre = RE * 381;
  }
  if (cSre == 1) {
    tre = RE * 536;
  }
  if (cSre == .9) {
    tre = RE * 999;
  }
  if (cSre == .8) {
    tre = RE * 1103;
  }
  if (cSre == .7) {
    tre = RE * 1230;
  }
  if (cSre == .6) {
    tre = RE * 1397;
  }
  if (cSre == .5) {
    tre = RE * 1617;
  }
  if (cSre == .4) {
    tre = RE * 2389;
  }
  if (cSre <= .3) {
    tre = RE * 3163;
  }



  t = (((tvc + tve) * m + tre) / 60);
  c = t * cPM + H; 
  println("Vector Cut time:"+" " + tvc * m / 60);
  println("Vector Etch time:"+" " + tve * m / 60);
  println("Raster Etch time:"+" " + tre * m / 60);
  println("Total Time:"+" " + t);
  println("Cost:"+" " + c);  //print cost
}

