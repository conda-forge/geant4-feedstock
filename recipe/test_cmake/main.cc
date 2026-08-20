#include <iostream>

#include "G4SystemOfUnits.hh"
#include "G4ThreeVector.hh"
#include "G4Version.hh"

int main()
{
  std::cout << "Geant4 version: " << G4Version << " (" << G4Date << ")" << std::endl;

  // Touches CLHEP through Geant4's own headers, so a mismatched CLHEP shows up
  // here rather than in a downstream feedstock.
  G4ThreeVector v(3.0 * cm, 4.0 * cm, 0.0);
  std::cout << "|v| = " << v.mag() / cm << " cm" << std::endl;
  if (std::abs(v.mag() / cm - 5.0) > 1e-9) {
    std::cerr << "unexpected magnitude" << std::endl;
    return 1;
  }
  return 0;
}
