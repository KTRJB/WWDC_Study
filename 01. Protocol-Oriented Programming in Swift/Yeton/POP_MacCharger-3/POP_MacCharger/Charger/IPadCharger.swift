struct IPadCharger: Chargeable {
    var maximumWattPerHour: WattPerHour = 30
    
    func convert(chargeableWattPerHour: WattPerHour) -> WattPerHour {
        if self.maximumWattPerHour > chargeableWattPerHour {
            return chargeableWattPerHour
        } else {
            return self.maximumWattPerHour
        }
    }
}
