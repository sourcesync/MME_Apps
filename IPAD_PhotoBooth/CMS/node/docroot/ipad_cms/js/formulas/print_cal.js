var c; //cost

//********** tier cost AKA Paper cost  Change able in the admin **********
var T1a = 47; // tier cost
var T2a = 57; // tier cost
var T3a = 63; // tier cost
var T1b = 34; // tier cost
var T2b = 41; // tier cost
var T3b = 45; // tier cost

//**************************** Change ******************************
var x = 42; // enter 42 or 58
var t = 1; // Tier number 
var l = 24; // the long side of the prvar
var s = 42; // the short side of the prvar
//**************************** Change ******************************



function wide_price_func() {
  if (x == 58) {

    if (t == 1) {
      if (x > l) { 
        c = (l / 12) * T1a;
      }
      else { 
        c = (s / 12) * T1a;
      }
    }
    if (t == 2) {
      if (x > l) { 
        c = (l / 12) * T2a;
      }
      else { 
        c = (s / 12) * T2a;
      }
    }
    if (t == 3) {
      if (x > l) { 
        c = (l / 12) * T3a;
        console.log("Long");
      }
      else { 
        c = (s / 12) * T3a;
        console.log("Short");
      }
    }
  }

  if (x == 42) {

    if (t == 1) {
      if (x > l) { 
        c = (l / 12) * T1b;
      }
      else { 
        c = (s / 12) * T1b;
      }
    }
    if (t == 2) {
      if (x > l) { 
        c = (l / 12) * T2b;
      }
      else { 
        c = (s / 12) * T2b;
      }
    }
    if (t == 3) {
      if (x > l) { 
        c = (l / 12) * T3b;
        console.log("Long");
      }
      else { 
        c = (s / 12) * T3b;
        console.log("Short");
      }
    }
  }

  console.log(c);  //prvar cost
}


