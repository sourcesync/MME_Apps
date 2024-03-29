float c; //cost
float x; 


//********** lookups from the admin window  **********

float cP = .10;  //percent increase 0-1
float b1 = 10;  //base cost for class 1
float b2 = 15; //base cost for class 2
float b3 = 25;  //base cost for class 3
float rs1 = 0;  //cost for resolution 1
float rs2 = .05;  //cost for resolution 2
float rs3 = .10;  //cost for resolution 3
float cl1 = 0;  //cost for class 1
float cl2 = .10;  //cost for class 2
float cl3 = .25;  //cost for class 3
float cR = .15; // cost per cubic inch

//**************************** Change ******************************

float h = 8;
float w = 8;
float d = 8; 
float cl = 1;  //class of 3d scan put a 1, 2, or 3  
float rs = 1; //resolution of 3d scan put a 1, 2, or 3  

//**************************** Change ******************************

void setup() {
  
  x = h * w * d;
  
  if(cl == 1){
    if(rs == 1){
      c = (cR + cl1 + rs1) * x + b1;
    }
    if(rs == 2){
      c = (cR + cl1 + rs2) * x + b1;
    }
    if(rs == 3){
      c = (cR + cl1 + rs3) * x + b1;
    }
  }
 
   if(cl == 2){
    if(rs == 1){
      c = (cR + cl2 + rs1) * x + b2;
    }
    if(rs == 2){
      c = (cR + cl2 + rs2) * x + b2;
    }
    if(rs == 3){
      c = (cR + cl2 + rs3) * x + b2;
    }
  } 

   if(cl == 3){
    if(rs == 1){
      c = (cR + cl3 + rs1) * x + b3;
    }
    if(rs == 2){
      c = (cR + cl3 + rs2) * x + b3;
    }
    if(rs == 3){
      c = (cR + cl3 + rs3) * x + b3;
    }
  }
  println("Class:" + " " + cl);
  println("Cost:" + " " + c);  //print cost
}

