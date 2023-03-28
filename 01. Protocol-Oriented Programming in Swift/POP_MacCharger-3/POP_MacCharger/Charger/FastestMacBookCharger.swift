struct FastestMacBookCharger: Chargeable, Portable {
    var maximumWattPerHour: WattPerHour = 106
    
    func convert(chargeableWattPerHour: WattPerHour) -> WattPerHour {
        if self.maximumWattPerHour > chargeableWattPerHour {
            return chargeableWattPerHour
        } else {
            return self.maximumWattPerHour
        }
    }
}
