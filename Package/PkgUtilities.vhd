package PkgUtilities is
  
  -- operations defined for a PE Core
  type CoreOperation_t is (NoOperation, ForwardPass, BackwardPass);
  
  -- 8-bit natural type
  type ShortNatural_t is range 0 to 255;
  
  -- array of booleans
  type BooleanArray_t is array (natural range <>) of boolean;
  
end package PkgUtilities;

package body PkgUtilities is
  
end package body PkgUtilities;
