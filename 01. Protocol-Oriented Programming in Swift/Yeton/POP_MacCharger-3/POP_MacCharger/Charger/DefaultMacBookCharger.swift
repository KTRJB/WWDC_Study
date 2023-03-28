struct DefaultMacBookCharger: Chargeable, Portable {
    var maximumWattPerHour: WattPerHour = 96
    
    func convert(chargeableWattPerHour: WattPerHour) -> WattPerHour {
        if self.maximumWattPerHour > chargeableWattPerHour {
            return chargeableWattPerHour
        } else {
            return self.maximumWattPerHour
        }
    }
}
