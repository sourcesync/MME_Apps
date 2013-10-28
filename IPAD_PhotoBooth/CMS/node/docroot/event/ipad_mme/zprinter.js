var cCl; //cost
var cBl; //cost
var cCy; //cost
var cMa; //cost
var cYo; //cost
var cPo; //cost
var cIn; //cost
var c; //cost
var In; //Infiltrant used in ml
var x;

//********** lookups from the admin window  **********
var ClC = .21; // Cost per ml
var BlC = .18; // Cost per ml
var CyC = .30; // Cost per ml
var MaC = .30; // Cost per ml
var YoC = .30; // Cost per ml
var PoC = .30; // Cost per ml
var InC = .25; // Cost per ml
var cP = .10; //percent increase 0-1

//**************************** Change ******************************
//Binder
var Cl = 42; // binder used in ml
var Bl = 1; // binder used in ml
var Cy = 24; // binder used in ml
var Ma = 42; // binder used in ml
var Yo = 24; // binder used in ml

//Power
var Po = 1.50; //Power used in cubic inchs

//Infiltrant 
var TSA = 0; //Total_Suface_Area


//**************************** Change ******************************

function zprinter_price_func() {
 
  In = (TSA * .61)*InC;
  cCl = ClC * Cl;
  cBl = BlC * Bl;
  cCy = CyC * Cy;
  cMa = MaC * Ma;
  cYo = YoC * Yo;
  cPo = PoC * Po;
  cIn = InC * In;
x =(cCl + cBl + cCy + cMa + cYo + cPo + cIn) * cP;
c = cCl + cBl + cCy + cMa + cYo + cPo + cIn + x;
console.log(c);  //prvar cost
}
