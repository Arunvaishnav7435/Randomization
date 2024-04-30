//SV Topics : Randomization
//Problem statement : to generate random values in two arrays such that their size should be either 10 or 20 with 10 having 80% chance. All the elements of both array should be unique. If element in arr is odd then the element with same index should be odd in brr and vice a versa. Used inline constraint to override soft constraint of range
//======================================

class SIZE;
  rand int size;
  
  constraint limit{size dist{10:=8, 20:=2};}  //distributed size constraint
endclass

class values;
  rand int arr []; 		//dynamic array
  rand int brr [];
  SIZE S;
  
  extern function new();
  extern function void print();
      
    constraint prec {solve arr before brr;}	//brr will be randomized before arr
    constraint un{unique {arr, brr};}        //unique values for arr and brr
    constraint INSIDE {foreach(arr[i]) {soft arr[i] inside{[1:100]};} foreach(brr[i]) {brr[i] inside{[1:100]};}}//defined range of possible values
      constraint Onbrr {foreach (brr[i]) {if(arr[i]%2==0) brr[i]%2 != 0; else brr[i]%2==0;}}//if arr[i] is odd then brr[i] should be even and  vice a versa
endclass

function values::new();
  S = new;  //creating object for randomization
  
  assert(!S.randomize())
    $display("array size randomization failed");  //randomizing size of array
    
  arr = new[S.size];//creating dynamic array
  brr = new[S.size];
endfunction
  
function void values::print();
  $display("array arr = %p\narray brr = %p\nsize = %0d", this.arr, this.brr, this.S.size);
endfunction
    
module test;
  values v;
  
  initial begin
    v = new;
    
    assert(!v.randomize())
      $display("randomization failed");
    
    v.print();
      
    assert(!v.randomize() with {v.arr[1]==200;})
      $display("soft constraint randomization failed");
    
    v.print();
    
    $finish();
  end
endmodule
