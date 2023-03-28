struct IphoneCharger: Chargeable {
    var maximumWattPerHour: WattPerHour = 18
    
    func convert(chargeableWattPerHour: WattPerHour) -> WattPerHour {
        if self.maximumWattPerHour > chargeableWattPerHour {
            return chargeableWattPerHour
        } else {
            return self.maximumWattPerHour
        }
    }
}
