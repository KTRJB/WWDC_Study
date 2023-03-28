struct MacBook: Portable {
    typealias WattPerHour = Int
    typealias Watt = Int
    var deviceAllowableChargingWatt: Watt
    var currentChargedBattery: Watt
    var maximumBatteryCapacity: Watt = 100
    mutating func chargeBattery(charger: Chargeable) {
        let wattPerHour = charger.convert(chargeableWattPerHour: self.deviceAllowableChargingWatt)
        let restBattery = maximumBatteryCapacity - currentChargedBattery
        print("충전해야 하는 배터리 용량 : \(restBattery)")
        if restBattery / wattPerHour <= 0 {
            print("충전 시간 : 1")
            return
        }
        let chargeTime = restBattery / wattPerHour + ((restBattery / wattPerHour) % wattPerHour > 1 ? 1 : 0)
        self.currentChargedBattery = maximumBatteryCapacity
        print("충전 시간 : \(chargeTime)")
    }
}
