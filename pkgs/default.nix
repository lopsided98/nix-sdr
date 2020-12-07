self: super: {
  rtlamr = self.callPackage ./rtlamr { };

  rtlamr-collect = self.callPackage ./rtlamr-collect { };

  rtl-433 = self.callPackage ./rtl-433 { };

  sdrtrunk = self.callPackage ./sdrtrunk { };
}
