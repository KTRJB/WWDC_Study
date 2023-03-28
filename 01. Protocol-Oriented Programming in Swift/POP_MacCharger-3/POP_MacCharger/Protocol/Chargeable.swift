protocol Chargeable {
    var maximumWattPerHour: WattPerHour { get set }
    func convert(chargeableWattPerHour: WattPerHour) -> WattPerHour
}
